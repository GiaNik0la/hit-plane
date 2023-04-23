# hit-plane
This is a game I made in c64 assembly language, the game is simple. you can move up and down and you can change your bullet color by numbers, and shoot. if the colors of the target and the bullet match you will hit the target. if you colide with any of the enemies you get damaged and loose a score. after 3 colisions you die. bullet color and score is on top of the screen

![Game](giphy.gif) [](giphy.gif)

# Requirements

### You need to install:
- Kickassembler http://theweb.dk/KickAssembler/Main.html#frontpage
- Vice https://vice-emu.sourceforge.io/

# How to run

type in this command and where there is curly brackets follow the insturctions inside them:
</br>
```
java -jar "{type the path to kickass here}KickAss.jar" "{path to the game file}code.asm" -o "{path to the game file}code.prg" -showmem -execute "{path to vice}\bin\x64sc.exe"
```

To start the game you need to press <b>Fire</b>

# Controls

the controls are:
- Fire: Numpad <kbd>0</kbd>
- Up: Numpad <kbd>8</kbd>
- Down: Numpad <kbd>2</kbd>
- Change the color of bullet: numbers <kbd>1</kbd>-<kbd>6</kbd>

### What if I don't like the controls?

they can be changed in the vice settings.
