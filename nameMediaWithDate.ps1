# Set the path to your photos directory
$photosPath = "D:\2023\1 Pregnancy\Journey\TimeLapse Pics\dump"

# Get all subfolders in the main photos directory
$subfolders = Get-ChildItem -Path $photosPath -Directory

# Loop through each subfolder
foreach ($folder in $subfolders) {
    # Get all the image files in the current subfolder
    $images = Get-ChildItem -Path $folder.FullName -Filter *.jpg -File

    # Get the creation date of the first image file to extract MM DD YY
    $firstImage = $images[0]
    $date = $firstImage.CreationTime.ToString("MM_dd_yy")

    # Initialize a counter for naming the files
    $counter = 1

    # Loop through each image file in the current subfolder
    foreach ($image in $images) {
        # Construct the new file name
        $newName = "{0}_{1:D2}.jpg" -f $date, $counter

        # Rename the image file
        $image | Rename-Item -NewName $newName

        # Increment the counter for the next file
        $counter++
    }
}
