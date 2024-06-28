#!/bin/bash

# Function to decrypt the password
decrypt_password() {
    local decrypted_password
    
    # Set up pinentry-tty as a temporary solution for batch mode
    export GPG_TTY=$(tty)

    # Decrypt the password using gpg with loopback pinentry
    decrypted_password=$(gpg --pinentry-mode loopback --decrypt encrypted_password.gpg 2>/dev/null)

    # Check if decryption was successful
    if [ $? -eq 0 ]; then
        # Output the decrypted password
        echo "Decrypted password: $decrypted_password"
    else
        echo "Decryption failed."
    fi
}

# Main script starts here

# Call function to decrypt password
decrypt_password
