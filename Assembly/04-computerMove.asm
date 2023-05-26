# args()
# set computer char opposite to player
# select random coordinates
# call openSquare()
# place(random row, random col, computer char)

# global procedures
.globl computerMove
.data
	com:	.asciiz "COMPUTER MOVE: "

.text
computerMove:
	
	lb $t0, emptyChar	# t0 = character representing empty space
	randomGeneration:
		# random number (0-224)
		addi $v0, $zero, 42 		# code 42 for random int range
		#li $a0, 12			# not significant, Java in background just uses a Random object with this as an ID
		addi $a1, $zero, 225 		# exclusive upper bound of range
		syscall				# result in $a0

		# checkOpenSquare method uses $t4 register to store index
		lb $t1, board($a0)
		bne $t1, $t0, randomGeneration # try new again because rand_indx is not open (i.e. rand_idx_char != emptyChar)
	
	lb $a1, computerChar	# arg1 = computerChar
	addi $sp, $sp, -4	# set stack
	sw $ra, ($sp)		# set return address
	jal place		# a0 used as index to place, maintained from random generation above
	lw $ra, ($sp)		# reset return address
	addi $sp, $sp, 4	# reset stack

	jr $ra
