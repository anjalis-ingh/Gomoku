# a0 = str to parse
# v0 = index
# assumed valid input

.text
.globl strToBoardIndex
strToBoardIndex:
	
	lb $t0, ($a0)		# t0 = letter from str
	subi $t4, $t0, 'A'	# t4 = letter offset
	
	lb $t1, 2($a0)
	bne $t1, '\0', twoDigit
	
	# t5 = number offset
	oneDigit:
		lb $t1, 1($a0)	# t1 = (1-digit) number in str
		subi $t5, $t1, '0'
		j return
	twoDigit:
		subi $t5, $t1, '0'	# t1 = ones digit
		addi $t5, $t5, 10	# 10s digit is always 1 for valid input
		j return
	
	return:
		addi $t5, $t5, -1	# compensate for 0 indexing
		mul $v0, $t5, 15
		add $v0, $v0, $t4	# v0 contains index
		jr $ra