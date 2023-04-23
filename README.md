# hit-plane
This is a game I made in c64 assembly language, the game is simple. you can move up and down and you can change your bullet color by numbers, and shoot. if the colors of the target and the bullet match you will hit the target.

![Game](giphy.gif) /! [](giphy.gif)

# Requirements

You need to download:
Kickassembler http://theweb.dk/KickAssembler/Main.html#frontpage
</br>
Vice https://vice-emu.sourceforge.io/

# How to run

type in this command and where there is curly brackets follow the insturctions inside them:
java -jar "{type the path to kickass here}KickAss.jar" "{path to the game file}{asm file name}.asm" -o "{path to the game file}{asm file name}.prg" -showmem -execute "{path to vice}\bin\x64sc.exe" 
