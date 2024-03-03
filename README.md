# ColorCruncher
Color cruncher has a concept similar to pacman except that instead of avoiding moving ghosts. We have to avoid static red blocks and eat green ones to score points. Moving through walls brings you back at the opposite end and hitting a red block will lead to Game Over. Movement speed of the asterisk is implemented via timer interrupt and keyboard interrupt is used to interact and play via the keyboard

# How to run
Open dosbox
Mount the project
Enter the project directory
Run .exe file for the program

# Project requirements
•	The game will start when you run your program on DOSBox.
•	Clear your screen and Place Green and Red cells on the whole screen at the start of your game i.e., some of the locations have red background and some of the locations have green background.
•	Initially an asterisk ‘*’ (ASCII code 0x2A) will be moving towards right i.e., the ‘*’ will start from a starting position (0, 0) and it will keep moving from the first to last column of the first row until the user changes its direction, making each movement after one second. Hint: Hook timer interrupt (8h) and make the movement in the timer interrupt service routine after 1 second. Timer interrupt comes 18 times per second.

•	Direction of the ‘*’ can be changed by using Up, Down, Left or Right arrow keys. Hint: Hook keyboard interrupt (9h) and change the direction variable when Up, Down, Left or Right arrow keys are pressed.

•	Downward movement means the ‘*’ will keep moving from first to last row of same column until user changes its direction. Upward movement means the ‘*’ will keep moving from last to first row of same column until user changes its direction. Leftward movement means that ‘*’ will keep moving from the last to first column of the particular row until user changes the direction.

•	If the ‘*’ crosses a green cell, one point is added to your score and the cell is cleared (i.e., it becomes black). Display score on the right upper corner of the screen.

•	If the ‘*’ hits a Red cell, the game is over and it terminates successfully i.e. your program will terminate and DOSBOX and command prompt will run normally.
