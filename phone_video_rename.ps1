
# Folder where videos are located
$videoFolder = "H:\MOBILE_UPLOADS\2016\11 Nov 2016\11_Nov_VIDEOS"


# Path to ExifTool
$exifToolPath = "C:\Users\sesha\Downloads\exiftool-13.03_64\exiftool.exe"


# Get all video files in the folder (both MOV and MP4)
$videoFiles = Get-ChildItem -Path $videoFolder | Where-Object { $_.Extension -match '\.mov$|\.mp4$' }

foreach ($videoFile in $videoFiles) {
    # Use ExifTool to get the timestamp (DateTimeOriginal) or fallback to LastWriteTime
    $exifData = & $exifToolPath -DateTimeOriginal -s3 $videoFile.FullName 2>$null
    
    # If ExifTool provides a timestamp, use it; otherwise, fall back to the file system's LastWriteTime
    if ($exifData) {
        $modifiedTimestamp = $exifData.Trim()
        Write-Host "Processing file: $($videoFile.Name), ExifTool Timestamp: $modifiedTimestamp"
    }
    else {
        # Use LastWriteTime as the modified timestamp if ExifTool doesn't provide one
        $modifiedTimestamp = $videoFile.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        Write-Host "Processing file: $($videoFile.Name), LastModified Timestamp: $modifiedTimestamp"
    }
    
    # Construct the new file name using the modified timestamp
    $newFileName = $modifiedTimestamp.Replace(":", "-").Replace(" ", "_") + $videoFile.Extension
    
    # Full path for the new file name
    $newFilePath = Join-Path -Path $videoFolder -ChildPath $newFileName
    
    # Rename the file if necessary
    if ($videoFile.FullName -ne $newFilePath) {
        Write-Host "Renaming: $($videoFile.FullName) to $newFilePath"
        Rename-Item -Path $videoFile.FullName -NewName $newFilePath
    }
}
