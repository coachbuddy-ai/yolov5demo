#!/bin/bash

# Function to prompt user for password and encrypt it
encrypt_password() {
    local password
    
    # Prompt user for password
    echo -n "Enter your sudo password: "
    read -s password
    echo
    
    # Set up pinentry-tty as a temporary solution for batch mode
    export GPG_TTY=$(tty)
    
    # Encrypt the password using gpg with loopback pinentry
    echo "$password" | gpg --pinentry-mode loopback --symmetric --cipher-algo AES256 --output encrypted_password.gpg
    
    # Notify user about successful encryption
    echo "Password encrypted and stored securely."
}

# Main script starts here

# Call function to encrypt password
encrypt_password
