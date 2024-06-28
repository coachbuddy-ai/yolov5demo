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
    echo "Usage: $0 -u USERNAME -v VENV_NAME -d DATA_YAML_FILE -s SCRIPT_DIR -p PASSPHRASE [-e EPOCHS] [-b BATCH_SIZE] [-m MODEL] [-r REQUIRED_MEMORY] [-t DEVICE_TYPE] [--train] [--predict] [--validate]"
    echo "   or: $0 --username USERNAME --venv VENV_NAME --data DATA_YAML_FILE --script-dir SCRIPT_DIR --passphrase PASSPHRASE [--epochs EPOCHS] [--batch-size BATCH_SIZE] [--model MODEL] [--memory REQUIRED_MEMORY] [--device DEVICE_TYPE] [--train] [--predict] [--validate]"
    exit 1
}

# Default values
EPOCHS=50
BATCH_SIZE=16
MODEL="yolov5s.yaml"
REQUIRED_MEMORY=24
DEVICE_TYPE="GPU"
MODE="train"  # Default mode

# Parse command-line arguments
OPTS=$(getopt -o u:v:d:e:b:m:r:s:t:p: --long username:,venv:,data:,epochs:,batch-size:,model:,memory:,script-dir:,device:,passphrase:,train,predict,validate -- "$@")
if [ $? != 0 ] ; then usage ; fi
eval set -- "$OPTS"

while true; do
    case "$1" in
        -u | --username ) USERNAME=$2; shift 2 ;;
        -v | --venv ) VENV_NAME=$2; shift 2 ;;
        -d | --data ) DATA_YAML_FILE=$2; shift 2 ;;
        -e | --epochs ) EPOCHS=$2; shift 2 ;;
        -b | --batch-size ) BATCH_SIZE=$2; shift 2 ;;
        -m | --model ) MODEL=$2; shift 2 ;;
        -r | --memory ) REQUIRED_MEMORY=$2; shift 2 ;;
        -s | --script-dir ) SCRIPT_DIR=$2; shift 2 ;;
        -t | --device ) DEVICE_TYPE=$2; shift 2 ;;
        -p | --passphrase ) PASSPHRASE=$2; shift 2 ;;
        --train ) MODE="train"; shift ;;
        --predict ) MODE="predict"; shift ;;
        --validate ) MODE="validate"; shift ;;
        -- ) shift; break ;;
        * ) break ;;
    esac
done

# Check mandatory arguments
if [[ -z "${USERNAME}" ]]; then
    echo "Error: username is required."
    usage
fi

if [[ -z "${PASSPHRASE}" ]]; then
    echo "Error: passphrase is required."
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
export DEVICE_TYPE
export PASSPHRASE
echo "${SCRIPT_DIR}"
# Set the working directory
cd "${SCRIPT_DIR}" || exit 1

echo "Working directory: $(pwd)"

# Echo the username to verify it was passed correctly
echo "Username: ${USERNAME}"
echo "Envname: ${VENV_NAME}"

# Define the path to env.sh relative to the base directory
ENV_SCRIPT="scripts/env.sh"

# Check if env.sh exists
if [[ ! -f "$ENV_SCRIPT" ]]; then
    echo "Error: $ENV_SCRIPT not found."
    exit 1
fi

# Source env.sh
source "$ENV_SCRIPT"

# Check if the virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: virtual environment activation failed."
    exit 1
fi

REQ_SCRIPT="scripts/requirements.sh"
# Source requirements.sh
source "$REQ_SCRIPT"

# Additional logic based on the mode selected
case "$MODE" in
    train )
        echo "Training mode selected."
        # Run the Python script with the specified arguments
        python3 yolov5.py --data "${DATA_YAML_FILE}" --epochs "${EPOCHS}" --batch "${BATCH_SIZE}" --model "${MODEL}" --required_memory "${REQUIRED_MEMORY}" --mode "${MODE}"

        ;;
    predict )
        echo "predicting mode not implemented."
        # NOT IMPLEMENTED
        python3 yolov5.py --data "${DATA_YAML_FILE}" --epochs "${EPOCHS}" --batch "${BATCH_SIZE}" --model "${MODEL}" --required_memory "${REQUIRED_MEMORY}" --mode "${MODE}"
        ;;
    validate )
        echo "Validation mode selected."
        python3 yolov5.py --data "${DATA_YAML_FILE}" --batch "${BATCH_SIZE}" --model "${MODEL}" --required_memory "${REQUIRED_MEMORY}" --mode "${MODE}"
        ;;
    * )
        echo "Unknown mode selected: $MODE"
        usage
        ;;
esac