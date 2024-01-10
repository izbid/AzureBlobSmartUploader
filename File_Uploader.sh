#!/bin/bash

# Function to upload file to Azure Blob Storage
upload_file_to_azure() {
    local file_path=$1
    local blob_name=$2
    local container_name="your_container_name"  # Replace with your container name
    local connection_string="your_connection_string"  # Replace with your Azure Storage connection string

    az storage blob upload --file "$file_path" --name "$blob_name" --container-name "$container_name" --connection-string "$connection_string" --only-show-errors
    if [ $? -eq 0 ]; then
        echo "Upload successful"
    else
        echo "Upload failed"
    fi
}

# Main script
file_path="$1"

if [ ! -f "$file_path" ]; then
    echo "File not found: $file_path"
    exit 1
fi

blob_name=$(basename "$file_path")
container_name="your_container_name"  # Replace with your container name
connection_string="your_connection_string"  # Replace with your Azure Storage connection string

# Check if the blob exists in Azure Blob Storage
if az storage blob exists --name "$blob_name" --container-name "$container_name" --connection-string "$connection_string" --only-show-errors | grep -q '"exists": true'; then
    echo "Blob already exists in Azure. Choose action: [O]verwrite, [S]kip, [R]ename"
    read -p "Enter choice: " user_choice

    case $user_choice in
        [Oo]* )
            upload_file_to_azure "$file_path" "$blob_name"
            ;;
        [Ss]* )
            echo "Skipping upload."
            ;;
        [Rr]* )
            read -p "Enter new blob name: " new_blob_name
            upload_file_to_azure "$file_path" "$new_blob_name"
            ;;
        * )
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
else
    # Blob doesn't exist, proceed with upload
    upload_file_to_azure "$file_path" "$blob_name"
fi
