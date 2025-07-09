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
chmod +x "$_applyppf3"
chmod +x "$_binmerge"
chmod +x "$_bchunk"
chmod +x "$_oggdec"

# Make sure 'sha256sum' exists, since it's not POSIX standard
command -v sha256sum >/dev/null || { echo "sha256sum not found"; exit 1; }

#############
# Functions #
#############

GetFileCount()
{
  inFiles=$1 # The files, dir/*.foo

  # Count the files
  fileCount=0
  for file in $inFiles; do
    if [ -f "$file" ]; then
      fileCount=$((fileCount + 1))
    fi
  done

  # return value
  echo $fileCount
}

CheckSingleFile()
{
  inFiles=$1 # The files, dir/*.foo
  inDir=$2   # The directory
  inType=$3  # The file type

  fileCount=$(GetFileCount "$inFiles")

  # More than one file
  if [ $fileCount -gt 1 ]; then
    echo "!ERROR!"
    echo "More than one $inType-file in '$inDir'"
    echo "Please make sure there is only one and then run the script again."
    exit 1
  fi
  
  # No files
  if [ $fileCount -lt 1 ]; then
    echo "!ERROR!"
    echo "No $inType-file found in '$inDir'"
    exit 1
  fi

  # Returns nothing, code just continues if no above scenarios are true 
}

GetExpectedSha256()
{
  # Expected Sha256 for the source files (iso/wav/cue)
  # Track02 is the only one that matters, but might as well check all of them
  # We should probably use MD5 instead for speed, but im to lazy to change it now. 
  # In reality users really only run the script once anyway.
  case $1 in
    1)  echo '5fadf081395eff0a3c7ecabec233ed59972fe40d910a2aecf4272292e94bbdd1' ;; # Track01 (WAV)
    2)  echo '6386b25fd60b9dd30ee55c5ac5d3221c993c7e18a735340154b361b321338594' ;; # Track02 (ISO)
    3)  echo '82441734e18d49f5a521b48beb8e74cb106282cf6a31f5c445de0c2e3fcef10a' ;; # Track03 (WAV)
    4)  echo '871eb3ecdcd6cd9b2649aa28a5b16db3eb9078b44bfc8deb05dbf0d84435d2e1' ;; # Track04 (WAV)
    5)  echo '4b45d2bd4a2c16e82c4609f170f7a6e841a9bc2fa30b9154da2ec47205d8cecb' ;; # Track05 (WAV)
    6)  echo '8d31811fedf0446d084b46ce7dd9a3d1084d7875b7dde3ff56b5448bdf4b28aa' ;; # Track06 (WAV)
    7)  echo '57fddc7d67aa45af8db45704ad9c9f30b652dda86db2f60c285933fedd9bdecf' ;; # Track07 (WAV)
    8)  echo '30cefffd3ce5fd9c0272a242b1a7d38f02f17c771bb49ee9a67307f3058d7cb1' ;; # Track08 (WAV)
    9)  echo 'aa4e8bef1f61c7a1843f155c91ae2d5a14a82421de644f0c09930158e6b331bb' ;; # Track09 (WAV)
    10) echo '1e39006acf1f40d8ce56486a433538ce50cce76a0980f32fc3929da8cc092bce' ;; # Track10 (WAV)
    11) echo 'cdc6593e7754905b6a725f9ffcd7a1adbec6535c43a2339060c6441d70a97486' ;; # Track11 (WAV)
    12) echo 'd604feb4a24bf1e6a26c52c630091a83cb54b9cebe6c0bbfc1cc0407f137b74b' ;; # Track12 (WAV)
    13) echo '719c24cc2c460a86d7df387a832a789d5d85a2f4e6331d8bccd5e6f5318972ba' ;; # Track13 (WAV)
    14) echo '8d06180693764534b74ffd4315f1b848cf0f95e7de606330bc1d9bdae18fddf2' ;; # Track14 (WAV)
    15) echo '26e71f363125215697b7d47ba40e5f02547024cd5c641cea424c70815a24a5f7' ;; # Track15 (WAV)
    16) echo 'a609f71c1cf3a81b8dba13c486c8be5688d1c1524b819bb3433fc8bc63a14849' ;; # Track16 (WAV)
    17) echo '29b144c4a4fe477771666b467bdbf878ca6ff3bf2a99f8f2b4026f2ca9b49689' ;; # Track17 (WAV)
    18) echo '5fa8b0c39106a31ea787a8907e2c3f6a728299346b918aa0c048f687787c346e' ;; # Track18 (WAV)
    19) echo 'fb672870d5329cf387c46b8f223b20fa2adbfbc0e5a7b5f7f01b05563fa09a40' ;; # Track19 (WAV)
    20) echo '48035a8ad1901e8ac6f4249c9d65adf39b9a9f9e334d96ff24ca8b5adafe2f3e' ;; # Track20 (WAV)
    21) echo '09d1f8ab44ca7eceb73ef94d8496e9bb7de66f7789e5560f6c5ecb3ca732cfc3' ;; # Track21 (WAV)
    22) echo '272895873c6e5d73dd2eb6f01eab89e9e29ba175d2dc06b7d0ef76d69cd76cc2' ;; # Track22 (ISO)
  esac
}

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
SF_RONDO_CUE="$ROOT_DIR/source/Rondo of Blood.cue"

##########
# Output #
##########

OD_FINAL="$ROOT_DIR/output/Castlevania - Rondo of Blood (JP) (TR)"
OF_TRACK02="$OD_FINAL/Rondo of Blood T02.iso"

