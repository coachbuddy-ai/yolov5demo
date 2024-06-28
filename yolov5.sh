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
    echo "Usage: $0 -a VENV_ACTIVATE_PATH -d DATA_YAML_FILE [-e EPOCHS] [-b BATCH_SIZE] [-m MODEL] [-r REQUIRED_MEMORY] [-p SCRIPT_DIR]"
    exit 1
}

# Default values
EPOCHS=50
BATCH_SIZE=16
MODEL="yolov5s"
REQUIRED_MEMORY="24G"
SCRIPT_DIR=""

# Parse command-line arguments
while getopts "a:d:e:b:m:r:p:" opt; do
    case "${opt}" in
        a) VENV_ACTIVATE_PATH=${OPTARG} ;;
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
# Check if VENV_ACTIVATE_PATH is provided
if [[ -z "${VENV_ACTIVATE_PATH}" ]]; then
    echo "Error: virtual environment activation path is required."
    usage
fi

# Check if DATA_YAML_FILE is provided
if [[ -z "${DATA_YAML_FILE}" ]]; then
    echo "Error: data.yaml is required."
    usage
fi

# Check if SCRIPT_DIR is provided
if [[ -z "${SCRIPT_DIR}" ]]; then
    echo "Error: current working directory is required."
    usage
fi


# Activate the Python environment
source "${VENV_ACTIVATE_PATH}"

# Check if SCRIPT_DIR is provided and set the working directory
if [[ -n "${SCRIPT_DIR}" ]]; then
    cd "${SCRIPT_DIR}" || exit 1
fi


echo "Working directory: $(pwd)"

# Run the Python script with the specified arguments
# python3 yolov5.py --data ${DATA_YAML_FILE} --epochs ${EPOCHS} --batch ${BATCH_SIZE} --model ${MODEL} --required_memory ${REQUIRED_MEMORY}
