# Define paths
$listFilePath = "C:\Users\sesha\Desktop\list_of_files"
$searchRoot = "D:\"
$outputFolder = "F:\temp\Output"
$resultFolder = "F:\temp\Result"

# Create Output and Result folders if they don't exist
New-Item -ItemType Directory -Force -Path $outputFolder | Out-Null
New-Item -ItemType Directory -Force -Path $resultFolder | Out-Null

# Function to calculate file hash
function Get-FileHashValue {
    param ($filePath)
    (Get-FileHash -Path $filePath -Algorithm SHA256).Hash
}

# Read file names from list_of_files
$fileNames = Get-Content -Path $listFilePath

foreach ($fileName in $fileNames) {
    # Search for file in D:\ and subdirectories
    $matches = Get-ChildItem -Path $searchRoot -Recurse -Filter $fileName -File -ErrorAction SilentlyContinue

    if ($matches.Count -eq 1) {
        # Single match - Copy to Output folder
        Copy-Item -Path $matches.FullName -Destination $outputFolder -Force
    }
    elseif ($matches.Count -gt 1) {
        # Multiple matches - Copy to Result folder with suffixes (_1, _2, _3, etc.)
        $uniqueFiles = @{}
        $counter = 1

        foreach ($match in $matches) {
            # Calculate hash for each match
            $fileHash = Get-FileHashValue -filePath $match.FullName

            # Check if file with the same hash has already been added
            if (-not $uniqueFiles.ContainsKey($fileHash)) {
                $destinationPath = Join-Path -Path $resultFolder -ChildPath ("{0}_{1}{2}" -f [System.IO.Path]::GetFileNameWithoutExtension($fileName), $counter, [System.IO.Path]::GetExtension($fileName))
                Copy-Item -Path $match.FullName -Destination $destinationPath -Force
                $uniqueFiles[$fileHash] = $destinationPath
                $counter++
            }
        }
    }
}
