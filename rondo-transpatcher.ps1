#Requires -Version 5.1

# Dirty re-write of the Linux version of this script
# Do not expect good powershell practice

$ROOT_DIR=((Get-Location).Path)

############
# Commands #
############

# Local binaries
$_applyppf3 = "$ROOT_DIR\tools\applyppf\w32\ApplyPPF3.exe"
$_binmerge  = "$ROOT_DIR\tools\binmerge\binmerge-1.0.3-win64\binmerge.exe"
$_bchunk    = "$ROOT_DIR\tools\bchunk\win_x86_64_v1.2.2\bchunk.exe"
$_oggdec    = "$ROOT_DIR\tools\oggdec\vorbis-tools-1.4.3-win-x86-64\oggdec.exe"

#########
# Patch #
#########

$PD_ROOT="$ROOT_DIR\patch\DraculaX_v1.01"
$PD_IMG="$ROOT_DIR\patch\Images"
$PF_PPF="$ROOT_DIR\patch\DraculaX_v1.01\draculax.ppf"

#########################
# Source (vanilla game) #
#########################

$SD_BIN_CUE="$ROOT_DIR\source\bin_cue"
$SD_ISO_WAV_CUE="$ROOT_DIR\source\iso_wav_cue"

$SF_DRACX_CUE="$ROOT_DIR\source\DraculaX.cue"
$SF_RONDO_CUE="$ROOT_DIR\source\Castlevania - Rondo of Blood (JP) (TR).cue"

##########
# Output #
##########

$OUT_NAME='Castlevania - Rondo of Blood (JP) (TR)'
$OD_FINAL="$ROOT_DIR\output\$OUT_NAME"
$OF_TRACK02="$OD_FINAL\$OUT_NAME T02.iso"

# Create the output dir if it doesn't exist
if (-not (Test-Path -Path $OD_FINAL -PathType Container)) {
  New-Item -Path $OD_FINAL -ItemType Directory | Out-Null
}

#############
# Functions #
#############

function Check-SingleFile()
{
  param ( 
    $inFiles, # The files, dir\*.foo
    $inDir,   # The directory
    $inType   # The file type
  )

  $fileCount = 0
  foreach($file in (Get-ChildItem $inFiles)) { $fileCount++ }

  # More than one file
  if ( $fileCount -gt 1 ) {
    Write-Output "!ERROR!"
    Write-Output "More than one $inType-file in '$inDir'"
    Write-Output "Please make sure there is only one and then run the script again."
    Write-Output "Patching FAILED!"
    exit 1
  }
  
  # No files
  if ( $fileCount -lt 1 ) {
    Write-Output "!ERROR!"
    Write-Output "No $inType-file found in '$inDir'"
    Write-Output "Patching FAILED!"
    exit 1
  }

  # Returns the one file
  return (Get-ChildItem $inFiles).FullName
}

function Validate-Track02()
{
  param(
    $track02
  )

  $track02HashExpected='6386b25fd60b9dd30ee55c5ac5d3221c993c7e18a735340154b361b321338594'

  # Get the hash
  if ( Test-Path -Path "$track02" -PathType Leaf ) {
    $track02Hash=(Get-FileHash -Path "$track02" -Algorithm SHA256).Hash
  }
  else {
    $track02Hash="<file missing>"
  }

  # Check if it matches
  if ( "$track02Hash" -eq "$track02HashExpected" ) {
    Write-Output "Valid: '$track02'"
  }
  else {
    Write-Output "!ERROR!"
    Write-Output "SHA256 validation failed: '$track02'"
    Write-Output "|"
    Write-Output "Got:      $track02Hash"
    Write-Output "Expected: $track02HashExpected"
    Write-Output ""
    Write-Output "Something might be wrong with your rip."
    Write-Output "Did you test the game before patching?"
    Write-Output ""
    $ignorance = Read-Host "Patch anyway (not recommended)? [y/N]"
    Write-Output ""
    if ($ignorance -ne 'y') {
      exit 1
    }
  }
}

###########################
# I call this The Italian #
###########################

