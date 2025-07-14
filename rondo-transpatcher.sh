#!/usr/bin/env sh

ROOT_DIR="$(pwd)"

############
# Commands #
############

# Local binaries
_applyppf3="$ROOT_DIR/tools/applyppf/linux-redhat/applyppf3"
_binmerge="$ROOT_DIR/tools/binmerge/binmerge-1.0.3/binmerge"
_bchunk="$ROOT_DIR/tools/bchunk/linux_x86_64_v1.2.2/bchunk"
_oggdec="$ROOT_DIR/tools/oggdec/vorbis-tools-1.4.3-linux-x86-64/oggdec"

# Make sure they are executable
chmod +x "$_applyppf3" || { echo "Failed to make $_applyppf3 executable"; exit 1; }
chmod +x "$_binmerge" || { echo "Failed to make $_binmerge executable"; exit 1; }
chmod +x "$_bchunk" || { echo "Failed to make $_bchunk executable"; exit 1; }
chmod +x "$_oggdec" || { echo "Failed to make $_oggdec executable"; exit 1; }

# Make sure 'sha256sum' exists, since it's not POSIX standard
command -v sha256sum >/dev/null || { echo "sha256sum not found"; exit 1; }

#########
# Patch #
#########

PD_ROOT="$ROOT_DIR/patch/DraculaX_v1.01"
PD_IMG="$ROOT_DIR/patch/Images"
PF_PPF="$ROOT_DIR/patch/DraculaX_v1.01/draculax.ppf"

#########################
# Source (vanilla game) #
#########################

SD_BIN_CUE="$ROOT_DIR/source/bin_cue"
SD_ISO_WAV_CUE="$ROOT_DIR/source/iso_wav_cue"

SF_DRACX_CUE="$ROOT_DIR/source/DraculaX.cue"
SF_RONDO_CUE="$ROOT_DIR/source/Castlevania - Rondo of Blood (JP) (TR).cue"

##########
# Output #
##########

OUT_NAME='Castlevania - Rondo of Blood (JP) (TR)'
OD_FINAL="$ROOT_DIR/output/$OUT_NAME"
OF_TRACK02="$OD_FINAL/$OUT_NAME T02.iso"

# Create the output dir if it doesn't exist
[ -d "$OD_FINAL" ] || mkdir "$OD_FINAL"

#############
# Functions #
#############

CheckSingleFile()
{
  inFiles=$1 # The files, dir/*.foo
  inDir=$2   # The directory
  inType=$3  # The file type

  fileCount=$(find "$inFiles" 2>/dev/null | wc -l)

  # More than one file
  if [ "$fileCount" -gt 1 ]; then
    echo "!ERROR!"
    echo "More than one $inType-file in '$inDir'"
    echo "Please make sure there is only one and then run the script again."
    echo "Patching FAILED!"
    exit 1
  fi
  
  # No files
  if [ "$fileCount" -lt 1 ]; then
    echo "!ERROR!"
    echo "No $inType-file found in '$inDir'"
    echo "Patching FAILED!"
    exit 1
  fi

  # Returns nothing, code just continues if no above scenarios are true 
}

ValidateTrack02()
{
  track02=$1

  track02HashExpected='6386b25fd60b9dd30ee55c5ac5d3221c993c7e18a735340154b361b321338594'

  # Get the hash
  if [ -f "$track02" ]; then
    track02Hash=$(sha256sum "$track02" | awk '{print $1}')
  else
    track02Hash="<file missing>"
  fi

  # Check if it matches
  if [ "$track02Hash" = "$track02HashExpected" ]; then
    echo "Valid: '$track02'"
  else 
    echo "!ERROR!"
    echo "SHA256 validation failed: '$track02'"
    echo "|"
    echo "Got:      $track02Hash"
    echo "Expected: $track02HashExpected"
    echo ""
    echo "Something might be wrong with your rip."
    echo "Did you test the game before patching?"
    echo ""
    printf "Patch anyway (not recommended)? [y/N]: "
    read -r ignorance
    echo ""
    [ "$ignorance" = 'y' ] || exit 1
  fi
}


