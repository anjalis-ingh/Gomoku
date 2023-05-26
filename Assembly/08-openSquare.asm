.globl openSquare

# a0 = the move position as a string
openSquare:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	# arg0 = a0 = user input
	jal strToBoardIndex
	
	lb $t0, board($v0)		# t0 = board char at specified place
	lb $t1, emptyChar($zero)	# t1 = character for empty spots
	beq $t0, $t1, empty
	filled:
		li $v0, 0 		# false, not open
		j return
	empty:
		li $v0, 1 		# return true, move can be placed at this square
	
	return:
		lw $ra, ($sp)		# reset return address
		addi $sp, $sp, 4
		jr $ra
