	.file	1 "addNumbers.c"
	.data
	.align	2
x.0:
	.word	1
	.word	5
	.word	6
	.word	9
	.text
#	.align	2
	jal	main	# Call main
	li $v0, 10	# Halt
	syscall

	.globl	main
	.ent	main
main:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, extra= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
#	jal	__main
	sw	$0,16($fp)	# Store 0 into i
$L2:
	lw	$2,16($fp)	# Load i into r2
	slti	$2,$2,4		# Compute boolean i < 4 into r2
	bne	$2,$0,$L5	# Jump to L5 if boolean true
	j 	$L3		# Jump out of loop
$L5:
	lw	$2,16($fp)	# Get i into r2
	sll	$3,$2,2		# r3 = 4 * i	
	la	$2,x.0		# Get address of x into r2
	addu	$2,$3,$2	# r2 has address of element
	lw	$3,20($fp)	# Load sum into r3
	lw	$2,0($2)	# Load element into r2
	addu	$2,$3,$2	# Add element to sum
	sw	$2,20($fp)	# Store in sum
	lw	$2,16($fp)	# Get i into r2
	addu	$2,$2,1		# Increment i
	sw	$2,16($fp)	# Store in i
	j	$L2		# Do next iteration
$L3:
	lw	$2,20($fp)	# Load sum into r2
	move	$sp,$fp
	lw	$31,28($sp)		
	lw	$fp,24($sp)
	addu	$sp,$sp,32	# Delete frame
	jr	$31
	.end	main
