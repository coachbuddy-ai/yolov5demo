#!/bin/bash

# Function to activate virtual environment
activate_venv() {
    source /home/$USERNAME/venvs/$VENV_NAME/bin/activate
}

# Function to check if virtual environment is activated
is_venv_activated() {
    if [ -n "$VIRTUAL_ENV" ] && [ "$VIRTUAL_ENV" == "/home/$USERNAME/venvs/$VENV_NAME" ]; then
        return 0  # Activated
    else
        return 1  # Not activated
    fi
}

# Function to create venvs directory if it doesn't exist
create_venvs_directory() {
    if [ ! -d "/home/$USERNAME/venvs" ]; then
        echo "Creating venvs directory"
        mkdir -p /home/$USERNAME/venvs
    fi
}

# Ensure venvs directory exists
main() {
    create_venvs_directory $USERNAME

    # Check if virtual environment exists
    if [ -d "/home/$USERNAME/venvs/$VENV_NAME" ]; then
        echo "Activating existing virtual environment $VENV_NAME"
    else
        echo "Creating virtual environment $VENV_NAME"
        python3.10 -m venv /home/$USERNAME/venvs/$VENV_NAME
    fi

    # Activate virtual environment
    activate_venv $USERNAME $VENV_NAME

    # Echo VIRTUAL_ENV to verify its value
    echo "VIRTUAL_ENV is set to: $VIRTUAL_ENV"

    # Check if virtual environment is activated
    if is_venv_activated $USERNAME $VENV_NAME; then
        echo "Virtual environment $VENV_NAME is activated."
    else
        echo "Failed to activate virtual environment $VENV_NAME. Please activate it manually."
        return 1
    fi
    
    echo "Virtual environment $VENV_NAME is ready and activated."
}

# Only call main if the script is being sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    main
fi
