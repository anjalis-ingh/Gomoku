.text
.globl checkWin

# a0 = index of most recent move
checkWin:
	lb $t1, board($a0) # t1 is char placed

	checkHorizontal:
		move $t0, $a0 # t0 is curr index
		div $t2, $a0, 15
		mul $t2, $t2, 15 # t2 holds left most bound of board on given row
		addi $t2, $t2, -1 # t2 is 1 under the bound (makes loop checking easier)
		low_horizontal: # while(curr_char == char_placed && curr_char_idx >= board_left_side) -> horizontal_counter-=1
			beq $t0, $t2, low_horizontal_end
			lb $t3, board($t0) # t3 holds char at current position
			bne $t3, $t1, low_horizontal_end # if(curr_char != char_placed) -> break
			addi $t0, $t0, -1 # curr_char_idx -= 1
			j low_horizontal
		low_horizontal_end:
		addi $t0, $t0, 1	# t0 is one too far
		
		addi $t2, $t2, 16 # t2 is right board bound + 1
		move $t3, $zero # t3 is counter for length of horizontal line made
		horizontal_length: # while (curr_char == char_placed && curr_char_idx <= board_right_side) -> horizontal_counter += 1
			beq $t0, $t2, horizontal_length_end # break if run off right side
			lb $t4, board($t0) # t4 holds char at curr_char_idx
			bne $t4, $t1, horizontal_length_end # break if no longer on char_placed type
			addi $t3, $t3, 1 # counter increment
			addi $t0, $t0, 1 # char_idx increment
			j horizontal_length
		horizontal_length_end:
		beq $t3, 5, won
	
	checkVertical:
		move $t0, $a0 # t0 is curr index
		li $t2, 15 # size of board
		div $a0, $t2
		mflo $t2	# t2 holds upper most bound of board on given column
		addi $t2, $t2, -15 # t2 is 1 increment under the bound (makes loop checking easier)
		low_vertical: # while(curr_char == char_placed && curr_char_idx >= board_top_side) -> vertical_counter-=1
			beq $t0, $t2, low_vertical_end
			lb $t3, board($t0) # t3 holds char at current position
			bne $t3, $t1, low_vertical_end # if(curr_char != char_placed) -> break
			addi $t0, $t0, -15 # curr_char_idx -= 15 (up one spot)
			j low_vertical
		low_vertical_end:
		addi $t0, $t0, 15	# t0 is one increment too far
		
		addi $t2, $t2, 240 # t2 is bottom board bound + 15 (240 = (15+1)*15)
		move $t3, $zero # t3 is counter for length of vertical line made
		vertical_length: # while (curr_char == char_placed && curr_char_idx <= board_right_side) -> horizontal_counter += 1
			beq $t0, $t2, vertical_length_end # break if run off right side
			lb $t4, board($t0) # t4 holds char at curr_char_idx
			bne $t4, $t1, vertical_length_end # break if no longer on char_placed type
			addi $t3, $t3, 1 # counter increment
			addi $t0, $t0, 15 # char_idx increment
			j vertical_length
		vertical_length_end:
		beq $t3, 5, won
	
	checkDiagonalUpLeft:
		move $t0, $a0 # t0 is curr index
		
		li $t2, 15 # size of board
		div $a0, $t2
		mflo $t2	# t2 holds column number
		div $t3, $a0, 15	# t3 holds row number
		# if row number is greater than column number go to rowGreater
		# otherwise fall through to colGreater
		
		# t5 will hold lower right bound
		# t2 will hold upper left bound
		blt $t2, $t3, rowGreater	
		colGreater:
			sub $t5, $t3, $t2
			addi $t5, $t5, 14
			mul $t5, $t5, 15
			addi $t5, $t5, 14
			
			sub $t2, $t2, $t3
			j endBoundFinding
		rowGreater:
			add $t5, $t2, $t3
			addi $t5, $t5, 210	# 210 = 14*15
			
			sub $t2, $t3, $t2
			mul $t2, $t2, 15
			
			
		endBoundFinding:
		addi $t2, $t2, -16 # t2 is upper left diagonal bound + 1 increment
		addi $t5, $t5, 16	#t5 is lower right diagonal + 1 increment
		low_diagonalUpLeft: # while(curr_char == char_placed && curr_char_idx >= board_top_side && curr_char_idx >= board_left_side) -> diagonal_counter-=1
			beq $t0, $t2, low_diagonalUpLeft_end
			lb $t3, board($t0) # t3 holds char at current position
			bne $t3, $t1, low_diagonalUpLeft_end # if(curr_char != char_placed) -> break
			addi $t0, $t0, -16 # curr_char_idx -= 16 (up 1 spot and left 1 spot i.e. up-left diagonal)
			j low_diagonalUpLeft
		low_diagonalUpLeft_end:
		addi $t0, $t0, 16	# t0 is one increment too far
		
		move $t2, $t5	# t2 is now lower right bound + 1 increment
		move $t3, $zero # t3 is counter for length of vertical line made
		diagonalUpLeft_length: # while (curr_char == char_placed && curr_char_idx <= board_right_side) -> horizontal_counter += 1
			beq $t0, $t2, diagonalUpLeft_length_end # break if run off right side
			lb $t4, board($t0) # t4 holds char at curr_char_idx
			bne $t4, $t1, diagonalUpLeft_length_end # break if no longer on char_placed type
			addi $t3, $t3, 1 # counter increment
			addi $t0, $t0, 16 # char_idx increment
			j diagonalUpLeft_length
		diagonalUpLeft_length_end:
		beq $t3, 5, won
	
	checkDiagonalUpRight:
		move $t0, $a0 # t0 is curr index
		
		li $t2, 15 # size of board
		div $a0, $t2
		mflo $t2	# t2 holds column number
		li $t3, 14
		sub $t4, $t3, $t2	# t4 holds column number starting from right
		div $t3, $a0, 15	# t3 holds row number
		# if row number is greater than column number go to rowGreater
		# otherwise fall through to colGreater
		
		# t5 will hold lower right bound
		# t2 will hold upper left bound
		
		bgt $t3, $t4, rowGreater_upRight
		colGreater_upRight:
			add $t5, $t2, $t3
			mul $t5, $t5, 15
				
			add $t2, $t2, $t3
			j endBoundFinding_upRight
		rowGreater_upRight:
			sub $t5, $t2, $t3
			addi $t5, $t5, 210 # 210 = 14*15
			
			add $t2, $t3, $t4
			mul $t2, $t2, 15
			addi $t2, $t2, 14
			
			
		endBoundFinding_upRight:
		addi $t2, $t2, -14 # t2 is upper left diagonal bound + 1 increment
		addi $t5, $t5, 14	#t5 is lower right diagonal + 1 increment
		low_diagonalUpRight: # while(curr_char == char_placed && curr_char_idx >= board_top_side && curr_char_idx >= board_left_side) -> diagonal_counter-=1
			beq $t0, $t2, low_diagonalUpRight_end
			lb $t3, board($t0) # t3 holds char at current position
			bne $t3, $t1, low_diagonalUpRight_end # if(curr_char != char_placed) -> break
			addi $t0, $t0, -14 # curr_char_idx -= 16 (up 1 spot and left 1 spot i.e. up-left diagonal)
			j low_diagonalUpRight
		low_diagonalUpRight_end:
		addi $t0, $t0, 14	# t0 is one increment too far
		
		move $t2, $t5	# t2 is now lower right bound + 1 increment
		move $t3, $zero # t3 is counter for length of vertical line made
		diagonalUpRight_length: # while (curr_char == char_placed && curr_char_idx <= board_right_side) -> horizontal_counter += 1
			beq $t0, $t2, diagonalUpRight_length_end # break if run off right side
			lb $t4, board($t0) # t4 holds char at curr_char_idx
			bne $t4, $t1, diagonalUpRight_length_end # break if no longer on char_placed type
			addi $t3, $t3, 1 # counter increment
			addi $t0, $t0, 14 # char_idx increment
			j diagonalUpRight_length
		diagonalUpRight_length_end:
		beq $t3, 5, won
		
	j return # No winner if this is reached
	
won:
	sb $t1, gameWon($zero) # set gameWon byte to winning char

return:
	jr $ra