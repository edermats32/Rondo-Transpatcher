# Rondo-Transpatcher
![Rondo-Transpatcher Logo](https://github.com/user-attachments/assets/7be4009e-9ad8-4f20-a434-6456846d08f2)  
Just a script to apply the Rondo of Blood English Translation Patch.
# Table of Contents
#### Informative stuff:
- [Introduction](#introduction)
- [Disclaimer](#disclaimer)

#### The stuff *you're* interested in:
- [Requirements](#requirements)
    + [Game](#game)
    + [System](#system)
- [Setup](#setup)
    + [Get the files from this repo](#get-the-files-from-this-repo)
        * [Zip method](#zip-method)
        * [Git method](#git-method)
- [Patch Guide](#patch-guide)
    + [Adding the source game](#adding-the-source-game)
    + [Steps for Windows](#steps-for-windows)
    + [Steps for Linux](#steps-for-linux)
    + [Locate your patched game](#locate-your-patched-game)

#### Nerd stuff:
- [Manual Patching (for nerds)](#manual-patching-for-nerds)
- [Credits](#credits)

# Introduction

A new Translation Patcher for Rondo of Blood's English Patch.  
This is **NOT** a new translation just a new patcher script, since I had some problems with the old patcher.  
Hopefully this will make the process easier for other people to.

All hacking credit goes to the creators of the patch: https://www.romhacking.net/translations/846/  
The patch is however included in this repo for user convinience.

I have created two seperate scripts.  
A Powershell 5 Script for Windows users and a SHELL Script for Linux users.  

Yes, you will have to use the terminal. **But do not fear!**  
I have attempted to make the experience as user friendly as possibly with detailed instructions. 

# Disclaimer

*For obvious reasons, I will not show you how to obtain the game files. You should, of course, buy a legitimate copy and rip it yourself.*

***I do not endorse or condone piracy of any kind**.*

*This repo includes some audio and imagery from the game — nothing that can't easily be found on YouTube or with a quick Google image search. 
If the rightful owners believe any content in this repo should be taken down, I will promptly and willingly comply.*

# Requirements
## Game
A copy of [Akumajō Dracula X: Chi no Rondo](https://www.ebay.com/sch/i.html?_nkw=Akumaj%C5%8D+Dracula+X%3A+Chi+no+Rondo) ripped to any of these formats:
- CUE-file + ISO & WAV Tracks  
***Track02 and Track22 as ISO, the rest in WAV.***

- CUE-file + One large bin-file  
***The bin-file contains all 22 tracks.***
  
- CUE-file + BIN tracks  
***All 22 tracks are in separate bin-files.***

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
Start by adding your game files. Navigate to the `source` sub-folder inside the Rondo-Transpatcher folder.
Put your files in the folder that matches your rip type:

| RIP TYPE | FOLDER |
|----------|----------|
| BIN+CUE   | `bin_cue` |
| BIN+CUE (multiple bin-files)  | `bin_cue` |
| ISO+WAV+CUE   | `iso_wav_cue`   |

<img width="1365" height="706" alt="image" src="https://github.com/user-attachments/assets/8e8c10a3-8349-4ede-b94c-dff73bbc8f47" />

<br>
<br>
Now the step differ a bit depending on your operating system.  
Choose your operating system below:

- [Windows](#steps-for-windows)
  
- [Linux](#steps-for-linux)
<br>

## Steps for Windows
Inside the root of the `Rondo-Transpatcher-main` folder there is a shortcut file `RondoTranspatcherEasyRun`.  
Dubble-click the shourtcut and powershell window should open:

<img width="1367" height="711" alt="image" src="https://github.com/user-attachments/assets/e5a21b72-e2a2-4104-82f7-9e73d61ad224" />

If for some reason the shortcut didn't work, open a powershell window in the `Rondo-Transpatcher-main` folder and run the file with:
```
.\rondo-transpatcher.ps1
```

Now you should see the selection screen.  
Type the number that matches you rip-type and press enter:

<img width="1362" height="713" alt="image" src="https://github.com/user-attachments/assets/2b7df363-11c8-4866-beaf-d7c85de8c317" />

If the patch was successful continue to the final step of the guide: [Locate your patched game](#locate-your-patched-game)


## Steps for Linux
Open your terminal of choice. If you're unsure, search for *terminal* in your Desktop Enviornments search function.  
Navigate to where you extracted the zip-file (or git cloned).  
If you did it in your `Downloads` folder you can run this command:
```sh
cd ~/Downloads/Rondo-Transpatcher-main
```
Run the script with:
```sh
sh ./rondo-transpatcher.sh
```
Now you should see the selection screen.  
Type the number that matches you rip-type and press enter:

<img width="972" height="698" alt="image" src="https://github.com/user-attachments/assets/ede0d27a-10fa-454a-a3b9-3894945d8764" />

If the patch was successful continue to the final step of the guide: [Locate your patched game](#locate-your-patched-game)

## Locate your patched game
Your patched game will be in the output folder:

<img width="1365" height="713" alt="image" src="https://github.com/user-attachments/assets/741aeeba-a636-4f85-85ce-cbd0782452a8" />



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

Here is the SHA256 value for TRACK02 if you want to validate your's:
```sh
6386b25fd60b9dd30ee55c5ac5d3221c993c7e18a735340154b361b321338594 # Track02 (ISO)
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

# Credits
| Contributor     | Type of Contribution     | Listed Credit                                                                 |
|----------------|--------------------------|--------------------------------------------------------------------------------|
| Burnt Lasagna  | Production               | Directed the project and did all the audio work and some graphics hacking.     |
| cubanraul      | Original Hacking         | The director back in 2004–2006. Worked on some text/audio hacking.             |
| Tomaitheous    | Hacking                  | His contributions are too numerous to list here. Please check the readme.      |
| pemdawg        | Original / Translation   | Worked on some early translation and text hacking in 2004–2005.                |
| DarknessSavior | Translation              | Did the translation for the ferryman, signs, and the error message billboard.  |
| Fragmare       | Graphics                 | Made the graphic for the new title screen.                                     |
| ReyVGM         | Graphics                 | Made the new English graphics for the signs.                                   |
| Vanya          | Graphics                 | Made the “Castlevania: Oops, Wrong Game!!!” title screen.                      |
| edermats32     | Wasting of time          | Made this new script, Rondo-Transpatcher. Guess that means Linux support.
