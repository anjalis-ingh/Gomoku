# No arguments
# Called at start of program and if player chooses to go again
# Set global boolean 'gameWon' flag to false
# Initialize the board array with '.' for blanks
# Validate player input to play as X (Black) or O (White) and set global 'playerChar'

.globl startGame # Make procedure global

.data
	# String for Player's character selection
	choose:	.asciiz	"\nChoose Black (X) or White (O): "

.text	
	# initialize global variables
	startGame:
		sb $zero, movesCount		# global variable from showMoves...reset the count of valid player + computer choices

		# set gameWon global variable
		li $t0, 0
		sb $t0, gameWon			# set byte at address of gameWon to $t0 (false)
		
		# prep for populateArray
		lb $t0, emptyChar		# t0 has char for empty space, set in main as '.'
		la $t1, board 			# t1 has beginning address of board's 225 bytes (get memory location of board[0][0])
		li $t2, 225 			# max game board size
		add $t2, $t2, $t1 		# t2 has memory address of the byte following 225th space, board[14][14] (used as stop condition)
	
	# initializes board matrix with dummy character
	# increment by 1 to set each of 225 spaces to '.'
	populateArray:
		sb $t0, ($t1) 			# set board($t1) = $t0
		addi $t1, $t1, 1 		# increment board array position ($t1 used as index)
		bne $t1, $t2, populateArray	# if($t1 != $t2) then {loop}

	# validate and set player selection
	playerSelection:
		# display player-character selection string
		li $v0, 4	# syscall 4 to print string
		la $a0, choose	# set $a0 = address of choose
		syscall

		# receive input
		li $v0, 12	# $v0 code 12 = read character
		syscall 			
		add $t2, $zero, $v0	# save player input to t2

		li $v0, 11		# $v0 code 11 = print character
		li $a0, 10		# ASCII '\n'
		syscall

		# if (playerInput == 'X' || PlayerInput == 'O') break;
		# else playerSelection();
		beq $t2, 'X', playerX			# if($t0 == $t2) then {return}
		bne $t2, 'O', playerSelection		# if($t0 == $t2) then {break} else {loop}
		j playerO
	
	playerX:
		li $t0, 'X'	
		li $t1, 'O'
		j return
	
	playerO:
		li $t0, 'O'
		li $t1, 'X'
	
	return:
		sb $t0, playerChar
		sb $t1, computerChar
		jr $ra
