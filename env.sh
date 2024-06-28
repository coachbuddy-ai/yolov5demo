#!/bin/bash

# Function to activate virtual environment
activate_venv() {
    source /home/$1/venvs/$2/bin/activate
}

# Function to check if virtual environment is activated
is_venv_activated() {
    if [ -n "$VIRTUAL_ENV" ] && [ "$VIRTUAL_ENV" == "/home/$1/venvs/$2" ]; then
        return 0  # Activated
    else
        return 1  # Not activated
    fi
}

# Function to create venvs directory if it doesn't exist
create_venvs_directory() {
    if [ ! -d "/home/$1/venvs" ]; then
        echo "Creating venvs directory"
        mkdir -p /home/$1/venvs
    fi
}

# Print usage information
print_usage() {
    echo "Usage: source $0 -u <username> -v <env_name>"
    echo "Example: source $0 -u srikanth -v yolov5demo"
}

# Parse command-line arguments
while getopts ":u:v:" opt; do
  case $opt in
    u) username=$OPTARG ;;
    v) env_name=$OPTARG ;;
    \?) echo "Invalid option -$OPTARG. Use -u for username and -v for environment name." >&2
        print_usage
        return 1 ;;
    :) echo "Option -$OPTARG requires an argument. Use -u for username and -v for environment name." >&2
       print_usage
       return 1 ;;
  esac
done

# Check if username is provided
if [ -z "$username" ]; then
    echo "Username (-u) is required."
    print_usage
    return 1
fi

# Check if environment name is provided
if [ -z "$env_name" ]; then
    echo "Environment name (-v) is required."
    print_usage
    return 1
fi

# Ensure venvs directory exists
create_venvs_directory $username

# Check if virtual environment exists
if [ -d "/home/$username/venvs/$env_name" ]; then
    echo "Activating existing virtual environment $env_name"
else
    echo "Creating virtual environment $env_name"
    python3.10 -m venv /home/$username/venvs/$env_name
fi

# Activate virtual environment
activate_venv $username $env_name

# Echo VIRTUAL_ENV to verify its value
echo "VIRTUAL_ENV is set to: $VIRTUAL_ENV"

# Check if virtual environment is activated
if is_venv_activated $username $env_name; then
    echo "Virtual environment $env_name is activated."
else
    echo "Failed to activate virtual environment $env_name. Please activate it manually."
    return 1
fi

# Install dependencies from requirements.txt if it exists
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt"
    /home/$username/venvs/$env_name/bin/pip3.10 install -r requirements.txt
fi

echo "Virtual environment $env_name is ready and activated."
