	.file	1 "addNumbers.c"
	.data
	.align	2
x.0:
	.word	1
	.word	5
	.word	6
	.word	9
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$sp,24,$31		# vars= 0, regs= 2/0, args= 16, extra= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	subu	$sp,$sp,24
	sw	$31,20($sp)	# Store 20 into r31
	.set	noreorder
	.set	nomacro
	jal	__main		# Jump to main
	sw	$16,16($sp)	# Store 16 into r16
	.set	macro
	.set	reorder

	move	$3,$0
	la	$4,x.0
	sll	$2,$3,2		# Add 4 to address
$L9:
	addu	$2,$2,$4	# Add contents of r4 and r2 and store it in r2
	lw	$2,0($2)	# Load r2 with 0
	#nop
	addu	$16,$16,$2	# Add contents of r16 and r2 and store it in r16
	addu	$3,$3,1		# Increment loop variable
	slt	$2,$3,4		# Loop condition
	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L9	# Jump to end if not equal
	sll	$2,$3,2		# Add 4 to address
	.set	macro
	.set	reorder

	move	$2,$16
	lw	$31,20($sp)	# Load 20 into r31
	lw	$16,16($sp)	# Load 16 into r16
	#nop
	.set	noreorder
	.set	nomacro
	j	$31
	addu	$sp,$sp,24
	.set	macro
	.set	reorder

	.end	main
