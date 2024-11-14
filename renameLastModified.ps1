# Set the path to your photos directory
$photosPath = "D:\2023\1 Pregnancy\Journey\TimeLapse Pics\dump"

# Get all the image files in the specified directory
$images = Get-ChildItem -Path $photosPath -Filter *.jpg -File

# Group images by the modified date (LastWriteTime)
$groupedImages = $images | Group-Object { $_.LastWriteTime.Date }

# Loop through each group of images
foreach ($group in $groupedImages) {
    # Extract the date from the first image in the group
    $date = $group.Group[0].LastWriteTime.ToString("MM_dd_yy")

    # Initialize a counter for naming the files
    $counter = 1

    # Loop through each image in the group
    foreach ($image in $group.Group) {
        # Construct the new file name
        $newName = "{0}_{1:D2}.jpg" -f $date, $counter

        # Construct the full path to the new file name
        $newFilePath = Join-Path -Path $image.DirectoryName -ChildPath $newName

        # Rename the image file
        Rename-Item -Path $image.FullName -NewName $newFilePath

        # Increment the counter for the next file
        $counter++
    }
}
