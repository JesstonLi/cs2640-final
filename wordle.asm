.data
prompt: .asciiz "Enter a five letter word: \n"
error: .asciiz "Invalid. Must be exactly five letters. \n"
newline: .asciiz "\n"
answer: .asciiz "spawn"
result: .asciiz "....."
guess: .space 8 #So basically, this is essentially just giving a space of 8 bytes. Reason why is that mips gives inputs like: 112 97 115 116 100 10 0. The 10 is the enter key and 0 is just at the end. I had 8 to test for 6 letters, but this allows for checking how many bytes the unser inputs




.text
main:
read_guess: 
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8
	la $a0, guess
	li $a1, 8
	syscall
	
	#Count letters in a guess
	la $t0, guess
	li $t1, 0
	
count_guess:
	lb $t2, 0($t0)
	beq $t2, 10, check_guess #WHen we type enter, finish counting
	bgt $t1, 5, invalid #Longer than 5 letters
	addi $t0, $t0, 1 #moves to next byte
	addi $t1, $t1, 1 #Increases length by 1
	j count_guess
	
check_guess:
	li $t3, 5 #t3 is five, the supposed length of the input
	bne $t1, $t3, invalid #If the length (t1) is not equal to t3, jump to invalid
	j valid
	
invalid:
	li $v0, 4
	la $a0, error
	syscall
	j read_guess
	
valid:
	la $s0, guess #guess in s0
	la $s1, answer #answer in s1
	la $s2, result
	li $t0, 0
exact_loop:
	beq $t0, 5, print_result # branch after looping 5 letters
	add $t1, $s0, $t0 #address of guess[i]
	lb $t2, 0($t1) #loads byte of guess[i] to $t2
	add $t1, $s1, $t0 # address of answer[i]
	lb $t3, 0($t1) #loads byte of guess[i] to $t3
	bne $t2, $t3, exact_next #Different number, input a .
	li $t4, '|'
	add $t1, $s2, $t0
	sb $t4, 0($t1)
exact_next:
	addi $t0, $t0, 1 #moves to next byte
	j exact_loop
print_result: 
	li $v0, 4
	la $a0, result
	syscall
	j exit
#jesston so i kind off forgor that u havd to do the direct comparisons for the letters, i kind of made it as a bseline. Read up on lb (load bytes) and yea go from there.
#Heres a summary tho:
# So far, . is incorrect and | is exact. We need some indicator of it being a correct byte in the wrong place
# lb $t2, 0($t1)  = load byte: copy the one byte whose address is in $t1 into $t2
# address of letter i = start of word + i  (add $t1, $s0, $t0)
# sb = store byte, the reverse: write a register's byte into memory

exit:
	li $v0, 10
	syscall