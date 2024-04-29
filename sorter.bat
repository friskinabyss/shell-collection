# 2>NUL & @CLS & PUSHD "%~dp0" & "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -nol -nop -ep bypass "[IO.File]::ReadAllText('%~f0')|iex" & POPD & EXIT /B
# The line above allows this batch file to be ran as a powershell script, removing the need to right click to run. Credit to 'anditails' on reddit for this solution.
$desktopPath = [System.Environment]::GetFolderPath("Desktop")
$mediaPath = Join-Path -Path $desktopPath -ChildPath "Media"

#  Ensure the 'Media' folder exists
if (-Not (Test-Path -Path $mediaPath)) {
    New-Item -Path $mediaPath -ItemType Directory
}

$subfolders = @{
    "Audio" = @("mp3", "wav", "aac", "ogg")
    "Pictures" = @("png", "jpeg", "jpg", "webp", "tiff")
    "Gifs" = @("gif")
    "Videos" = @("mp4", "mov", "avi", "webm", "flv", "mpeg")
}

#  Ensure subfolders exist
foreach ($folder in $subfolders.Keys) {
    $folderPath = Join-Path -Path $mediaPath -ChildPath $folder
    if (-Not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory
    }
}

#  Move files into their corresponding subfolders
Get-ChildItem -Path $desktopPath -File | Where-Object { $_.Extension -ne "" } | ForEach-Object {
    $fileExtension = $_.Extension.TrimStart(".")
    foreach ($key in $subfolders.Keys) {
        if ($fileExtension -in $subfolders[$key]) {
            $destinationPath = Join-Path -Path $mediaPath -ChildPath $key
            Move-Item -Path $_.FullName -Destination $destinationPath
            break
        }
    }
}
