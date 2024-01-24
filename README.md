## Azure Blob Storage CLI Upload Tool
clouduploader is a simple CLI tool for uploading of files to Azure Blob Storage it has additional functionality to handle file conflicts 
by providing options to overwrite, skip, or rename files.

#### Prerequisites
Ensure the following prerequisites are installed and set up before using the tool.
* Azure CLI
* An Azure Subscription
* Azure Storage Account and Container
* Download the FileUploader.sh script

## Usage
You can easily upload files to Azure Blob Storage from your CLI using the alias you configured.
    
    clouduploader /path/to/your/file.*

* **Options**:
    When running clouduploader, if the file already exists in Azure Blob Storage, you will be prompted with options:
    
    * **Overwrite (O)** This will overwrite the existing file in the cloud.
    * **Skip (S)**: This will skip uploading the file and leave the existing cloud file untouched.
    * **Rename (R)**: This allows you to provide a new name for the file to be uploaded, avoiding overwriting or skipping.
      
## Setup
Log in to your Azure account through Azure CLI:
 ```  
    az login 
 ```

### User defined parameters
Files are upoloaded to a container so in the FileUploader.sh script: 
* **local container_name** = 'Your Azure Storage  container name'
* **local connection_string** = 'Your Azure Storage connection string'


### Set Up Aliases
To setup the **clouduploader** alias, add the following to your **.bashrc** 
or **.bash_profile** file:

```
    Alias cloud uploader = './FileUploader.sh' 
    function clouduploader() { ./FileUploader.sh "$1"; }
```
### Create a system-wide executable script
To run a script from anywhere in the system

  1. Move the script and ensure it's in your PATH ( **/usr/local/bin** or **~/bin**):
  
```
     #Move the script to /usr/local/bin
     sudo mv /path/to/your/FileUploader /usr/local/bin/FileUploader
      
     #Make sure it's executable
     sudo chmod +x /usr/local/bin/FileUploader
```
  
  2. Add the Bin Directory to Your PATH:
```
      export PATH="$HOME/bin:$PATH"
```
  3. Reload Your Shell Configuration to appply changes
     
```
      source ~/.bashrc
```

## TODO

**Function Trigger Connection**: 
Implement functionality to connect the storage account to an Azure Function trigger. This will enable automated processing of files once they are uploaded to the Blob Storage.


