####################################################################################################################

Team Members: Cory Harris, Jesus Jimenez, Zia Kim, Zoraya Sanchez de la Vega, Christopher Zhou

####################################################################################################################

.data
    array:  .byte '-':36  
    strNewLine:  .asciiz "\n"
    strSpace:  .asciiz " "
    strNumPlayer:  .asciiz "\nPlease choose the number of players.\n1 for playing against a computer, 2 for playing against another user: "
    strPlayer:  .asciiz "\nPlease choose a player. X goes first.\n1 for X, 2 for O: "
    strPlayer2:  .asciiz "\nFirst player with X goes first. Second player will go next with O."
    strWelc2:  .asciiz "  [ MIPS TIC-TAC-TOE GAME ]\n\n  Welcome adventurer!\n\n  The game:\n\n  In this game you will have to choose a player X or O. You will be playing against the computer or another user.\n  You will be filling the board shown below. Your objective is to complete a row, column, or diagonal in any direction.\n  But hold your horses! is not that easy. As I said, you will be playing against the computer or a user who will make sure you don't win.\n  You will be switching turns to play after each move until someone wins. If the board fills up and none of you manage to win, then it's a draw!\n\n  To place your mark in the board, you will have to type a number from 0 to 8 to choose a desired position as shown in the board below.\n\n  0 1 2 \n  3 4 5 \n  6 7 8 \n\n  GOOD LUCK !\n\n"
    strWelc1: .asciiz " **********************************************************************************\n **********************************************************************************\n\n"
    strInput:  .asciiz "\n\nPlayer, enter a number from 0 to 8 to make your move in the board: "
    strInput2:  .asciiz "\n\nSecond player, enter a number from 0 to 8 to make your move in the board: "
    strCompMove: .asciiz "\n\nThe Computer is choosing its move.\n"
    strXWin:  .asciiz "\n\nGAMEOVER\n\nPlayer X wins!"
    strYWin:  .asciiz "\n\nGAMEOVER\n\nPlayer O wins!"
    strDraw:  .asciiz "\n\nGAMEOVER\n\nIt's a draw!"
    strError1:  .asciiz "\nInvalid number. Please enter a number between 0 and 8: "
    strError2:  .asciiz "\nInvalid move. The box choosen is not available. Please choose an available box: "
    strError3:  .asciiz "\nInvalid number. Please enter a number between 1 and 2: "
    menu1:  .asciiz "\n\nWould you like to play again? 1 for yes, 2 for no: "

.text
main:
####################################################################################################################
# Print welcome message
	
	la $a0, strNewLine	# Load string
	li $v0, 4		# 4 means print string
	syscall
	la $a0, strNewLine	# Load string
	li $v0, 4		# 4 means print string
	syscall	
	la $a0, strWelc1	# Load string
	li $v0, 4		# 4 means print string
	syscall
	la $a0, strWelc2	# Load string
 	li $v0, 4		# 4 means print string
    	syscall
    	la $a0, strWelc1	# Load string
	li $v0, 4		# 4 means print string
	syscall
#####################################################################################################################
# Choose number of players: 1 for playing against computer, 2 for against another user
	la $a0, strNumPlayer		# Load string
 	li $v0, 4		# 4 means print string
    	syscall
# Get Input
    	select1:
	addi $s2, $zero, 0	# Clean register $s2
	addi $s1, $zero, 0	# Clean register $s1
	addi $s0, $zero, 0	# Clean register $s0
	addi $t9, $zero, 0	# Clean register $t9
	
    	li $v0, 5		# 5 means get integer input
    	syscall
    	move $s0, $v0		# Store input in $s0
