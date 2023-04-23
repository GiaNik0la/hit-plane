# hit-plane
This is a game I made in c64 assembly language, the game is simple. you can move up and down and you can change your bullet color by numbers, and shoot. if the colors of the target and the bullet match you will hit the target.

# Requirements

You need to download:
Kickassembler http://theweb.dk/KickAssembler/Main.html#frontpage
Vice https://vice-emu.sourceforge.io/

# How to run

type in this command
java -jar "{type the path to kickass here}KickAss.jar" "$(FULL_CURRENT_PATH)" -o "$(CURRENT_DIRECTORY)\$(NAME_PART).prg" -showmem -execute "(path to vice)\bin\x64sc.exe" 