###########################
# I call this The Italian #
###########################

echo ""
echo "                                                       #*****        @#*#****"
echo "                                                        ******      @#********@"
echo "                                                         ******@     #******@"
echo "  #####   #####    ####    ####   ##  ##  ##       ####   @*****@  @******#"
echo "  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##      ##  ##    @#**********#"
echo "  ##  ##  #####   ######  ##      ##  ##  ##      ######      @********@"
echo "  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##      ##  ##      @#######"
echo "  #####   ##  ##  ##  ##   ####    ####   ######  ##  ##    @@#######@"
echo "                                                          @@@@@@@@@@@@@"
echo "          R  o  n  d  o    o  f    B  l  o  o  d         @@@@@@@#  @@@@@"
echo "                                                      O@@@@@@@@@    #@@@@@"
echo "               ~ English Translation Patch ~          @@@@@@@@%       O@@@@@"
echo "                  ~ Rondo Transpatcher ~           #@@@@              @@@@@"
echo "                                                 %@@@@@                 @@@@"
echo "                                               %*@@@@                     @@%"
echo "                                             **@"
echo "-------------------------------------------------------------------------------"
echo "Thief: edermats32"
echo "Team:  Burnt Lasagna, cubanraul, pemdawg and tomaitheous."
echo "-------------------------------------------------------------------------------"
echo ""
echo "What game rip type do you have?"
echo ""
echo "1. BIN+CUE"
echo "2. ISO+WAV+CUE"
echo ""
printf "Choose type: "
read -r rip_type
[ -z "$rip_type" ] && rip_type=0

