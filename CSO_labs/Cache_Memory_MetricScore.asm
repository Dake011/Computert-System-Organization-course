.data
array: .space 1024

.text
#number of block 1
#cache block size 256
#cache performance metric = 512*(110-100) = 5120
#1)What I wanted: it is more better to load double since we have to go to cache only (1024/8)*2=256 times. 
#we multiply by 2 because we have load and store. In that case metric score supposed to be 256*(110-100)=2560.
#However since load double is two times load word, load double would be similar to load word.
#So, metric score is (1024/8)*2*2 = 512 (unfortunately).
#2)The number of block is 1. Initially our cache is empty. So to go through cache, cache miss has to be 1 for each block. 
#That why I used 1 block. Since we need 1024 bytes we need 1024 (byte) / 4 = 256. So we have 256 block size.

#============body============
li $a1, 1024 	#arrSize
li $a2, 8	#stepSize
la $a3, array
move $s0, $zero
move $t5, $zero

main: 
	move $s2, $zero		
	move $s3, $zero
	addi $t5, $t5, 255		#or t5 is 0x000000ff
	li $s1, 1			
	li $t3, 5
	li $t2, 1
	beq $s0, $a1 endLoop		#8*x = 1024 ,x= x+1 each loop
	add $s5, $s0, $a3		#taking the array
	ld $t0, 0($s5)			#first 8 byte
firstDword:	
	beq $t3, $t2 nextWord		#the first word in doubleword
	and $t6, $t0 $t5		#working with in doubleword
	add $t6, $t6, $s1		#adding 1 to the byte
	and $t6, $t6, $t5		#saving last byte and removing overflow
	sll $t5, $t5, 8			#taking each byte by shifting 8 bite, for 0x000000ff
	sll $s1, $s1, 8			#same but for 1
	addi $t2, $t2 1			#loop incrementor
	add $s2, $s2, $t6		#saving result in s2
	j firstDword
nextWord:
	addi $t5, $t5, 255		#restoring the results for the second word in doubleword
	li $t3, 5
	li $t2, 1
	li $s1, 1
	j secondDword	
secondDword:
	beq $t3, $t2 nextByte 		#same method for the second word in doubleword
	and $t7, $t1 $t5
	add $t7, $t7, $s1
	and $t7, $t7, $t5
	sll $t5, $t5, 8
	sll $s1, $s1, 8
	addi $t2, $t2 1
	add $s3, $s3, $t7
	j secondDword
nextByte:
	sd $s2, 0($s5)			#saving values of s2 and s3 on the array
	add $s0, $s0, $a2		#adding stepSize
	j main
	
endLoop:
	li $v0, 10			#exit call
	syscall
	


