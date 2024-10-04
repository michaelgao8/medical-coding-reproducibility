#!/bin/bash

# Function to prompt for input
prompt_for_input() {
    read -p "$1: " input
    echo $input
}

# Prompt for PhysioNet username and password
PHYSIONET_USER=$(prompt_for_input "Enter your PhysioNet username")
read -s -p "Enter your PhysioNet password: " PHYSIONET_PASSWORD
echo

# Prompt for directories to save downloads
MIMICIII_DIR="./mimicdata/mimiciii/"
MIMICIV_DIR="./mimicdata/mimiciv/"

# Create download directories if they don't exist
mkdir -p $MIMICIII_DIR
mkdir -p $MIMICIV_DIR
mkdir -p $MIMICIV_DIR/note  # Add this line to create the 'note' subdirectory
mkdir -p $MIMICIV_DIR/hosp  # Add this line to create the 'hosp' subdirectory

# Lists of files to download
MIMICIII_FILES=(
    "NOTEEVENTS.csv.gz"
    "DIAGNOSES_ICD.csv.gz"
    "PROCEDURES_ICD.csv.gz"
    "D_ICD_PROCEDURES.csv.gz"
    "D_ICD_DIAGNOSES.csv.gz"
    "ADMISSIONS.csv.gz"
    "PATIENTS.csv.gz"
    "CPTEVENTS.csv.gz"
)

MIMICIV_FILES=(
    "hosp/procedures_icd.csv.gz"
    "hosp/diagnoses_icd.csv.gz"
)

MIMICIV_NOTE_FILES=(
    "note/discharge.csv.gz"
)

# Base URLs for MIMIC-III and MIMIC-IV files
MIMICIII_BASE_URL="https://physionet.org/files/mimiciii/1.4"
MIMICIV_BASE_URL="https://physionet.org/files/mimiciv/2.2"
MIMICIV_NOTE_BASE_URL="https://physionet.org/files/mimic-iv-note/2.2"

# Function to download a list of files to a specified directory
download_files() {
    local BASE_URL=$1
    local FILES=("${!2}")
    local DEST_DIR=$3

    for FILE in "${FILES[@]}"; do
        local FULL_DEST_DIR="$DEST_DIR/$(dirname "$FILE")"
        mkdir -p "$FULL_DEST_DIR"
        wget --user=$PHYSIONET_USER --password=$PHYSIONET_PASSWORD -P "$FULL_DEST_DIR" $BASE_URL/$FILE
    done
}

# Download MIMIC-III files
download_files $MIMICIII_BASE_URL MIMICIII_FILES[@] $MIMICIII_DIR

# Download MIMIC-IV files
download_files $MIMICIV_BASE_URL MIMICIV_FILES[@] $MIMICIV_DIR

# Download MIMIC-IV notes
download_files $MIMICIV_NOTE_BASE_URL MIMICIV_NOTE_FILES[@] $MIMICIV_DIR

echo "Download complete."