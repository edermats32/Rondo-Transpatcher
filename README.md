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
All hacking credit goes to the creators of the patch: https://www.romhacking.net/translations/846/  
The patch is however included in this repo for user convinience.

I have created two seperate scripts.  
A Powershell 5 Script for Windows users and a SHELL Script for Linux users.  

Yes, you will have to use the terminal. **But do not fear!**  
I have attempted to make the experience as user friendly as possibly with overly detailed instructions. 

# Disclaimer

*For obvious reasons, I will not show you how to obtain the game files. You should, of course, buy a legitimate copy (they go for around $200 on eBay) and rip it yourself. Pretty cool to own if nothing else — but I'm getting off-topic.*

*Anyway, **I do not endorse or condone piracy of any kind**. This repo includes some audio and imagery from the game — nothing that can't easily be found on YouTube or with a quick Google image search.  
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
- Powershell 5 (should come with Windows 10 and above)

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
Extract the zip and enter the directory.

### Git method
Alternativly, just use `git`:
```
git clone https://github.com/edermats32/Rondo-Transpatcher.git
```
```
cd Rondo-Transpatcher
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

## Steps for Linux



# Manual Patching (for nerds)
Here is how you can patch the game without my scripts.  
This is for you who rather run the commands yourself, or maybe you just don't trust my scripts.

If you are feeling adventurous, there is a `readme.txt` in each folder that explains some things.  
They don't really serve much purpose, but might be fun to read.
