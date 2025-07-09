# Rondo-Transpatcher
![Rondo-Transpatcher Logo](https://github.com/user-attachments/assets/7be4009e-9ad8-4f20-a434-6456846d08f2)  
Just a script to apply the Rondo of Blood English Translation Patch.
## Table of Contents
#### Informative stuff:
- [Introduction](#introduction)
- [Disclaimer](#disclaimer)

#### The stuff *you're* interested in:
- [Requirements](#requirements)
    + [Game](#game)
    + [System](#system)
- [Setup](#setup)
    + [Get the files from this repo](#get-the-files-from-this-repo)
- [Patch Guide](#patch-guide)

#### Nerd stuff:
- [Manual Patching (for nerds)](#manual-patching-for-nerds)

# Introduction

A new Translation Patcher for Rondo of Blood's English Patch.  
This is **NOT** a new translation just a new patcher script, since I had some problems with the old patcher.  
Hopefully this will make the process easier for other people to.

All hacking credit goes to the creators of the patch: https://www.romhacking.net/translations/846/  
The patch is however included in this repo for user convinience.

I have created two seperate scripts.  
A Powershell 5 Script for Windows users and a SHELL Script for Linux users.  

Yes, you will have to use the terminal. **But do not fear!**  
I have attempted to make the experience as user friendly as possibly with overly detailed instructions. 

# Disclaimer

*For obvious reasons, I will not show you how to obtain the game files. You should, of course, buy a legitimate copy and rip it yourself.*

***I do not endorse or condone piracy of any kind**.*

*This repo includes some audio and imagery from the game — nothing that can't easily be found on YouTube or with a quick Google image search. 
If the rightful owners believe any content in this repo should be taken down, I will promptly and willingly comply.*

# Requirements
## Game
A copy of [Akumajō Dracula X: Chi no Rondo](https://www.ebay.com/sch/i.html?_nkw=Akumaj%C5%8D+Dracula+X%3A+Chi+no+Rondo) ripped to any of these formats:
- CUE-file + ISO & WAV Tracks  
Track02 and Track22 as ISO, the rest in WAV.

- CUE-file + One large bin-file  
The bin-file contains all 22 tracks.
  
- CUE-file + BIN tracks
All 22 tracks are in separate bin-files.

## System
#### General:
- 64bit version of Windows or Linux
- A willingness to use a terminal

##### Windows specific:
- Powershell 5.1 (should come with Windows 10 and above)

#### Linux specific:
- Python 3 (only if you have multiple bin-files)
- POSIX compliant SHELL (ex. `bash` or `dash`)
  
I provide all (non standard) binaries used in the script through this repo, so you shouldn't have to install anything (except `python3`, as explained above).  

*The scripts are only tested on Arch Linux and Windows 11.  
But other Linux distros and Windows versions should work fine (as long as they are 64-bit).*

# Setup
## Get the files from this repo
### Zip method
Download this repo as a zip:  
<insert screenshot<>>
Extract the zip to your any folder.  
Prefably `Downloads`, to follow the guide more easily.

### Git method
Alternativly, just use `git`:
```sh
git clone https://github.com/edermats32/Rondo-Transpatcher.git
```
# Patch Guide
## Adding the source game
Start by adding your game files. Navigate to the `source` sub-folder inside the Rondo-Transpatcher folder:

<<*screenshot here*>>

Put your files in the folder that matches your rip type:

| RIP TYPE | FOLDER |
|----------|----------|
| BIN+CUE   | `bin_cue` |
| BIN+CUE (multiple bin-files)  | `bin_cue` |
| ISO+WAV+CUE   | `iso_wav_cue`   |

Now the step differ a bit depending on your operating system.  
Choose your operating system below:

- [Windows](#steps-for-windows)
- [Linux](#steps-for-linux)

## Steps for Windows
Inside the root of the Rondo-Transpatcher folder there is a shortcut file `RondoTranspatcherEasyRun`.  
Dubble-click the shourtcut and powershell window should open:

If for some reason the shortcut didn't work, follow these steps <<*create another readme and link to that, should include how top open WIN+r powershell.exe then navigate to the directory, the run the .ps1*>>

Now you should see the selection screen.  
Type the number that matches you rip-type and press enter:

<<*screenshot**>

If the patch was successful continue to the final step of the guide: [Locate your patched game](#locate-your-patched-game)


## Steps for Linux
Open your terminal of choice. If you're unsure, search for *terminal* in your Desktop Enviornments search function.  
Navigate to where you extracted the zip-file (or git cloned).  
If you did it in your `Downloads` folder you can run this command:
```sh
cd ~/Downloads/Rondo-Transpatcher-main
```
Now you can run the script with:
```sh
sh ./rondo-transpatcher.sh
```
Now you should see the selection screen.  
Type the number that matches you rip-type and press enter:

<*screenshot*>>

If the patch was successful continue to the final step of the guide: [Locate your patched game](#locate-your-patched-game)

## Locate your patched game

# Manual Patching (for nerds)
Here is how you can patch the game without my scripts.  
This is for you who rather run the commands yourself, or maybe you just don't trust my scripts.  
Or maybe they are badly written and don't work...  

Anyway, during the steps here I'm using Linux. You can probably figure out how to do this stuff from Windows.  
I'll also be using the rip-type where you have one cue-file and multiple bin-files, since we convert it to the other versions anyway.  
So this will cover all rip-types, you can jump to the steps that interrest you.

If you can't find a program I use, there is a `source.txt` in each sub-directory in `tools` that explains some things. 
There is a `readme.txt` in all directories btw, but the those ones are mostly for fun.

Now, after I've stopped rambling, start by merging the bin-files with `binmerge`:
```sh
mkdir merged && \
binmerge -o ./merged/ ./DraculaX.cue "DraculaX"
```
In the `merged` sub-directory we created, you should have a `DraculaX.cue` and one big `DraculaX.bin`.  

Next, convert the bin-files to ISO/WAV using `bchunk`:
```sh
mkdir converted && \
bchunk -w ./merged/DraculaX.bin ./merged/DraculaX.cue "./converted/DraculaX T"
```
Unfortunately, `bchunk` doesn't create a cue-file.  
You can steal mine (DraculaX.cue) from the `patch` directory if you want.  
Put it in our `converted` sub-directory.

Here are the SHA256 values if you want to validate your files:
```sh
5fadf081395eff0a3c7ecabec233ed59972fe40d910a2aecf4272292e94bbdd1 # Track01 (WAV)
6386b25fd60b9dd30ee55c5ac5d3221c993c7e18a735340154b361b321338594 # Track02 (ISO)
82441734e18d49f5a521b48beb8e74cb106282cf6a31f5c445de0c2e3fcef10a # Track03 (WAV)
871eb3ecdcd6cd9b2649aa28a5b16db3eb9078b44bfc8deb05dbf0d84435d2e1 # Track04 (WAV)
4b45d2bd4a2c16e82c4609f170f7a6e841a9bc2fa30b9154da2ec47205d8cecb # Track05 (WAV)
8d31811fedf0446d084b46ce7dd9a3d1084d7875b7dde3ff56b5448bdf4b28aa # Track06 (WAV)
57fddc7d67aa45af8db45704ad9c9f30b652dda86db2f60c285933fedd9bdecf # Track07 (WAV)
30cefffd3ce5fd9c0272a242b1a7d38f02f17c771bb49ee9a67307f3058d7cb1 # Track08 (WAV)
aa4e8bef1f61c7a1843f155c91ae2d5a14a82421de644f0c09930158e6b331bb # Track09 (WAV)
1e39006acf1f40d8ce56486a433538ce50cce76a0980f32fc3929da8cc092bce # Track10 (WAV)
cdc6593e7754905b6a725f9ffcd7a1adbec6535c43a2339060c6441d70a97486 # Track11 (WAV)
d604feb4a24bf1e6a26c52c630091a83cb54b9cebe6c0bbfc1cc0407f137b74b # Track12 (WAV)
719c24cc2c460a86d7df387a832a789d5d85a2f4e6331d8bccd5e6f5318972ba # Track13 (WAV)
8d06180693764534b74ffd4315f1b848cf0f95e7de606330bc1d9bdae18fddf2 # Track14 (WAV)
26e71f363125215697b7d47ba40e5f02547024cd5c641cea424c70815a24a5f7 # Track15 (WAV)
a609f71c1cf3a81b8dba13c486c8be5688d1c1524b819bb3433fc8bc63a14849 # Track16 (WAV)
29b144c4a4fe477771666b467bdbf878ca6ff3bf2a99f8f2b4026f2ca9b49689 # Track17 (WAV)
5fa8b0c39106a31ea787a8907e2c3f6a728299346b918aa0c048f687787c346e # Track18 (WAV)
fb672870d5329cf387c46b8f223b20fa2adbfbc0e5a7b5f7f01b05563fa09a40 # Track19 (WAV)
48035a8ad1901e8ac6f4249c9d65adf39b9a9f9e334d96ff24ca8b5adafe2f3e # Track20 (WAV)
09d1f8ab44ca7eceb73ef94d8496e9bb7de66f7789e5560f6c5ecb3ca732cfc3 # Track21 (WAV)
272895873c6e5d73dd2eb6f01eab89e9e29ba175d2dc06b7d0ef76d69cd76cc2 # Track22 (ISO)
```

Now get the patch. Either from this repo or from: https://www.romhacking.net/translations/846/  
You want to convert the ogg-files to wav. In the script I use `oggdec` (because it's tiny in size):
```sh
oggdec TrackName.ogg -o TrackName.wav
```
But you can just as well use `ffmpeg`:
```sh
ffmpeg -i TrackName.ogg TrackName.wav
```
Then replace the corresponding track in your `converted` (iso/wav rip) directory.  
Also copy the file `draculax.ppf`.  

Finally we can patch the game using `applyppf3`:
```sh
applyppf3 a "Rondo of Blood T02.iso" ./draculax.ppf
```
