# Path to ExifTool
$exifToolPath = "C:\Users\sesha\Downloads\exiftool-13.03_64\exiftool.exe"

# Folder where videos are located
$videoFolder = "H:\MOBILE_UPLOADS\2016\1 Jan 2016\1_Jan_Videos"

# Get all video files in the folder (both MOV and MP4)
$videoFiles = Get-ChildItem -Path $videoFolder | Where-Object { $_.Extension -match '\.mov$|\.mp4$' }

# Create an array to store the output data
$outputData = @()

foreach ($videoFile in $videoFiles) {
    # Try to get the creation timestamp from ExifTool, suppress warnings
    $exifData = & $exifToolPath -DateTimeOriginal -s3 $videoFile.FullName 2>$null
    
    # If ExifTool has a timestamp, use it, else fallback to file system modified time
    if ($exifData) {
        $modifiedTimestamp = $exifData.Trim()
    } else {
        # Use file system's last modified date (LastWriteTime) if ExifTool doesn't provide one
        $modifiedTimestamp = $videoFile.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    }

    # Add the file name and modified timestamp to the output array
    $outputData += [PSCustomObject]@{
        "file name" = $videoFile.Name
        "modified date" = $modifiedTimestamp
    }
}

# Output the table in the desired format
$outputData | Format-Table -Property "file name", "modified date" -AutoSize
