.data 
x: .double 2.1
one: .double 1.0
.text
main:
	l.d $f6, x
	l.d $f28, one
	addi $t0, $zero, 1
	
	cvt.w.d $f8,$f6
    	mfc1 $a0,$f8
    	mov.d $f12, $f6
    	mov.d $f4, $f6
    	mtc1.d $a0, $f18
  	cvt.d.w $f18, $f18	#f18 = $a0
    	sub.d $f20, $f6, $f18	#f20 = check for zero
    	mtc1.d $zero, $f22
  	cvt.d.w $f22, $f22	#f22 = $zero
 	
 	c.le.d $f22, $f6	#checks for zero factorial
	bc1t zero
	
	jal mfact
	li $v0, 3
	syscall
	li $v0, 10
	syscall
	
zero:
	add.d $f12, $f22, $f28	#0! = 1
	li $v0, 3
	syscall
	li $v0, 10
	syscall

mfact:
	andi $sp, 0xfffffff8
	addi $sp, $sp, -12
	s.d $f4, 4($sp)		#value of double (8)
	sw $ra, 0($sp)  	#4 	
	c.eq.d $f22, $f20
	bc1f next		
	bne $a0, $t0, else	#if $f20 == 0
	j retfact

next:
    	bne $a0, $zero else  	#if $f20 != 0
    	j retfact
    	
else:
	addi $a0, $a0, -1
    	sub.d $f4, $f4, $f28	#decrements each time $f4
    	mul.d  $f12, $f12, $f4	#fact(x-1)*x
    	j mfact
    	

    		
retfact:
	lw $ra, 0($sp)		
	l.d $f4, 4($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