###########
# BIN+CUE #
###########
if [ "$rip_type" = '1' ]; then
  # Make sure only one .cue file exists
  cueFile=$(find "$SD_BIN_CUE"/*.cue 2>/dev/null)
  CheckSingleFile "$cueFile" "$SD_BIN_CUE" 'cue'
    
  # Check how many bin-files there are
  binFileCount=$(find "$SD_BIN_CUE"/*.bin 2>/dev/null | wc -l)
  
  if [ "$binFileCount" -lt 1 ]; then
    echo "!ERROR!"
    echo "No bin-files found in: $SD_BIN_CUE"
    echo "Patching FAILED!"
    exit 1
  fi

  ######################
  # multiple bin-files #
  ######################
  if [ "$binFileCount" -gt 1 ]; then
    echo ""
    echo "######################################"
    echo "# Merging bin-files using 'binmerge' #"
    echo "######################################"
    echo ""

    command -v python3 >/dev/null || { echo "python3 not found"; exit 1; }

    # Create a sub-dir for the merged bin and new cue (delete if already exists)
    if [ -d "$SD_BIN_CUE/merged" ]; then
      rm -rf "$SD_BIN_CUE/merged"
      [ $? -eq 0 ] || { echo "barPatching FAILED!"; exit 1; }
    fi

    mkdir "$SD_BIN_CUE/merged"
    [ $? -eq 0 ] || { echo "fooPatching FAILED!"; exit 1; }
    
    # Merge the bin-files, output to merged sub-directory (binmerge also creates a cue)
    "$_binmerge" -o "$SD_BIN_CUE/merged/" "$cueFile" "DraculaX"
    [ $? -eq 0 ] || { echo "bazPatching FAILED!"; exit 1; }
  
    # Update vars and wd to new location
    SD_BIN_CUE="$SD_BIN_CUE/merged"
    cueFile=$(find "$SD_BIN_CUE"/*.cue 2>/dev/null)
  fi

  echo ""
  echo "#################################################"
  echo "# Converting bin-file to iso/wav using 'bchunk' #"
  echo "#################################################"
  echo ""

  # Make sure only one .bin file exists
  binFile=$(find "$SD_BIN_CUE"/*.bin 2>/dev/null)
  CheckSingleFile "$binFile" "$SD_BIN_CUE" 'bin'
 
  echo "CUE file: '$cueFile'"
  echo ""
  
  # Convert them to iso/wav and copy in the pre-prepared .cue file
  "$_bchunk" -w "$binFile" "$cueFile" "$SD_ISO_WAV_CUE/DraculaX T"
  [ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

  cp "$SF_DRACX_CUE" "$SD_ISO_WAV_CUE"
  [ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

  # Conversion from rip type 1 -> 2 completed, continue
  rip_type='2'
fi

###############
# ISO+WAV+CUE #
###############
if [ "$rip_type" = '2' ]; then
  echo ""
  echo "################################"
  echo "# Validating SHA256 of Track02 #"
  echo "################################"
  echo ""

  # Make sure only one .cue file exists
  cueFile=$(find "$SD_ISO_WAV_CUE"/*.cue 2>/dev/null)
  CheckSingleFile "$cueFile" "$SD_ISO_WAV_CUE" 'cue'

  # Get the Tracks filenames from cue file
  tracks=$(grep FILE "$cueFile" | cut -d'"' -f2)
  [ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

  # 22 tracks is expected
  i=1
  while [ $i -le 22 ]; do
    # Filepath to track (dirty, but they should always be in the right order in the cue)
    track=$(echo "$tracks" | sed -n "${i}p")
    track="$SD_ISO_WAV_CUE/$track"
    
    # If Track02 validate the hash
    [ $i = 2 ] && ValidateTrack02 "$track"

    # Get the filetype
    fileExt=${track##*.}
  
    # Define outfile (again, track order should always be the same from the cue)
    outFile="$OUT_NAME T$i.$fileExt"
    # For tracks 01-09 we prepend with the 0
    if [ $i -lt 10 ]; then
      outFile="$OUT_NAME T0$i.$fileExt"
    fi
  
    # Make a copy of the files to the patched game dir
    cp "$track" "$OD_FINAL/$outFile" 
    [ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

    i=$((i + 1))
  done

  # Also copy over the other pre-prepared .cue file
  cp "$SF_RONDO_CUE" "$OD_FINAL"
  [ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

else
  echo 'Bad choice. Goodbye...'
  exit 1
fi

###################
# Apply the patch #
###################

echo ""
echo "############################################"
echo "# Patching Track02 (iso) using 'applyppf3' #"
echo "############################################"
echo ""

# Patch the Track02 iso
echo "Patching TRACK02: '$OF_TRACK02'"
echo ""
"$_applyppf3" a "$OF_TRACK02" "$PF_PPF"
[ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

echo ""
echo "###################################################"
echo "# Replacing TRACK03, TRACK19, TRACK20 and TRACK21 #"
echo "###################################################"
echo ""

echo "Converting files from .ogg to .wav"
echo ""

# Loop through all oggFiles in patch dir
i=1
for oggFile in "$PD_ROOT"/*.ogg; do
  # The filename in patch is same as it should be in the output, just different filetype
  fileName=$(basename "${oggFile%.*}")

  # Convert the files from ogg -> wav, override the files in the final output 
  "$_oggdec" "$oggFile" -o "$OD_FINAL/$fileName.wav"
  [ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

  i=$((i + 1))
done
echo "If last one says 99.5%, it's probably still fine."

echo ""
echo "#####################################"
echo "# You get some images as a bonus :D #"
echo "#####################################"
echo ""

# Copy over the images (cover art, logo, screenshot)
echo "Adding 'Cover Art', 'Logo/Wheel' and 'Screenshot' to: "
echo "'$OD_FINAL/Images'"
cp -r "$PD_IMG" "$OD_FINAL"
[ $? -eq 0 ] || { echo "Patching FAILED!"; exit 1; }

echo ''
echo '#######################'
echo '# Patching completed! #'
echo '#######################'
echo ''

echo "I kept the source files, but you may want to remove them."
echo "They do take up some space:"
echo ""
du -h --max-depth=2 "$ROOT_DIR/source/"
echo ""
echo "Enjoy your translated game in:"
echo "'$OD_FINAL'"