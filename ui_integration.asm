# CS 2640 - Wordle Final Project
# Spencer Davis, Felix Zheng, Aniket Subramanian, Jesston Li 
# Part 1 - UI and Game Flow Integration; Spencer

# INTEGRATION:
# select_word: Selects the secret word.
# get_guess: Gets a valid five-letter guess.
# check_guess: Compares the guess and prints feedback.
# Returns $v0 = 1 if correct, 0 if incorrect.
#
# Temporary procedures are included at the bottom, replace them with teammates' code during integration.

.data
welcome:      .asciiz "\n==============================\n       WORDLE\n==============================\n"
menuText:     .asciiz "\n1. Play Wordle\n2. Instructions\n3. Exit\nChoose an option (1-3): "
instructions: .asciiz "\nGuess the secret five-letter word in six tries.\nAfter each guess, feedback will show correct, misplaced,\nand absent letters. Only valid guesses use an attempt.\n"
invalidMenu:  .asciiz "\nInvalid menu option. Please choose 1, 2, or 3.\n"
startText:    .asciiz "\n--- NEW GAME ---\n"
attemptText:  .asciiz "\nAttempt "
ofSix:        .asciiz " of 6\n"
winText:      .asciiz "\nYou guessed the word! You win!\n"
loseText:     .asciiz "\nNo attempts left. Game over!\n"
replayText:   .asciiz "\nPlay again? (1 = Yes, 2 = No): "
invalidReplay:.asciiz "\nPlease enter 1 or 2.\n"
byeText:      .asciiz "\nThanks for playing!\n"

# Temporary test messages
stubSelect:   .asciiz "[STUB] Secret word selected.\n"
stubGuess:    .asciiz "[STUB] Enter a guess? (1 = simulate correct, 0 = incorrect): "
stubInvalid:  .asciiz "[STUB] Please enter 0 or 1.\n"
stubCorrect:  .asciiz "[STUB] Correct guess!\n"
stubWrong:    .asciiz "[STUB] Incorrect guess.\n"

.text
.globl main

main:
    # display welcome screen
    li $v0, 4
    la $a0, welcome
    syscall

main_menu:
    # display main menu
    li $v0, 4
    la $a0, menuText
    syscall

    # read menu choice
    li $v0, 5
    syscall

    beq $v0, 1, start_game
    beq $v0, 2, show_instructions
    beq $v0, 3, exit

    # invalid menu selection
    li $v0, 4
    la $a0, invalidMenu
    syscall
    j main_menu

show_instructions:
    # display game instructions
    li $v0, 4
    la $a0, instructions
    syscall
    j main_menu

start_game:
    # display new game message
    li $v0, 4
    la $a0, startText
    syscall

    # call word selection procedure
    jal select_word

    # initialize attempt counter
    li $s0, 0

game_loop:
    # check if six attempts have been used
    li $t0, 6
    bge $s0, $t0, game_lost

    # display attempt number
    li $v0, 4
    la $a0, attemptText
    syscall

    li $v0, 1
    addiu $a0, $s0, 1
    syscall

    li $v0, 4
    la $a0, ofSix
    syscall

    # get a valid guess from player
    jal get_guess

    # compare guess with secret word
    jal check_guess

    # save result
    move $s1, $v0

    # increase attempt counter
    addiu $s0, $s0, 1

    # check if player won
    bne $s1, $zero, game_won

    # continue to next attempt
    j game_loop

game_won:
    # display winning message
    li $v0, 4
    la $a0, winText
    syscall
    j replay_prompt

game_lost:
    # display losing message
    li $v0, 4
    la $a0, loseText
    syscall

replay_prompt:
    # ask player to play again
    li $v0, 4
    la $a0, replayText
    syscall

    li $v0, 5
    syscall

    beq $v0, 1, start_game
    beq $v0, 2, main_menu

    # invalid replay selection
    li $v0, 4
    la $a0, invalidReplay
    syscall
    j replay_prompt

exit:
    # exit program
    li $v0, 4
    la $a0, byeText
    syscall

    li $v0, 10
    syscall



# ==========================================
# TEMPORARY TEST PROCEDURES
# replace when combining group code
# ==========================================

select_word:
    # simulate selecting a secret word
    li $v0, 4
    la $a0, stubSelect
    syscall
    jr $ra

get_guess:
stub_guess_loop:
    # simulate player entering a guess
    li $v0, 4
    la $a0, stubGuess
    syscall

    li $v0, 5
    syscall

    beq $v0, 0, stub_guess_valid
    beq $v0, 1, stub_guess_valid

    # invalid test input
    li $v0, 4
    la $a0, stubInvalid
    syscall
    j stub_guess_loop

stub_guess_valid:
    # store simulated guess result
    move $s2, $v0
    jr $ra

check_guess:
    # check simulated guess
    beq $s2, $zero, stub_wrong

    # simulated correct guess
    li $v0, 4
    la $a0, stubCorrect
    syscall

    li $v0, 1
    jr $ra

stub_wrong:
    # simulated incorrect guess
    li $v0, 4
    la $a0, stubWrong
    syscall

    li $v0, 0
    jr $ra
