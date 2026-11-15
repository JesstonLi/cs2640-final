# CS 2640 - Wordle Final Project
# Spencer Davis, Felix Zheng, Aniket Subramanian, Jesston Li 
# Part 2: Dictionary & Word Selection; Felix

#TO-DO: make program compatible with other code snippets (such as macro names)
#TO-DO: increase dictionary array size
#TO-DO: combine this code snippet with the others into one .asm file

.data
# Dictionary of possible secret words
word1: .asciiz "spawn"
word2: .asciiz "apple"
word3: .asciiz "table"
word4: .asciiz "house"
word5: .asciiz "chair"

# Align word_list for word-addressed instructions
.align 2
# Array containing the addresses of the words
word_list: .word word1, word2, word3, word4, word5

.text
select_word:
    # Generate a random number from 0 through 4
    # TO-DO: CHANGE NUMBER RANGE DEPENDING ON HOW MANY WORDS ARE IN word_list
    li $v0, 42
    li $a0, 0
    li $a1, 5
    syscall

    # Convert the word number into a byte offset
    sll $t0, $a0, 2

    # Find the selected word's address in word_list
    la $t1, word_list
    add $t1, $t1, $t0

    # Store the selected word's address in $s3
    lw $s3, 0($t1)

    # Return to start_game
    jr $ra