# Set flag
	beq $s0, 1, one		# If input == 1 play with computer
	beq $s0, 2, two		# If input == 2 play with another user
	
	li $v0, 4
	la $a0, strError3	# Invalid input
	syscall
	j select1
	
	one:
		j play1
	two:
		addi $s2, $zero, 1	# Start with the first player
		addi $t9, $zero, 1	# t9 = 1 will mean that there exists the second player
		la $a0, strPlayer2	# Load string
 		li $v0, 4		# 4 means print string
    		syscall
    		
    		li $s0, 'X'	# Assign X to $s0
		li $s1, 'O'	# Assign O to $s1
		j exit3

#####################################################################################################################
play1:
# Choose a player
# Print the instruction
	la $a0, strPlayer	# Load string
 	li $v0, 4		# 4 means print string
    	syscall
# Get Input
	select2:
	addi $s2, $zero, 0	# Clean register $s2
	addi $s1, $zero, 0	# Clean register $s1
	addi $s0, $zero, 0	# Clean register $s0
	
	li $v0, 5		# 5 means get integer input
	syscall
	move $s2, $v0		# Store input in $s2
# Set flag
		beq $s2, 1, human	# If input == 1 human starts
		beq $s2, 2, computer	# If input == 2 computer starts
		
		li $v0, 4
		la $a0, strError3	# invalid input
		syscall
		j select2
	human:
		li $s0, 'X'	# Assign X to $s0
		li $s1, 'O'	# Assign O to $s1
		j exit3
	computer:
		li $s0, 'O'	# Assign O to $s0
		li $s1, 'X'	# Assign X to $s1
	exit3:
#####################################################################################################################
	while:	
# Check if the board is full
	addi $t1, $zero, 0		# Clean register $t1
	addi $t0, $zero, 0		# Clean register $t0
	loop1:
		beq $t0, 36, draw	# Check iteration. 4 x 9 bytes (each register is 4 bytes)
		lb $t1, array($t0)	# Load the address of the array in register $t1
		addi $t0,$t0, 4		# Update the address
		# Check if the board is full (checks if there is at least 1 dash left in the array)
		beq $t1, '-', exit1	# Exit if a dash is found
		
		j loop1			# Jump
	draw:				# End the program if the board is full
		la $a0, strDraw		# Load String
		li $v0, 4		# 4 means print string
		syscall
		j endmenu
	exit1:
######################################################################################################################
# Jump to player
	beq $s2, 1, human1	# If input == 1 human's turn
	beq $s2, 2, computer1	# If input == 2 computer's turn
	beq $s2, 3, human2	# If input == 3 second human's turn
######################################################################################################################
# Human move
human1:
	addi $t7, $zero, 0      #clean register $t7
	addi $t8, $zero, 0      #clean register $t8
	addi $t3, $zero, 0	# Clean register $t3
	addi $t2, $zero, 0	# Clean register $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
# Print instruction
	la $a0, strInput	# Load string
 	li $v0, 4		# 4 means print string
    	syscall
# Get Input
	DoWhile:
		li $v0, 5		# 5 means get integer input
		syscall
		move $t0, $v0		# Store input in $t0
	
		li $t2,0
		li $t3,8
		#if index out of bounds keep getting new integers from player
		blt $v0,$t2,errOutofBounds
		bgt $v0,$t3,errOutofBounds
	
# Modify the array
	sll $t1, $t0, 2		# Multiply the input by 4
	
	lb $t7, array($t1)
	beq $t7, '-', continue1
	li $v0,4
	la $a0, strError2 # .asciiz "\nInvalid move. The box choosen is not available. Please choose an available box" 	    	    	    	    	    	    	
    	syscall
	j DoWhile
	
	continue1:
	sb $s0, array($t1)	# Update array with human mark
# Switch player
	beq $t9, 1, secHum	
#Switch player to computer
	addi $s2, $zero, 2	# Switch flag value for computer
	j exit4
	
	secHum:
		addi $s2, $zero, 3	# Switch flag value for second human
		j exit4
	
 #error handling : out of bounds exception and taken index
    	errOutofBounds:
    		li $v0,4
		la $a0, strError1	#error1:  .asciiz "\nInvalid number. Please enter a number between 0 and 8" 	    	    	    	    	    	    	
    		syscall
    		j DoWhile
    		
