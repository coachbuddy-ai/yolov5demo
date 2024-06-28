#!/bin/bash

# Check if DEVICE_TYPE is set, default to GPU if not
if [ -z "$DEVICE_TYPE" ]; then
    DEVICE_TYPE="GPU"
fi

# Determine which requirements file to use based on DEVICE_TYPE
if [ "$DEVICE_TYPE" == "GPU" ]; then
    REQUIREMENTS_FILE="requirements-gpu.txt"
elif [ "$DEVICE_TYPE" == "CPU" ]; then
    REQUIREMENTS_FILE="requirements-cpu.txt"
else
    echo "Invalid DEVICE_TYPE specified: $DEVICE_TYPE. Must be 'GPU' or 'CPU'."
    exit 1
fi

# Check if the appropriate requirements file exists and install dependencies
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing dependencies from $REQUIREMENTS_FILE"
    echo "$PASSWORD" | sudo -S bash -c "yes | /home/$USERNAME/venvs/$VENV_NAME/bin/pip3.10 install -r $REQUIREMENTS_FILE"


    # Unset the PASSWORD variable to remove it from the environment
    unset PASSWORD
else
    echo "Requirements file $REQUIREMENTS_FILE not found."
    exit 1
fi