# Create the output dir if it doesn't exist
[ -d "$OD_FINAL" ] || mkdir "$OD_FINAL"

#############
# The magic #
#############

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
if [ $rip_type = '1' ]; then
  # Enter the dir (makes things easier, trust me)
  cd "$SD_BIN_CUE" || exit 1
  
  # Make sure only one .cue file exists
  cueFile=./*.cue
  CheckSingleFile "$cueFile" "$SD_BIN_CUE" 'cue'
    
  # Check how many bin-files there are
  binFileCount=$(GetFileCount "./*.bin")
  
  if [ $binFileCount -lt 1 ]; then
    echo "!ERROR!"
    echo "No bin-files found in '$SD_BIN_CUE'"
    exit 1
  fi

  ######################
  # multiple bin-files #
  ######################
  if [ $binFileCount -gt 1 ]; then
    echo ""
    echo "######################################"
    echo "# Merging bin-files using 'binmerge' #"
    echo "######################################"
    echo ""

    # Create a sub-dir for the merged bin and new cue (delete if already exists)
    [ -d "./merged" ] && rm -rf "./merged"
    mkdir "./merged"
    
    # Merge the bin-files, output to merged sub-directory (binmerge also creates a cue)
    "$_binmerge" -o "./merged/" $cueFile "DraculaX"
  
    # Update vars and wd to new location
    SD_BIN_CUE="$SD_BIN_CUE"/merged
    cd "$SD_BIN_CUE" || exit 1
    cueFile=./*.cue
  fi 

  echo ""
  echo "#################################################"
  echo "# Converting bin-file to iso/wav using 'bchunk' #"
  echo "#################################################"
  echo ""

  # Make sure only one .bin file exists
  binFile=./*.bin
  CheckSingleFile "$binFile" "$SD_BIN_CUE" 'bin'
 
  echo "CUE file:" "$SD_BIN_CUE"/*.cue
  echo ""
  
  # Convert them to iso/wav and copy in the pre-prepared .cue file
  "$_bchunk" -w $binFile $cueFile "$SD_ISO_WAV_CUE/DraculaX T"
  cp "$SF_DRACX_CUE" "$SD_ISO_WAV_CUE"

  # Convertion from rip type 1 -> 2 completed, continue
  rip_type='2'
fi

###############
# ISO+WAV+CUE #
###############
if [ $rip_type = '2' ]; then
  echo ""
  echo "##############################################"
  echo "# Validating wav/iso files using 'sha256sum' #"
  echo "##############################################"
  echo ""

  # Enter the dir
  cd "$SD_ISO_WAV_CUE" || exit 1

  # Make sure only one .cue file exists
  cueFile=./*.cue
  CheckSingleFile "$cueFile" "$SD_ISO_WAV_CUE" 'cue'

  # Read files into a variable
  files=$(grep FILE $cueFile | cut -d'"' -f2)
  
  # We do this so multiline filenames will work right:
  # Save original IFS
  OLD_IFS="$IFS"
  IFS='
'  # Set IFS to newline only (literal newline between quotes)

  # Loop through all the files (got from .cue file)
  i=1
  for srcFile in $files; do
    # Check if file exists, if it does calculate the SHA256
    if [ -f "./$srcFile" ]; then
      fileHash=$(sha256sum "./$srcFile" | awk '{print $1}')
    else
      fileHash="<file missing>"
    fi

    # Expected SHA256
    expFileHash=$(GetExpectedSha256 $i)

     # Compare the current file's hash to the expected hash (lazy stuff, order is hardcoded)
    if [ ! "$fileHash" = "$expFileHash" ]; then
      echo "!ERROR!"
      echo "SHA256 validation failed for file: '$SD_ISO_WAV_CUE/$srcFile'"
      echo "|"
      echo "Got:      $fileHash"
      echo "Expected: $expFileHash"
      echo ""
      echo "Something is probably wrong with your rip."
      echo "Have you tried if the game works?"
      [ $i = 2 ] && echo "!WARNING! Since this is TRACK02, the game probably won't run after patching!"
      echo ""
      printf "Ignore this issue? [y/N]: "
      read -r ignorance
      echo ""
      [ "$ignorance" = 'y' ] || exit 1
      
    else
      echo "Valid: '$SD_ISO_WAV_CUE/$srcFile'"
    fi

    # Get the filetype
    fileExt=${srcFile##*.}
  
    # Define outfile (again, track order should always be the same from the cue)
    outFile="Rondo of Blood T$i.$fileExt"
    # For tracks 01-09 we prepend with the 0
    if [ $i -lt 10 ]; then
      outFile="Rondo of Blood T0$i.$fileExt"
    fi
  
    # Make a copy of the files to the patched game dir
    cp "$SD_ISO_WAV_CUE/$srcFile" "$OD_FINAL/$outFile" 
    echo "Adding track to: '$OD_FINAL'"
    echo ""
    # Increment loop counter
    i=$((i + 1))
  done

  # Restore original IFS
  IFS="$OLD_IFS"

  # Also copy over the other pre-prepared .cue file
  cp "$SF_RONDO_CUE" "$OD_FINAL"

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
  i=$((i + 1))
done

echo ""
echo "#####################################"
echo "# You get some images as a bonus :D #"
echo "#####################################"
echo ""

# Copy over the images (cover art, logo, screenshot)
echo "Adding 'Cover Art', 'Logo/Wheel' and 'Screenshot' to: "
echo "'$OD_FINAL/Images'"
cp -r "$PD_IMG" "$OD_FINAL"

echo ''
echo '#######################'
echo '# Patching completed! #'
echo '#######################'
echo ''
