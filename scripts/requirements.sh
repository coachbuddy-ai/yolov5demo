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

# Function to decrypt the password
decrypt_password() {
    local passphrase="$1"
    
    # Set up pinentry-tty as a temporary solution for batch mode
    export GPG_TTY=$(tty)

    # Decrypt the password using gpg with loopback pinentry
    gpg --batch --yes --passphrase "$passphrase" --pinentry-mode loopback --decrypt encrypted_password.gpg 2>/dev/null
}


# Main script starts here
# Call function to decrypt password and capture its output
decrypted_password=$(decrypt_password "$PASSPHRASE")

# Check if decryption was successful
if [ $? -eq 0 ]; then
    # Check if the appropriate requirements file exists and install dependencies
    if [ -f "$REQUIREMENTS_FILE" ]; then
        echo "Installing dependencies from $REQUIREMENTS_FILE"
        echo "$decrypted_password" | sudo -S bash -c "yes | /home/$USERNAME/venvs/$VENV_NAME/bin/pip3.10 install -r $REQUIREMENTS_FILE"
        
        # Unset the decrypted_password variable to remove it from the environment
        unset decrypted_password
    else
        echo "Requirements file $REQUIREMENTS_FILE not found."
        exit 1
    fi
else
    echo "Decryption failed."
    exit 1
fi