######################################################################################################################
human2:
	addi $t7, $zero, 0      #clean register $t7
	addi $t8, $zero, 0      #clean register $t8
	addi $t3, $zero, 0	# Clean register $t3
	addi $t2, $zero, 0	# Clean register $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
# Print instruction
	la $a0, strInput2	# Load string
 	li $v0, 4		# 4 means print string
    	syscall
# Get Input
	DoWhile3:
		li $v0, 5		# 5 means get integer input
		syscall
		move $t0, $v0		# Store input in $t0
	
		li $t2,0
		li $t3,8
		#if index out of bounds keep getting new integers from player
		blt $v0,$t2,errOutofBounds3
		bgt $v0,$t3,errOutofBounds3
	
# Modify the array
	sll $t1, $t0, 2		# Multiply the input by 4
	
	lb $t7, array($t1)
	beq $t7, '-', continue3
	li $v0,4
	la $a0, strError2 # .asciiz "\nInvalid move. The box choosen is not available. Please choose an available box" 	    	    	    	    	    	    	
    	syscall
	j DoWhile3
	
	continue3:
	sb $s1, array($t1)	# Update array with human mark
# Switch player
	addi $s2, $zero, 1	# Switch flag value
	j exit4
	
 #error handling : out of bounds exception and taken index
    	errOutofBounds3:
    		li $v0,4
		la $a0, strError1	#error1:  .asciiz "\nInvalid number. Please enter a number between 0 and 8" 	    	    	    	    	    	    	
    		syscall
    		j DoWhile3
	
######################################################################################################################
computer1:
	addi $t8, $zero, 0      #clean register $t8
	addi $t0, $zero, 0	# Clean register $t0
	addi $t1, $zero, 0	# Clean register $t1
	addi $t2, $zero, 0	# Clean register $t2
# Print instruction
	la $a0, strCompMove	# Load string
 	li $v0, 4		# 4 means print string
    	syscall
# Generate a random number
	DoWhile2:
		li $v0, 42  		# 42 means generate random int
		li $a1, 9 		# $a1 is where you set the upper bound
		syscall     		# The number will be at $a0
	
	# Modify the array
	sll $t0, $a0, 2		# Multiply the input by 4
	
	lb $t8, array($t0)
	beq $t8, '-', continue2  		# keep generating a random integer 0~8 until computer choses empty box
	j DoWhile2
	continue2:
	
	sb $s1, array($t0)	# Update array with computer mark
# Switch Player
	addi $s2, $zero, 1	# Switch flag value
######################################################################################################################
	exit4:
# Print array
	addi $t3, $zero, 0	# Clean register $t3
	addi $t2, $zero, 12	# Add 12 to $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
	loop2:
		beq $t0, 36, exit2	# Check iteration. 4 x 9 bytes (each register is 4 bytes)
		lb $t1, array($t0)	# Load the address of the array in register $t1
		div $t0, $t2		# $t0 mod 12
        	mfhi $t3          	# temporal register for the mod
		addi $t0, $t0, 4	# Update the address
		beq $t3, 0, jumpLine	# If mod == 0 jump a line
		bne $t3, 0, continue	# If mod !== 0 continue
	jumpLine:
		la $a0, strNewLine	# Load string
 		li $v0, 4		# 4 means print string
    		syscall
	continue:
		# Print current number
		move $a0, $t1		# Move value $t1 to $a0
		li $v0, 11		# 11 means print char
		syscall
		la $a0, strSpace	# Load string
 		li $v0, 4		# 4 means print string
    		syscall
		
		j loop2		#Jump
	exit2:
#######################################################################################################################	
# Check for a winner
	addi $t3, $zero, 0	# Clean register $t3
	addi $t2, $zero, 0	# Clean register $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
