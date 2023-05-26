.globl validateMove

.data
	invalidChar_str: .asciiz "Letter out of range\n"
	invalidNum_str: .asciiz "Number out of range\n"
	notOpen_str: 	.asciiz "Space is already occupied\n"

	usermove:	.asciiz "\nMOVE: "
	string:		.space 20

.text
# $t0 = chars in input str
# $t1 = stored copy of input str addr
# $t2 = isValid input
validateMove:
	# Store input str
	move $t1, $a0
	# Assume valid until proven false
	li $t2, 1
	
	lb $t0, 0($t1) # char 1
	blt $t0, 'A', invalidChar
	bgt $t0, 'O', invalidChar
	j checkDigit
	
	invalidChar:
		li $v0, 4
		la $a0, invalidChar_str
		syscall
		li $t2, 0 # invalid input overall
		# Falls through to checkDigit automatically
	
	checkDigit:
		lb $t0, 1($t1)
		beq $t0, '1', firstDigit1 # do following section if first digit isn't 1
		blt $t0, '2', invalidNum
		bgt $t0, '9', invalidNum	
		# extra validation here if user puts for ex. C72 -> invalid 
		lb $t0, 2($t1)
		bne $t0, '\0', invalidNum
		j validNum
		
	firstDigit1:
		lb $t0, 2($t1)
		beq $t0, '\0', validNum
		blt $t0, '0', invalidNum
		bgt $t0, '5', invalidNum
		j validNum
		
	invalidNum:
		li $v0, 4
		la $a0, invalidNum_str
		syscall
		li $t2, 0

	validNum:
		beq $t2, 1, validInput
		# Invalid input if reaches here -> return 0
		li $v0, 0
		jr $ra
	
	validInput:
		addi $sp, $sp, -4
		sw $ra, ($sp)
		jal openSquare
		lw $ra, ($sp)
		addi $sp, $sp, 4

		beq $v0, 0, notOpen
		
		# Fully valid input if reaches here
		li $v0, 1
		jr $ra
		
	notOpen:
		li $v0, 4
		la $a0, notOpen_str
		syscall
		li $v0, 0	
		jr $ra
