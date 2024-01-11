#!/bin/bash

# Function to upload file to Azure Blob Storage
upload_file_to_azure() {
    local file_path=$1
    local blob_name=$2
    local container_name="fileuploader-con"  # Replace with your container name
    local connection_string="DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=myazureresumestorageacct;AccountKey=+l+FwqKDi5nRUHv7dVohlQptnNMiWpqhfps9WsEgweiFoMEqU3UCuMKosT/LRlD1rqWE8tW/vTWI+ASt8lrjfg==;BlobEndpoint=https://myazureresumestorageacct.blob.core.windows.net/;FileEndpoint=https://myazureresumestorageacct.file.core.windows.net/;QueueEndpoint=https://myazureresumestorageacct.queue.core.windows.net/;TableEndpoint=https://myazureresumestorageacct.table.core.windows.net"  # Replace with your Azure Storage connection string
    local overwrite_mode=""

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

