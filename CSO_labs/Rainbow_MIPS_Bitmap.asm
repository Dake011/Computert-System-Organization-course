#(c) by DINMUKHAMED KALDYKHANOV
.data
	DISPLAY: .space 16384
	DISPLAYSIZE: .double 64	
	HEIGHT: .double 32	#display height		#display width
	COLOR: .word 0xff0000, 0xfa8602, 0xfae702, 0x0dfa02, 0x022ffa, 0x530239, 0xf505a9	#7 colors of rainbow
	radius: .double 16		#center 16-1 = 15
	center: .double 32		#middle point
	one: .double 0.5			#we need it)
	four: .double 4
	zero: .double 0
	on: .double 1
.text
j main

set_pixel_color:
# Assume a display of width DISPLAYWIDTH and height DISPLAYHEIGHT
# Pixels are numbered from 0,0 at the top left
# a0: x-coordinate
# a1: y-coordinate
# a2: color
# address of pixel = DISPLAY + (y*DISPLAYWIDTH + x)*4
#			y rows down and x pixels across
# write color (a2) at arrayposition

	l.d $f24, DISPLAYSIZE
	mul.d $f24, $f24, $f22 	# y*DISPLAYWIDTH
	add.d $f24,$f24, $f20	# +x
	l.d $f30, four
	mul.d $f24, $f24, $f30	# *4
	l.d $f26, DISPLAYSIZE	# get address of display: DISPLAY
	add.d $f26, $f26, $f24	# add the calculated address of the pixel
	cvt.w.d $f26,$f14
    	mfc1 $s6,$f26
	
	s.d $f12, ($s6) 		# write color to that pixel
	jr $ra 			# return
	

main:
	li $t4, 1
	li $t5, 8	#7 times iterator
	
	l.d $f20, DISPLAYSIZE	# width
	# height
	
	la $s5, COLOR	#taking values from the list
	li $s7, 0	#index of list
	
	l.d $f8, center		#f8 middle point
	l.d $f0, one		#f0 iterator
	l.d $f10, radius	#radius of our rainbow for each color	
	
change_color:
	sub.d $f10,$f10, $f0	#f10 = 15 (-1) for each loop
	mul.d $f30, $f10, $f10	#taking the square of radius r^2
	l.d $f2, zero		#starting coordinates for x
	l.d $f4, zero		#starting coordinates for y
	
	lw $s6, COLOR($s7)	#taking values from the list
	addi $s7, $s7, 4	#going to the next value in the list
	 
	loop1:			#loop for row
		l.d $f2, zero	#x starts from 0 for each row
		loop2: 		#loop for coloum
			mov.d $f20, $f2	# a0 = x-coordinate	
			mov.d $f22, $f4	# a1 = y-coordinate 		
			
				
  			
			sub.d $f16, $f8, $f2	#taking the x value of circle
			sub.d $f18, $f8, $f4	#taking the y value of circe
			
			mul.d $f16, $f16, $f16	# f20 = x*x
			mul.d $f18, $f18, $f18	# f22 = y*y
			add.d $f18, $f18, $f16 	# f24 = x*x + y*y
			c.le.d $f28, $f30
			bc1t next		# x*x + y*y <= r*r then go to the next 
			j no_color		#there is no color to dispay
			j skip	  		#skip to the next pixel
			next: 
				#a2 is a color of th pixel
			mtc1.d $s6, $f30	
  			cvt.d.w $f30, $f30
			mov.d $f12, $f30
			l.d $f6, on
			sub.d $f6, $f10, $f6	#checking the radius
			mul.d $f6, $f6,$f6
			c.le.d $f6 $f28		#comparing the value of radius square
			bc1t skip		
			j no_color   		#no setting color to the pixel
			skip:	    	
											
			jal set_pixel_color	# color the current pixel
			
		no_color:	
			add.d $f2, $f2, $f0	# increment x
			c.eq.d $f2, $f20 
			bc1f loop2	# loop until s0 = 64
			add.d $f4, $f4, $f0 	# increment y
			c.eq.d $f4, $f8 
			bc1f loop1	# loop until s1 = 32
			
			addi $t4, $t4, 1		#incrementor for rainbow colors
			bne $t4, $t5 change_color	#repeating loop
			
			
