# defines
.eqv PRINT_STR, 4

.data
invalidStr: .asciiz "Invalid format: should be <A-O><1-15>\n"

.globl validateGeneral
.text

## Usage ##
# Input:
#	$a0 : pointer to null terminated string
# Output:
#	$v0 : 0=invalid 1=valid
# temps are not preserved!
###########

validateGeneral:
	# set up stack
	addi $sp, $sp,-4
	sw $ra, ($sp)
	
	# Load characters from string stored at address in $a0
	lb $t0, ($a0)
	lb $t1, 1($a0)
	lb $t2, 2($a0)
	lb $t3, 3($a0)
	
	# first char is alphabetical
	blt $t0, 'A', invalidFormat_validateGeneral
	bgt $t0, 'Z', invalidFormat_validateGeneral
	
	# second char is numerical
	blt $t1, '0', invalidFormat_validateGeneral
	bgt $t1, '9', invalidFormat_validateGeneral
	
	# third char is null or numerical
	bne $t2, '\0', notlen2_validateGeneral
		jal validateMove
		j return_validateGeneral
	
	# if third isn't null: third is numerical and fourth is null
	notlen2_validateGeneral:
		bne $t3, '\0', invalidFormat_validateGeneral
		jal validateMove
		j return_validateGeneral
	
	## display invalid input format
	invalidFormat_validateGeneral:
		li $v0, PRINT_STR
		la $a0, invalidStr
		syscall
		li $v0, 0
		j return_validateGeneral
	
	## restore registers and return
	return_validateGeneral:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
