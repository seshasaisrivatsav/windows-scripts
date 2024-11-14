# Set the path to your photos directory
$photosPath = "D:\2024\07 Jul\Dump"

# Get all the image files in the specified directory
$images = Get-ChildItem -Path $photosPath -Filter *.jpg -File

# Group images by creation date
$groupedImages = $images | Group-Object { $_.CreationTime.Date }

# Loop through each group of images
foreach ($group in $groupedImages) {
    # Extract the date from the first image in the group
    $date = $group.Group[0].CreationTime.ToString("MM_dd_yy")

    # Initialize a counter for naming the files
    $counter = 1

    # Loop through each image in the group
    foreach ($image in $group.Group) {
        # Construct the new file name
        $newName = "{0}_{1:D2}.jpg" -f $date, $counter

        # Rename the image file
        $image | Rename-Item -NewName $newName

        # Increment the counter for the next file
        $counter++
    }
}
