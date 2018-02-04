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
	sw	$0,16($fp)		# Save 0 into i

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
	# s[i++] = n % 10 + '0';
	lw	$5,16($fp)			# Load r5 with i
	move	$3,$5				# Move i into r3
	lw	$2,36($fp)			# Load r2 with s
	addu	$6,$3,$2			# Compute i + s and store in r6
	lw	$4,32($fp)			# Load r4 with n
	li	$2,1717960704			# Load r2 with 0x66660000
	ori	$2,$2,0x6667			# Compute or of 0x66660000 and 0x00006667 to get 0x66666667 and store in r2
	mult	$4,$2				# Compute 0x66666667 * n
	mfhi	$2				
	sra	$3,$2,2
	sra	$2,$4,31
	subu	$3,$3,$2			# Compute n - s and store in r3
	move	$2,$3				# Move n into r2
	sll	$2,$2,2
	addu	$2,$2,$3			# Compute n + s and store in r2
	sll	$2,$2,1
	subu	$2,$4,$2			# Compute n - s and store in r2
	addu	$2,$2,48			# Add 48 to s and store in r2
	sb	$2,0($6)			
	addu	$5,$5,1				# Add 1 to n and store in r5
	sw	$5,16($fp)			# Store r5 into n
	lw	$4,32($fp)			# Load r4 with n
	li	$2,1717960704			# 0x66660000
	ori	$2,$2,0x6667
	mult	$4,$2				# Compute n * s
	mfhi	$2	
	sra	$3,$2,2		
	sra	$2,$4,31
	subu	$2,$3,$2			# Compute (n - s) - s and store in r2
	sw	$2,32($fp)			# Store n into r2
	bgtz	$2,$L4
	lw	$2,20($fp)			# Load r2 with sign
	bgez	$2,$L8				# Branch if sign is greater than 0
	lw	$3,16($fp)			# Load r3 with n
	move	$4,$3				# Move (n - s) into r4
	lw	$2,36($fp)			# Load r2 with s
	addu	$4,$4,$2			# Compute (n - s) + s and store in r2
	li	$2,45			# 0x2d
	sb	$2,0($4)			# Store r2 into (n - s)
	addu	$3,$3,1				# Add 1 to r3 and store in r3
	sw	$3,16($fp)			# Store r3 into n
$L8:
	lw	$2,36($fp)		# Load r2 with  n % 10
	lw	$3,16($fp)		# Load r3 with n
	addu	$2,$2,$3		# Add '0' to n % 10
	sb	$0,0($2)
	lw	$4,36($fp)		# Load lst parameter n into r4
	lw	$5,16($fp)		# Load r5 with n
	jal	reverse_string		# Call reverse string
	move	$sp,$fp 		# Restore stack
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addu	$sp,$sp,32		# Add 32 to stack pointer
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
	# char* reverse_string(char *str, int len)
	sw	$4,24($fp)		# Store 1st parameter in str
	sw	$5,28($fp)		# Store 2nd parameter in len
	# int k = len - 1;
	lw	$2,28($fp)		# Load r2 with len
	addu	$2,$2,-1		# Compute len - 1
	sw	$2,4($fp)		# Store result in k
	# i = 0 
	sw	$0,0($fp)		# Store 0 in i
$L10:
	# i < len/2
	lw	$3,28($fp)		# Load r3 with len
	sra	$2,$3,31		# Set r2 to -1 if len is negative otherwise 0. Compute len / 2
	srl	$2,$2,31		# Set r2 to 1 if len was negative otherwise 0
	addu	$2,$3,$2		# Add len to r2
	sra	$3,$2,1			# Set r3 to r2 divided by 2
	lw	$2,0($fp)		# Load r2 with i
	slt	$2,$2,$3		# Compute i < len / 2 and store in r2
	bne	$2,$0,$L13		# Branch if result is not equal to zero
	j	$L11
$L13:
	# char temp = str[k]
	lw	$3,24($fp)		# Load r3 with str
	lw	$2,4($fp)		# Load r2 with k
	addu	$2,$3,$2		# Compute str + k and store in r2
	lbu	$2,0($2)		# Load r2 with str[k]
	sb	$2,8($fp)		# Store r2 in temp
	# str[k] = str[i]
	lw	$3,24($fp)		# Load r3 with str
	lw	$2,4($fp)		# Load r2 with k
	addu	$4,$3,$2		# Compute str + k and store in r4
	lw	$3,24($fp)		# Load r3 with str
	lw	$2,0($fp)		# Load r2 with i
	addu	$2,$3,$2		# Compute str + i and store in r2
	lbu	$2,0($2)		# Load r2 with str[i]
	sb	$2,0($4)		# Store r2 in str[k]
	# str[i] = temp;
	lw	$3,24($fp)		# Load r3 with str
	lw	$2,0($fp)		# Load r2 with i
	addu	$3,$3,$2		# Compute str + i and store in r3
	lbu	$2,8($fp)		# Load r2 with temp
	sb	$2,0($3)		# Store r2 in str[i]
	# k--;
	lw	$2,4($fp)		# Load r2 with k
	addu	$2,$2,-1		# Compute k - 1
	sw	$2,4($fp)		# Store result in k
	# i++
	lw	$2,0($fp)		# Load r2 with i
	addu	$2,$2,1			# Increment r2
	sw	$2,0($fp)		# Store r2 in i
	j	$L10			# Loop back
$L11:
	move	$sp,$fp			# Restore stack
	lw	$fp,16($sp)		# Restore frame pointer
	addu	$sp,$sp,24		# Remove 6 words on stack	
	jr	$31			# Halt
	.end	reverse_string		# End method