# Check rows
	rowLoop:		# Row loop to check all the rows
	lb $t0, array($t3)	# Load column 0 in register $t0
	addi $t3, $t3, 4	# Move to next column
   	lb $t1, array($t3)	# Load column 1 in register $t1
    	addi $t3, $t3, 4	# Move to next column
    	lb $t2, array($t3)	# Load column 2 in register $t2
    	# Check X
    	beq $t0, 'X', checkX1row	# Compare $t0 with X. Go to the next column if they are equal
   	j checkOrow			# If not, check for Os
   	checkX1row:
    	beq $t1, 'X', checkX2row	# Compare $t0 with X. Go to the next column if they are equal
   	j checkOrow			# If not, check for Os
   	checkX2row:
    	beq $t2, 'X', winnerX		# Compare $t0 with X. X is the winner if they are equal
    	# Check O
    	checkOrow:			# Check for Os
    	beq $t0, 'O', checkO1row	# Compare $t0 with O. Go to the next column if they are equal
    	addi $t3, $t3, 4		# If not, update $t3
    	beq $t3, 36, checkColumns	# Check columns if all rows checked
   	j rowLoop			# Check the next row
   	checkO1row:
   	beq $t1, 'O', checkO2row	# Compare $t0 with O. Go to the next column if they are equal
   	addi $t3, $t3, 4		# If not, update $t3
   	beq $t3, 36, checkColumns	# Check for columns if all rows checked
   	j rowLoop			# Check the next row
   	checkO2row:
   	beq $t2, 'O', winnerO		# Compare $t0 with O. O is the winner if they are equal
   	addi $t3, $t3, 4		# If not, update $t3
   	beq $t3, 36, checkColumns	# Check columns if all rows checked
   	j rowLoop			# Check the next row
# Check columns
	checkColumns:
	addi $t3, $zero, 0	# Clean register $t3
	addi $t2, $zero, 0	# Clean register $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
	columnLoop:		# Column loop to check all the rows
	lb $t0, array($t3)	# Load row 0 in register $t0
	addi $t3, $t3, 12	# Move to next row
   	lb $t1, array($t3)	# Load row 1 in register $t0
    	addi $t3, $t3, 12	# Move to next row
    	lb $t2, array($t3)	# Load row 2 in register $t0
    	# Check X
    	beq $t0, 'X', checkX1column	# Compare $t0 with X. Go to the next row if they are equal
    	j checkOcolumn			# If not, check for Os
    	checkX1column:
    	beq $t1, 'X', checkX2column	# Compare $t0 with X. Go to the next row if they are equal
    	j checkOcolumn			# If not, check for Os
    	checkX2column:
    	beq $t2, 'X', winnerX		# Compare $t0 with X. X is the winner if they are equal
    	# Check O
    	checkOcolumn:			# Check for Os
    	beq $t0, 'O', checkO1column	# Compare $t0 with O. Go to the next row if they are equal
    	beq $t3, 32, checkDiagonalLR	# Check for diagonal LR if all rows checked
    	subi $t3, $t3, 20		# If not, update $t3
    	j columnLoop			# Check the next column
    	checkO1column:
    	beq $t1, 'O', checkO2column	# Compare $t0 with O. Go to the next row if they are equal
    	beq $t3, 32, checkDiagonalLR	# Check for diagonal LR if all rows checked
    	subi $t3, $t3, 20		# If not, update $t3
    	j columnLoop			# Check the next column
    	checkO2column:
    	beq $t2, 'O', winnerO		# Compare $t0 with O. O is the winner if they are equal
    	beq $t3, 32, checkDiagonalLR	# Check for diagonal LR if all rows checked
    	subi $t3, $t3, 20		# If not, update $t3
    	j columnLoop			# Check the next column
