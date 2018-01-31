	.file	1 "toStringReverse.c"

	.lcomm	number.0,100
	.data
	number.0:

	.text
#	.align	2
	.globl	main
	.ent	main
	jal	main
	li	$2,10
	syscall
main:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, extra= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,24		# Allocate 6 words on stack
	sw	$31,20($sp)		# Save old return address on stack
	sw	$fp,16($sp)		# Save old frame pointer
	move	$fp,$sp			# Create new frame
#	jal	__main
	li	$4,987			# 73 is the first argument for itoa
	la	$5,number.0		# The second parameter is the number string
	jal	itoa			# Call itoa
	move	$2,$0			# Store 0 in register 2
	la	$a0,number.0		# Print converted number
	li	$v0,4
	syscall
	move	$sp,$fp			# Store 24 in stack pointer
	lw	$31,20($sp)		# Restore return address
	lw	$fp,16($sp)		# Restore old frame pointer
	addu	$sp,$sp,24		# Deallocate stack
	jr	$31			# Return
#	.end	main
#	.align	2
	.globl	itoa
	.ent	itoa
itoa:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, extra= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,32		# Allocate 8 words on stack
	sw	$31,28($sp)		# Save return address on stack
	sw	$fp,24($sp)		# Restore old frame pointer
	move	$fp,$sp			# Create new frame pointer

#	void itoa(int n, char s[])	
	sw	$4,32($fp)		# Save 1st parameter into n
	sw	$5,36($fp)		# Save 2nd parameter into s

#	int i = 0
	sw	$0,16($fp)		# Save 0 into n

#	int sign = n
	lw	$2,32($fp)		# Load n into r2
	sw	$2,20($fp)		# Save n into sign

# 	if (sign < 0)
	lw	$2,20($fp)		# Load r2 with sign
	bgez	$2,$L3			# Skip if sign is not greater nor equal to zero
#	n = -n
	lw	$2,32($fp)		# Load n into r2
	subu	$2,$0,$2		# r2 = -r2
	sw	$2,32($fp)		# Store r2 into n
$L3:
	.set	noreorder
	nop
	.set	reorder
$L4:
	lw	$5,16($fp)		
	move	$3,$5			
	lw	$2,36($fp)		
	addu	$6,$3,$2		
	lw	$4,32($fp)		
	li	$2,1717960704			# 0x66660000
	ori	$2,$2,0x6667
	mult	$4,$2
	mfhi	$2
	sra	$3,$2,2
	sra	$2,$4,31
	subu	$3,$3,$2
	move	$2,$3
	sll	$2,$2,2
	addu	$2,$2,$3
	sll	$2,$2,1
	subu	$2,$4,$2
	addu	$2,$2,48
	sb	$2,0($6)
	addu	$5,$5,1
	sw	$5,16($fp)
	lw	$4,32($fp)
	li	$2,1717960704			# 0x66660000
	ori	$2,$2,0x6667
	mult	$4,$2
	mfhi	$2
	sra	$3,$2,2
	sra	$2,$4,31
	subu	$2,$3,$2
	sw	$2,32($fp)
	bgtz	$2,$L4
	lw	$2,20($fp)
	bgez	$2,$L8
	lw	$3,16($fp)
	move	$4,$3
	lw	$2,36($fp)
	addu	$4,$4,$2
	li	$2,45			# 0x2d
	sb	$2,0($4)
	addu	$3,$3,1
	sw	$3,16($fp)
$L8:
	lw	$2,36($fp)
	lw	$3,16($fp)
	addu	$2,$2,$3
	sb	$0,0($2)
	lw	$4,36($fp)
	lw	$5,16($fp)
	jal	reverse_string
	move	$sp,$fp 
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addu	$sp,$sp,32
	jr	$31
	.end	itoa
#	.align	2
	.globl	reverse_string
	.ent	reverse_string
reverse_string:
	.frame	$fp,24,$31		# vars= 16, regs= 1/0, args= 0, extra= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	subu	$sp,$sp,24
	sw	$fp,16($sp)		
	move	$fp,$sp
	sw	$4,24($fp)		# Store 1st parameter str into r4
	sw	$5,28($fp)		# Store 2nd parameter len into r5
	lw	$2,28($fp)		# Load r2 with i
	addu	$2,$2,-1		# k = len - 1
	sw	$2,4($fp)		
	sw	$0,0($fp)		
$L10:
	lw	$3,28($fp)
	sra	$2,$3,31
	srl	$2,$2,31
	addu	$2,$3,$2
	sra	$3,$2,1
	lw	$2,0($fp)
	slt	$2,$2,$3
	bne	$2,$0,$L13
	j	$L11
$L13:
	lw	$3,24($fp)
	lw	$2,4($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,8($fp)
	lw	$3,24($fp)
	lw	$2,4($fp)
	addu	$4,$3,$2
	lw	$3,24($fp)
	lw	$2,0($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,0($4)
	lw	$3,24($fp)
	lw	$2,0($fp)
	addu	$3,$3,$2
	lbu	$2,8($fp)
	sb	$2,0($3)
	lw	$2,4($fp)
	addu	$2,$2,-1
	sw	$2,4($fp)
	lw	$2,0($fp)
	addu	$2,$2,1
	sw	$2,0($fp)
	j	$L10
$L11:
	move	$sp,$fp
	lw	$fp,16($sp)
	addu	$sp,$sp,24
	jr	$31
	.end	reverse_string
