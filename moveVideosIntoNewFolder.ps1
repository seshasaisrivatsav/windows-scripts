$sourceDir = "H:\MOBILE_UPLOADS\2016\12 Dec 2016"
$videoDir = "$sourceDir\Videos"

# Check if the video directory exists; if not, create it
if (!(Test-Path -Path $videoDir)) {
    Write-Output "Creating video directory at $videoDir"
    New-Item -ItemType Directory -Path $videoDir
}

# Define video file extensions
$videoExtensions = @(".MOV", ".MP4", ".AVI", ".MKV")

# Move each video file to the Video folder
Get-ChildItem -Path $sourceDir | ForEach-Object {
    if ($videoExtensions -contains $_.Extension.ToUpper()) {
        Write-Output "Moving file $($_.Name) to $videoDir"
        Move-Item -Path $_.FullName -Destination $videoDir
    } else {
        Write-Output "Skipping file $($_.Name); not a video"
    }
}
