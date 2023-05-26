# Empty arguments and return void
# Print the array of moves stored in a byte array with another byte counting how many are valid so far
# Called inside display()

.globl showMoves, storedMoves, movesCount # function name and two data

.data
	historyStr:	.asciiz "MOVES HISTORY\n#    X    O\n------------\n"
	spaces:		.asciiz "    "

	### values are updated in main program only in place(), movesCount reset to 0 in startGame()
	# 225 possible moves to fill board regardless of a tie being possible...
	# One byte for each move shows integer offset from board[0][0], max of 2^8-1 = 255 is okay since offset is limited to 225
	storedMoves:	.space 255
	
	# One byte for number of completed moves, used for sentinel in following loop for displaying
	movesCount:	.space 1

.text
showMoves:
	la $t0, storedMoves	# address of array of each move
	li $t1, 1		# number of moves shown in display
	li $t3, 15		# const to divide offsets
	lb $t8, movesCount	# real number of moves stored so far
	beq $t8, $zero, skip
	li $v0, 4
	la $a0, historyStr
	syscall
	showMstart:
		li $v0, 1
		add $a0, $zero, $t1
		syscall 		# Print int, move number
	
		li $v0, 4
		la $a0, spaces
		syscall
		
		# First move always X, second O, etc...do not need to check which one the player chose to display this
		# print(X), if (movesCount % 2 == 0)
		andi $t9, $t1, 1 # if movesCount AND 00000001 then LSb=0 meaning an even number
		beq $t9, $zero, O_spaces
		j printMove
O_spaces:
		li $v0, 4
		la $a0, spaces
		syscall
		
printMove:
		# Convert integer offset to board index (char,number)
		lbu $t2, ($t0)		# Integer at address in storedMoves[]
		div $t2, $t3		# divide Integer offset by 15
		mfhi $a0
		addi $a0, $a0, 'A' 	# Convert remainder, representing column, into the ASCII letter
		li $v0, 11
		syscall
		mflo $a0
		addi $a0, $a0, 1 	# Convert division, representing row, into 1-based
		li $v0, 1
		syscall
		
		li $v0, 11
		li $a0, '\n'
		syscall
	
		addi $t0, $t0, 1		# Next address
		addi $t1, $t1, 1		# Next move number
		ble $t1, $t8, showMstart	# while (displayedMoves (t0) <= movesCount (t8))
skip:
	jr $ra


	