Write-Output ""
Write-Output "                                                       #*****        @#*#****"
Write-Output "                                                        ******      @#********@"
Write-Output "                                                         ******@     #******@"
Write-Output "  #####   #####    ####    ####   ##  ##  ##       ####   @*****@  @******#"
Write-Output "  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##      ##  ##    @#**********#"
Write-Output "  ##  ##  #####   ######  ##      ##  ##  ##      ######      @********@"
Write-Output "  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##      ##  ##      @#######"
Write-Output "  #####   ##  ##  ##  ##   ####    ####   ######  ##  ##    @@#######@"
Write-Output "                                                          @@@@@@@@@@@@@"
Write-Output "          R  o  n  d  o    o  f    B  l  o  o  d         @@@@@@@#  @@@@@"
Write-Output "                                                      O@@@@@@@@@    #@@@@@"
Write-Output "               ~ English Translation Patch ~          @@@@@@@@%       O@@@@@"
Write-Output "                  ~ Rondo Transpatcher ~           #@@@@              @@@@@"
Write-Output "                                                 %@@@@@                 @@@@"
Write-Output "                                               %*@@@@                     @@%"
Write-Output "                                             **@"
Write-Output "-------------------------------------------------------------------------------"
Write-Output "Thief: edermats32"
Write-Output "Team:  Burnt Lasagna, cubanraul, pemdawg and tomaitheous."
Write-Output "-------------------------------------------------------------------------------"
Write-Output ""
Write-Output "What game rip type do you have?"
Write-Output ""
Write-Output "1. BIN+CUE"
Write-Output "2. ISO+WAV+CUE"
Write-Output ""
$rip_type = (Read-Host "Choose type").Trim()
if ([string]::IsNullOrWhiteSpace($rip_type)) { $rip_type = 0 }

###########
# BIN+CUE #
###########

if ( $rip_type -eq '1' ) {
  # Make sure only one .cue file exists
  $cueFile = (Check-SingleFile "$SD_BIN_CUE\*.cue" "$SD_BIN_CUE" 'cue')
    
  # Check how many bin-files there are
  $binFileCount = 0
  foreach($file in (Get-ChildItem "$SD_BIN_CUE\*.bin")) { $binFileCount++ }
  
  if ( $binFileCount -lt 1 ) {
    Write-Output "!ERROR!"
    Write-Output "No bin-files found in '$SD_BIN_CUE'"
    Write-Output "Patching FAILED!"
    exit 1
  }

  ######################
  # multiple bin-files #
  ######################
  if ( $binFileCount -gt 1 ) {
    Write-Output ""
    Write-Output "######################################"
    Write-Output "# Merging bin-files using 'binmerge' #"
    Write-Output "######################################"
    Write-Output ""

    # Create a sub-dir for the merged bin and new cue (delete if already exists)
    if (Test-Path -Path "$SD_BIN_CUE\merged" -PathType Container) {
        Remove-Item -Recurse -Force "$SD_BIN_CUE\merged"
        if (!$?) { Write-Output "Patching FAILED!"; exit 1 }
    }

    New-Item -Path "$SD_BIN_CUE\merged" -ItemType Directory | Out-Null
    if (!$?) { Write-Output "Patching FAILED!"; exit 1 }
    
    # Merge the bin-files, output to merged sub-directory (binmerge also creates a cue)
    & "$_binmerge" -o "$SD_BIN_CUE\merged\" $cueFile "DraculaX"
    if (!$?) { Write-Output "Patching FAILED!"; exit 1 }
  
    # Update vars and wd to new location
    $SD_BIN_CUE="$SD_BIN_CUE\merged"
    $cueFile=(Get-ChildItem "$SD_BIN_CUE\*.cue").FullName
  }

  Write-Output ""
  Write-Output "#################################################"
  Write-Output "# Converting bin-file to iso\wav using 'bchunk' #"
  Write-Output "#################################################"
  Write-Output ""

  # Make sure only one .bin file exists
  $binFile = (Check-SingleFile "$SD_BIN_CUE\*.bin" "$SD_BIN_CUE" 'bin')
 
  Write-Output "CUE file: '$cueFile'"
  Write-Output ""
  
  # Convert them to iso\wav and copy in the pre-prepared .cue file
  & "$_bchunk" -w $binFile $cueFile "$SD_ISO_WAV_CUE\DraculaX T"
  if (!$?) { Write-Output "Patching FAILED!"; exit 1 }

  Copy-Item -Force -Path "$SF_DRACX_CUE" -Destination "$SD_ISO_WAV_CUE"
  if (!$?) { Write-Output "Patching FAILED!"; exit 1 }

  # Convertion from rip type 1 -> 2 completed, continue
  $rip_type='2'
}

###############
# ISO+WAV+CUE #
###############

