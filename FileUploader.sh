#!/bin/bash

# Function to upload file to Azure Blob Storage
upload_file_to_azure() {
    local file_path=$1
    local blob_name=$2
    local container_name="Your Azure Storage container name"  # Replace with your container name
    local connection_string="Your Azure Storage Account Connection string"   # Replace with your Azure Storage connection string


    # Check if the blob exists in Azure Blob Storage
    if az storage blob exists --name "$blob_name" --container-name "$container_name" --connection-string "$connection_string" --only-show-errors | grep -q '"exists": true'; then
        echo "Blob already exists in Azure. Choose action: [O]verwrite, [S]kip, [R]ename"
        read -p "Enter choice: " user_choice

        case $user_choice in
            [Oo]* )
                overwrite_mode="--overwrite"
                ;;
            [Ss]* )
                echo "Skipping upload."
                return 0
                ;;
            [Rr]* )
                read -p "Enter new blob name: " new_blob_name
                blob_name="$new_blob_name"
                ;;
            * )
                echo "Invalid choice. Exiting."
                return 1
                ;;
        esac
    fi

    # Proceed with upload
    az storage blob upload --file "$file_path" --name "$blob_name" --container-name "$container_name" --connection-string "$connection_string" $overwrite_mode --only-show-errors

    if [ $? -eq 0 ]; then
        echo "Upload successful"
    else
        echo "Upload failed"
    fi
}

# Main script starts here
if [ $# -eq 0 ]; then
    echo "No file specified. Usage: cloudupload <file_path>"
    exit 1
fi

file_path="$1"
blob_name=$(basename "$file_path")

# Call the upload function
upload_file_to_azure "$file_path" "$blob_name"

