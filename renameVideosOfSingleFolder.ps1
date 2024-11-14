# Set the path to your videos directory
$videosPath = "F:\HOME_MEDIA_POST_2024\CAMERA_UPLOADS\dump"

# Get all the video files in the main videos directory
$videos = Get-ChildItem -Path $videosPath -Filter *.mp4 -File

# Initialize a hashtable to keep track of the counters for each date
$dateCounters = @{}

# Loop through each video file in the main videos directory
foreach ($video in $videos) {
    # Get the creation date of the video file
    $creationDate = $video.CreationTime

    # Format the creation date as MM_dd_yyyy
    $date = $creationDate.ToString("MM_dd_yyyy")

    # Output the creation date and formatted date for debugging
    Write-Output "File: $($video.Name) - Creation Date: $creationDate - Formatted Date: $date"

    # Initialize the counter for this date if it doesn't exist
    if (-not $dateCounters.ContainsKey($date)) {
        $dateCounters[$date] = 0
    }

    # Increment the counter for this date
    $dateCounters[$date]++

    # Construct the new file name
    $newName = "{0}_{1:D2}.mp4" -f $date, $dateCounters[$date]

    # Rename the video file
    Rename-Item -Path $video.FullName -NewName (Join-Path -Path $video.DirectoryName -ChildPath $newName)
}
