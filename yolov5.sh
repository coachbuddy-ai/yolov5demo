#!/bin/bash
#SBATCH --job-name=train_model
#SBATCH --output=train_model_output.txt
#SBATCH --error=train_model_error.txt
#SBATCH --nodes=1
#SBATCH --mem=24G  # Adjust memory requirements based on your needs
#SBATCH --time=24:00:00
#SBATCH --partition=gpu

# Function to display usage
usage() {
    echo "Usage: $0 -u USERNAME -v VENV_NAME -d DATA_YAML_FILE [-e EPOCHS] [-b BATCH_SIZE] [-m MODEL] [-r REQUIRED_MEMORY] [-p SCRIPT_DIR]"
    exit 1
}

# Default values
EPOCHS=50
BATCH_SIZE=16
MODEL="yolov5s.yaml"
REQUIRED_MEMORY=24

# Parse command-line arguments
while getopts "u:v:d:e:b:m:r:p:" opt; do
    case "${opt}" in
        u) USERNAME=${OPTARG} ;;
        v) VENV_NAME=${OPTARG} ;;
        d) DATA_YAML_FILE=${OPTARG} ;;
        e) EPOCHS=${OPTARG} ;;
        b) BATCH_SIZE=${OPTARG} ;;
        m) MODEL=${OPTARG} ;;
        r) REQUIRED_MEMORY=${OPTARG} ;;
        p) SCRIPT_DIR=${OPTARG} ;;
        *) usage ;;
    esac
done

# Check mandatory arguments
if [[ -z "${USERNAME}" ]]; then
    echo "Error: username is required."
    usage
fi

if [[ -z "${VENV_NAME}" ]]; then
    echo "Error: virtual environment name is required."
    usage
fi

if [[ -z "${DATA_YAML_FILE}" ]]; then
    echo "Error: data.yaml is required."
    usage
fi

if [[ -z "${SCRIPT_DIR}" ]]; then
    echo "Error: current working directory is required."
    usage
fi

# Export variables for use in sourced scripts
export USERNAME
export VENV_NAME

# Set the working directory
cd "${SCRIPT_DIR}" || exit 1

echo "Working directory: $(pwd)"

# Echo the username to verify it was passed correctly
echo "Username: ${USERNAME}"
echo "Envname: ${VENV_NAME}"

# Debugging: Check if env.sh exists and is executable
if [[ ! -f "env.sh" ]]; then
    echo "Error: env.sh not found in the current directory."
    exit 1
fi

# Source env.sh
source env.sh

# Check if the virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: virtual environment activation failed."
    exit 1
fi

# Run the Python script with the specified arguments
python3 yolov5.py --data "${DATA_YAML_FILE}" --epochs "${EPOCHS}" --batch "${BATCH_SIZE}" --model "${MODEL}" --required_memory "${REQUIRED_MEMORY}"
