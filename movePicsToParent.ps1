# Navigate to the parent folder containing all the subfolders
cd "D:\2024\07 Jul\Dump"

# Get a list of all subfolders
$subfolders = Get-ChildItem -Directory

# Loop through each subfolder
foreach ($folder in $subfolders) {
    # Get a list of all files in the subfolder
    $files = Get-ChildItem $folder.FullName -File

    # Move each file to the parent folder
    foreach ($file in $files) {
        Move-Item $file.FullName -Destination .
    }
}
