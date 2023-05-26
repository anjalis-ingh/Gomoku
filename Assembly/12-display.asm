# No arguments
# Called after every valid move to show updated board
# Board array is assumed to be fully filled in by {'X', 'O', '.'}

# define substitutions
.eqv	PRINT_CHAR, 11 	# $v0 code 11 = print character
.eqv 	PRINT_INT, 1 	# $v0 code 1 = print string

# global procedures
.globl 	display

.text

	# display board array to terminal
	display:
		li $t0, 'A' 		# set $t0 = 'A' (horizonal label index)
		# prints 2 spaces between horizontal labels
		li $a0, ' ' 		# set $a0 = ' ' (blank space)
		li $v0, PRINT_CHAR	
		syscall
		syscall
		
		# print all column labels (A-O)
		# $t0 = column label index
		horizontalLabels:
			beq $t0, 'P', endloop1_display	# if($t0 == 'P') then {endloop1_display()}
			
			# print blank space
			li $a0, ' ' 					# set $a0 = ' ' (blank space)
			syscall							# $v0 still set to PRINT_CHAR

			# print column label
			move $a0, $t0 					# set $a0 = $t0
			syscall							# $v0 still set to PRINT_CHAR

			addiu $t0, $t0, 1 				# increment horizontal label index
			j horizontalLabels				# loop

		# print new line
		endloop1_display:
			li $a0, '\n' 					# set $a0 = '\n
			syscall							# $v0 still set to PRINT_CHAR
		
		# print row numbers (1-9)
		li $t0, 0 							# set $t0 = 0 (Vertical offset)
		rowLabelsP1:
			beq $t0, 9, rowLabelsP2 		# if($t0 == 9) then {rowLabelsP2()}
			li $a0, ' '						# displayed number is $t0 + 1 so breaks when would display 10
			syscall							# $v0 still set to PRINT_CHAR
		 	
			addi $a0, $t0, 1 				# vertical label = vertical offset + 1
			li $v0, PRINT_INT
			syscall

			li $t1, 0 						# $t1 = 0 (horizontal offset)
			li $t2, 15 						# $t2 = 15 (board size)
			li $v0, PRINT_CHAR

			# print row of board array
			boardPrintP1:
				beq $t1, 15, endloop3_display	# if($t0 == 15) then {endloop3_display()}
				li $a0, ' '						# set $a0 = ' ' (blank space)
				syscall							# $v0 still set to PRINT_CHAR

				mult $t0, $t2					# 
				mflo $t3 						# 
				addu $t3, $t3, $t1				# 
				lb $a0, board($t3) 				# 
				syscall 						# $v0 still set to PRINT_CHAR

				addiu $t1, $t1, 1 				#
				j boardPrintP1 					#

			endloop3_display:
				li $a0, '\n' 					# 
				syscall

			addiu $t0, $t0, 1 					# 
			j rowLabelsP1 						# 
		
		# print row number 10-15 (i.e. 2-digit)
		rowLabelsP2:
			beq $t0, 15, return 				# 
			li $v0, PRINT_INT
			addi $a0, $t0, 1 					# vertical offset + 1
			syscall

			li $v0, PRINT_CHAR
			li $t1, 0 							# horizontal offset
			li $t2, 15 							# board size

			# print row of board array
			boardPrintP2:
				beq $t1, 15, endloop5_display	# 
				li $a0, ' '						# 
				syscall							# 

				mult $t0, $t2					# 
				mflo $t3						# 
				addu $t3, $t3, $t1				# 
				lb $a0, board($t3)				# 
				syscall

				addiu $t1, $t1, 1 				# 
				j boardPrintP2 					# loop

			endloop5_display:
				li $a0, '\n'
				syscall

			addiu $t0, $t0, 1 					# 
			j rowLabelsP2

		return:
			addi $sp, $sp, -4
			sw $ra, ($sp)
			jal showMoves
			lw $ra, ($sp)
			addi $sp, $sp, 4
			
			jr $ra