## -------------------------------------------------------------------------- ##
## --------------------------------( Runner )-------------------------------- ##
## -------------------------------( Launcher )------------------------------- ##
## -------------------------------------------------------------------------- ##

## editor tab space = 4

# global data
.globl 	board, playerChar, computerChar, emptyChar, gameWon
# global procedures
.globl 	main

.data
	# declare variables
	board: 		.space 	225	# reserve 15 x 15 bytes for board size
	playerChar:	.space	1 	# declare single byte for Player Character
	computerChar:	.space	1	# declare single byte for Computer Character
	emptyChar:	.byte	'.'	# declare filler character for empty board spaces
	gameWon:	.space 	1 	# declare single byte for gameWon boolean flag
	
	ask:		.asciiz	"\nPlay again? (Y/N): "
	thank:		.asciiz	"\nThanks for playing!\n"
	
	you:	.asciiz "\nYOU ("
	comp:	.asciiz "\nCOMPUTER ("
	win:	.asciiz ") WON!\n"

.text

# runner method
main:
		jal startGame				# calling startGame() method
		
		# starts game loop
		gameLoop:
			jal gameRound			# calling gameRound() method
			lb $t0, gameWon			# set $t0 = gameWon boolean flag
			beq $t0, $zero, gameLoop 	# if (NOT gameWon) then {loop} else {display messages}
			
			jal display	# display winning board

			
			
			###	Play MIDI sound and give message on who won	###
			# Set initial shared arguments for both computer/player sounds
			li $v0, 33 	# MIDI out (synchronous, act as interrupt)
			li $a0, 60 	# Tone for Middle C
			li $a1, 400	# Milliseconds (0.4 second length)

			lb $t0, gameWon		# winning char stored in global gameWon from checkWin()
			lb $t1, playerChar
			bne $t0, $t1, computerWon
		playerWon: # plays 3 octaves going up
			li $a2, 97 	# Wave up synth sound
			li $a3, 70 	# Velocity / Volume (0 to 127)
			syscall
			li $a0, 72 	# C + one octave
			syscall
			
			# MIDI out with no interrupt, plays three notes at once
			li $v0, 31
			li $a1, 800 	# 800 milliseconds, final note is longer
			li $a0, 60	# Tone for octaves
			syscall
			li $a0, 72
			syscall
			li $a0, 84
			syscall
	
			li $v0, 4
			la $a0, you
			syscall 	# print "YOU ("
			j finishPrint
		computerWon:
			li $a2, 80 	# instrument type
			li $a3, 127 	# Velocity / Volume (0 to 127)
			syscall 	# player middle C with overdrive brass
			li $a0, 48 	# Tone down one octave
			syscall
			
			li $v0, 31 	# play sounds at once
			li $a1, 800 	# 800 milliseconds
			li $a0, 36 	# C - two octave
			syscall
			li $a0, 24 	# C - three octave
			syscall
	
			li $v0, 4
			la $a0, comp
			syscall 	# print "COMPUTER ("

		finishPrint:
			li $v0, 11
			add $a0, $zero, $t0
			syscall # print char that got 5-in-row
			li $v0, 4
			la $a0, win
			syscall # print ") WON!"
			
			###	End of print	###
						
			# Ask user to play again
			askGameRepeat:
				li $v0, 4
				la $a0, ask
				syscall
				li $v0, 12
				syscall # get input char, Y or N for Play Again	
			
				beq $v0, 'N', terminate
				beq $v0, 'n', terminate
				beq $v0, 'Y', main
				beq $v0, 'y', main
				j askGameRepeat

terminate:
	# thanks for playing
	la $a0, thank
	li $v0, 4
	syscall
	
	# terminate
	li $v0, 10
	syscall
