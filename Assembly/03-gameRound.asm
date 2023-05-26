# No arguments
# Called in loop in main
# Call computerMove then playerMove if Player chose to be O (White) or vice versa for X

# global procedures
.globl	gameRound

.data
	# String asking for player movement selection
	usermove:	.asciiz "MOVE: "
	string:		.space 	20

.text

gameRound:
	addi $sp, $sp, -4 # set stack
	sw $ra, ($sp)	   # set return address
	
	li $t0, 79 			# set $t0 = 79 = ASCII value for 'O'
	lb $t1, playerChar		# set $t1 = playerChar
	beq $t0, $t1, compFirst 	# if(playerChar == O) then {jump to compMove} else (fall through to player first)
	
	playerFirst:
		jal playerMove
		lb $t0, gameWon
		bne $t0, $zero, return # return to main to handle if player won
		jal computerMove
		j return
	
	compFirst:
		jal computerMove
		lb $t0, gameWon
		bne $t0, $zero, return # return to main if computer won
		jal playerMove
	
	return:
		# pop return address from stack
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