# Check diagonal LR
	checkDiagonalLR:
	addi $t3, $zero, 0	# Clean register $t3
	addi $t2, $zero, 0	# Clean register $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
	lb $t0, array($t3)	# Load row 0, column 0
	addi $t3, $t3, 16	# Go to the next box
    	lb $t1, array($t3)	# Load row 1, column 1
    	addi $t3, $t3, 16	# Go to the next box
 	lb $t2, array($t3)	# Load row 2, column 2
    	# Check X
    	beq $t0, 'X', checkX1LR	# Compare $t0 with X. Go to the next box if they are equal
    	j checkOLR		# If not, check for Os
    	checkX1LR:
    	beq $t1, 'X', checkX2LR	# Compare $t0 with X. Go to the next box if they are equal
    	j checkOLR		# If not, check for Os
    	checkX2LR:
     	beq $t2, 'X', winnerX	# Compare $t0 with X. X is the winner if they are equal
    	# Check O
    	checkOLR:		# Check for Os
    	beq $t0, 'O', checkO1LR	# Compare $t0 with O. Go to the next box if they are equal
    	j checkDiagonalRL	# If not, check diagonal RL
    	checkO1LR:
    	beq $t1, 'O', checkO2LR	# Compare $t0 with O. Go to the next box if they are equal
    	j checkDiagonalRL	# If not, check diagonal RL
    	checkO2LR:
    	beq $t2, 'O', winnerO	# Compare $t0 with O. O is the winner if they are equal
    	j checkDiagonalRL	# If not, check diagonal RL
# Check Diagonal RL
	checkDiagonalRL:
	addi $t3, $zero, 8	# Initialize register $t3 with 8
	addi $t2, $zero, 0	# Clean register $t2
	addi $t1, $zero, 0	# Clean register $t1
	addi $t0, $zero, 0	# Clean register $t0
	lb $t0, array($t3)	# Load row 0, column 2
	addi $t3, $t3, 8	# Go to the next box
    	lb $t1, array($t3)	# Load row 1, column 1
    	addi $t3, $t3, 8	# Go to the next box
    	lb $t2, array($t3)	# Load row 2, column 0
    	# Check X
    	beq $t0, 'X', checkX1RL	# Compare $t0 with X. Go to the next box if they are equal
    	j checkORL		# If not, check for Os
    	checkX1RL:
    	beq $t1, 'X', checkX2RL	# Compare $t0 with X. Go to the next box if they are equal
    	j checkORL		# If not, check for Os
    	checkX2RL:
    	beq $t2, 'X', winnerX	# Compare $t0 with X. X is the winner if they are equal
    	# Check O
    	checkORL:		# Check for Os
    	beq $t0, 'O', checkO1RL	# Compare $t0 with O. Go to the next box if they are equal
    	j exit6			# If not, exit
    	checkO1RL:
    	beq $t1, 'O', checkO2RL	# Compare $t0 with O. Go to the next box if they are equal
    	j exit6			# If not, exit
    	checkO2RL:
    	beq $t2, 'O', winnerO	# Compare $t0 with O. O is the winner if they are equal
    	j exit6			# If not, exit
# Winners
    	winnerX:
		la $a0, strXWin		# Load String
		li $v0, 4		# 4 means print string
		syscall
		j endmenu
	winnerO:
		la $a0, strYWin		# Load String
		li $v0, 4		# 4 means print string
		syscall
		j endmenu
    	exit6:
	j while				# Main loop
#######################################################################################################################	
# End of the program
endmenu:
	li $v0, 4
	la $a0, menu1
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 1, main #clean 
	bne $v0, 2, endmenu_error
	j exit
	
#clean:
#	li $s0, '-'
#	addi $t1, $zero, 0	# Clean register $t1
#	addi $t0, $zero, 0	# Clean register $t0
#	loop0:
#		beq $t0, 12, main
#		lw $t1, array($t0)
#		addi $t0, $t0, 4 	# Update the address
#		sb $s0, array($t1)
#		j loop0		#Jump
#	j main

endmenu_error:
	li $v0, 4
	la $a0, strError3	# invalid input
	syscall
	j endmenu

exit:
	li $v0, 10	# 10 means terminate program
	syscall
