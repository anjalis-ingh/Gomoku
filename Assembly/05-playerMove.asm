.data
usermove:	.asciiz "MOVE: "	# declare String for Player Movement Selection
userInput:	.space 20		# storage for user input

.text
.globl playerMove
playerMove:
	addi $sp, $sp, -4	# set stack
	sw $ra, ($sp)		# set return address
	jal display
	
	getInput:
		la $a0, usermove	# set $a0 = address of usermove
		li $v0, 4 		# $v0 code 4 = print string
		syscall
		
		li $v0, 8 		# $v0 code 8 = read string
		la $a0, userInput		# buffer address, change or else it will overwrite "usermove"
		li $a1, 20 		# max length for an fgets, can take n-1 letters then add \0 or n-x and add \n\0
		syscall			# there could still be excess left in stdin BUT REALLY 20 LETTERS
		
		#Replace \n with \0
		move $t0, $a0 				# 
		nullLoop: #while currChar != \n -> currChar++
			lb $t1, 0($t0) 			# 
			beq $t1, '\n', nullLoop_end 		# 
			addi $t0, $t0, 1 		# 
			j nullLoop 				# 
		nullLoop_end:
		
		li $t1, '\0' 				# 
		sb $t1, 0($t0)				# 
		
		la $a0, userInput 				# 
		jal validateGeneral	# calling display() method
		
		bne $v0, $zero, goodInput 	# validate returned false, require new user input
		# Play error sound
		li $v0, 33 	# MIDI out
		li $a0, 60 	# Middle C
		li $a1, 800 	# Milliseconds
		li $a2, 31	# Instrument with ID 31 is like an eletric guitar harmonic
		li $a3, 63	# Volume
		syscall
		j getInput
	
goodInput:
		la $a0, userInput	# arg0 = user input string
		jal strToBoardIndex
		
		move $a0, $v0			# arg0 = index to place = v0 from strToBoardIndex
		lb $a1, playerChar($zero)	# arg1 = char to place
		jal place
		
	return:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
