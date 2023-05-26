# args(int row, int col, char)
# input is already validated
# place correct char ASCII value within board
# call checkWin() 

# global procedure
.globl place

.data
fullBoard:	.asciiz "Game over, it's a tie...\n"

# a0 = index to be placed at
# a1 = char to place
.text

	place:
		sb $a1, board($a0) 	# set the memory representing a board space to have X or O
		
		# Save the move into an array for the "Move History" display function
		lb $t0, movesCount		# amount of moves previously done..
		li $t8, 225
		beq $t0, $t8, maxMoves		# 0-224 (225 moves) have been made, movesCount=225 means board is full with a tie
		sb $a0, storedMoves($t0)	# ..used as next open index to store at
		addi $t0, $t0, 1
		sb $t0, movesCount		# increment movesCount in data section
		
		# Push return address and pop after calling checkWin
		addi $sp, $sp, -4
		sw $ra, ($sp)
		jal checkWin
		lw $ra, ($sp)
		addi $sp, $sp, 4

		jr $ra
		
	maxMoves:
		# Run when board is full of X and O with no win...
		# If possible, handle when this tie occurs
		li $v0, 4
		la $a0, fullBoard
		syscall
		
		# Set gameWon to true to make the endgame handler run
		# No player will be announced since scan() will never be called
		li $t0, 1
		sb $t0, gameWon
		li $a0, 88
		jal checkWin