if ( $rip_type -eq '2' ) {
  Write-Output ""
  Write-Output "################################"
  Write-Output "# Validating SHA256 of Track02 #"
  Write-Output "################################"
  Write-Output ""

  # Make sure only one .cue file exists
  $cueFile = (Check-SingleFile "$SD_ISO_WAV_CUE\*.cue" "$SD_ISO_WAV_CUE" 'cue')

  # Get the Tracks filenames from cue file
  $tracks = (Select-String -Path $cueFile -Pattern 'FILE' | % { ($_ -split '"')[1] })
  if (!$?) { Write-Output "Patching FAILED!"; exit 1 }
  
  # 22 tracks is expected
  $i=1
  while ( $i -le 22 ) {
    # Filepath to track (dirty, but they should always be in the right order in the cue)
    $track = $tracks[$i-1]
    $track = "$SD_ISO_WAV_CUE\$track"
    
    # If Track02 validate the hash
    if ( $i -eq 2 ) {
      Validate-Track02 "$track"
    }

    # Get the filetype
    $fileExt = (Get-ChildItem -Path $track).Extension.Substring(1)
  
    # Define outfile (again, track order should always be the same from the cue)
    $outFile="$OUT_NAME T$i.$fileExt"
    # For tracks 01-09 we prepend with the 0
    if ( $i -lt 10 ) {
      $outFile="$OUT_NAME T0$i.$fileExt"
    }
  
    # Make a copy of the files to the patched game dir
    Copy-Item -Force  "$track" "$OD_FINAL\$outFile" 
    if (!$?) { Write-Output "Patching FAILED!"; exit 1 }

    $i++
  }

  # Also copy over the other pre-prepared .cue file
  Copy-Item -Force -Path $SF_RONDO_CUE -Destination $OD_FINAL
  if (!$?) { Write-Output "Patching FAILED!"; exit 1 }
}

else {
  Write-Output 'Bad choice. Goodbye...'
  exit 1
}

###################
# Apply the patch #
###################

Write-Output ""
Write-Output "############################################"
Write-Output "# Patching Track02 (iso) using 'applyppf3' #"
Write-Output "############################################"
Write-Output ""

# Patch the Track02 iso
Write-Output "Patching TRACK02: '$OF_TRACK02'"
Write-Output ""
& $_applyppf3 a $OF_TRACK02 $PF_PPF
if (!$?) { Write-Output "Patching FAILED!"; exit 1 }

Write-Output ""
Write-Output "###################################################"
Write-Output "# Replacing TRACK03, TRACK19, TRACK20 and TRACK21 #"
Write-Output "###################################################"
Write-Output ""

Write-Output "Converting files from .ogg to .wav"
Write-Output ""

# Loop through all .ogg files in patch dir
$i = 1
foreach ($oggFile in (Get-ChildItem -Path $PD_ROOT -Filter '*.ogg')) {
  # The filename in patch is same as it should be in the output, just different filetype
  $fileName = [System.IO.Path]::GetFileNameWithoutExtension($oggFile.Name)

  # Convert the files from ogg -> wav, override the files in the final output 
  Write-Output "From: $($oggFile.FullName)"
  Write-Output "To:   $OD_FINAL\$fileName.wav"
  Write-Output ""
  # We quiet the output, or else the cursor spazzes out and conversion is slow
  & "$_oggdec" -Q $oggFile.FullName -o "$OD_FINAL\$fileName.wav"
  if (!$?) { Write-Output "Patching FAILED!"; exit 1 }

  $i++
}

Write-Output ""
Write-Output "#####################################"
Write-Output "# You get some images as a bonus :D #"
Write-Output "#####################################"
Write-Output ""

# Copy over the images (cover art, logo, screenshot)
Write-Output "Adding 'Cover Art', 'Logo/Wheel' and 'Screenshot' to:"
Write-Output "'$OD_FINAL\Images'"
Copy-Item -Force -Path $PD_IMG -Destination $OD_FINAL
if (!$?) { Write-Output "Patching FAILED!"; exit 1 }

Write-Output ""
Write-Output "#######################"
Write-Output "# Patching completed! #"
Write-Output "#######################"
Write-Output ""

Write-Output "I kept the source files, but you may want to remove them."
Write-Output "They do take up some space:"
Write-Output ""
# Best equivalent I got for 'du -h --max-depth=2 "$ROOT_DIR/source/"'
Get-ChildItem -Path "$ROOT_DIR\source\" -Directory -Recurse | ForEach-Object {
  $lazyBool=$true
  $size = (Get-ChildItem $_.FullName -Recurse -File | Measure-Object Length -Sum).Sum
  
  if ($size -ge 1GB) {
    $displaySize = "{0:N0} GB" -f ($size / 1GB)
  }
  elseif ($size -ge 1MB) {
    $displaySize = "{0:N0} MB" -f ($size / 1MB)
  }
  elseif ($size -ge 1KB) {
    $displaySize = "{0:N0} KB" -f ($size / 1KB)
  }
  else {
    $lazyBool=$false
  }
  if ($lazyBool) { Write-Output "$displaySize   $($_.FullName)" }
}
Write-Output ""
Write-Output "Enjoy your translated game in:"
Write-Output "'$OD_FINAL'"