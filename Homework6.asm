#Homework 6 - Mean, Median, SD - Melecia Young	
		.data
buffer:		.space	80		#create a buffer to read in the text
fileName:	.asciiz	"input.txt"	#will be stored in $a0 
		.align	2
array:		.space	80
len:		.word	20
		.align	2
before:		.asciiz	"The array before:  "
afterPrompt:	.asciiz	"\nThe array after:   "

mean:		.float	0.0
median:		.float	0.0
sDev:		.float	0.0
by2:		.float	2.0

meanPrompt:	.asciiz	"\nThe mean is: "
medianPrompt:	.asciiz	"\nThe median is: "
sdPrompt:	.asciiz	"\nThe standard deviation is: "

errorMsg:	.asciiz	"Error--file cannot be read!"


	.text
main:
	la	$t6, array
	
	#calls the function responsible for reading in the file
	la	$a0, fileName
	la	$a1, buffer
	jal	read
	move	$t0, $v0
	
	#calls the loop that takes all of the integers and puts them in the array 
	jal	loop
	move	$t5, $v0
	
	#call the for loop that prints it 
	jal	for
	
	#this is going to start the methods that control the selection sort 
	jal	selectionSort
	
	#print the sorted array 
	jal	printer
	
	#this is going to calculate the mean
	jal	mean1
	
	#this is going to calculate the median 
	jal	median1
	
	#this is going to calculate the standard deviation 
	jal	sd1
	
	#going to print the prompts and values 
	jal	printEnd
	
	
	j exit
	
###################################### 	READ THROUGH THE FILE	########################################
	#a0 takes fileName, a1 takes buffer, $v0 returns file descriptor, $v1 returns number of bytes
read:
	move	$t1, $a0
	move	$t2, $a1
	
	li	$v0, 13		#opens the file
	move	$a0, $t1
	li	$a1, 0
	li	$a2, 0
	syscall	
	move	$t3, $v0	#returns the file descriptor
	
	li	$v0, 14		#reads the file
	move	$a0, $t3
	move	$a1, $t2
	li	$a2, 80
	syscall
	
	#ble	$t4, 0, error	#i put the ble here to see it work... $t4 is 0 here
	move	$t4, $v0
	ble	$t4, 0, error
	
	move	$v0, $t3	#returns the file descriptor
	move	$v1, $t4	#returns the number of bytes
	
	
	jr	$ra
	
	#this function prints an error message in the event the bytes in the file <=0
error:
	li	$v0, 4
	la	$a0, errorMsg
	syscall
	
	j	exit
############################# CREATE THE ARRAY ##############################


#a0 = address 
#counter is going to be $a1 #initalize a1
	addi $a1, $a1, 0
loop:
	#while the byte doesn't equal 10 (newline)
	lb	$t1, ($a1)	#load the byte into $t1
	addi	$a1, $a1, 1	#add one to the byte
	beq	$t1, 10, new	#if the byte is 10... need to add the number we have made so far
	beq	$t1, 0, for	#if the byte is 0... we are done reading through the file (end of file)
	
	#now we know the byte doesnt equal 10 or 0
	
	#need to check and see if it is in between 48 and 57
	bgt	$t1, 57, loop	#if its greater than (non inclusive of 57 go back up to the loop and go to the next byte)
	blt	$t1, 48, loop	#if its less than (non inclusive of 48 go back up to the loop and go to the next byte)
	addi	$t2, $t1, -48	#convert to int from ascii by subtracting 48
	add	$t4, $t3, $t2	#add the numbers we have so far 
	
	jal create		#branch to create method
	
	j loop			#go back up into the for loop
	
#this method is responsible for multiplying the number by 10 when we need it to 
create:
	move	$a0, $t2
	move	$t3, $a0
	mul	$t3, $t3, 10
	jr	$ra		#return to the return address 
	
#if we get to a new line byte add the current number to the array 		
new:
	sw	$t4, ($t6)	#take the number we have and add it to the current address in array 
	addi	$t6, $t6, 4	#go to the next spot in the array 
	li	$t2, 0		#reset the values
	li	$t3, 0
	li	$t4, 0
	j	loop


###################### PRINT UNSORTED ARRAY ############################
#need to print out the array
#move	$a1, $t6

for:
	li	$t1, 0	# i = 0
	la	$t2, array	#store the address of the array in $t2
	li	$a1, 20	#length of array is 20
	lw	$t6, before	#load the before prompt
	
	li	$v0, 4		#print the before prompt
	la	$a0, before
	syscall
	
	j 	loop1		#go to the printing loop 
	
#this loop is going to print out everything before twe sort it and then
#once the counter reaches the end of the array we are going to go straight to the sort function
loop1:
	beq	$t1, $a1, setSort	#once we print out everything... start sorting 
	lw	$t3, ($t2)
	
	li	$v0, 1		#print out the current number 
	move	$a0, $t3
	syscall
	
	
	li	$a0, 32 #have to use 32 as the character for spaces
	li	$v0, 11 #have to use 11 to print the space
	syscall
	
	addi	$t2, $t2, 4	#go to the next word
	addi	$t1, $t1, 1	#add one to the counter 
	
	j loop1


#########################################	SELECTION SORT	###############################
#selection sort takes in an array into $a0 and outputs an array into $v0

#little psuedocode

#need a counter = j
#counter needs to be j < length-1
#iterate j each time
#set temp variable to first number
#if i = j+1 while i < length j++
	#if array at i is less than array at temp
	#temp equals k
	#if temp doesn't equal i
	#switch i and k
	

#this part is going to initalize our values for the sort 
setSort:
	la	$t6, array
	li	$t2, 1
	li	$s0, 20
	#j	for1	#then we are going to go straight into the outer for loop 
	
selectionSort:
	li	$t0, 0		#i = 0	
	move	$t1, $t0	#index = i
	

#this is responsible for holding the smaller number 	
#after finishing this selection sort it is going to go straight into printing 
for1_loop:
	beq	$t1 $s0, after	#$s0 is 20... the length of the array
	sll	$t5, $t1, 2	#get the element at index
	add	$t3, $t6, $t5
	lw	$t4, 0($t3)	#load the new word
	#li	$t2, 0
	j for2
for2:
	addi	$t2, $t1, 1	#j = i+1
	#j	for2_loop
for2_loop:
	#arr[j] < array[index]
	#need to get array at $t1
	#need to get array at index j
	beq	$t2, $s0, switch	#if the inner loop gets to 20 switch the smallest number to its spot
	
	sll	$t7, $t2, 2	#get the element at j
	add	$t8, $t6, $t7
	lw	$t9, 0($t8)		#load the elment at j into $t9
	
	addi	$t2, $t2, 1 	#j++
	
	#if the second number is greater than the first loop back up
	#if the second number is less than the first the second number becomes the new temporary number... by the swap method
	blt	$t9, $t4, swap	
	
	#addi	$t1, $t1, 1
	j	for2_loop
	
swap:
	#need to set $t4 to $t9... set it to the temporary variable
	move	$t4, $t9
	la	$s1, ($t8)
	#la	$s1, ($t4)
	j for2_loop

#this method is repsonsible for switching the smallest number to the front 
#and taking the number that was originally there and putting it where the smallest number used to be 
switch:
	
	#need to move the element in $t4 to the spot at the current index
	lw	$s2, 0($t3)
	beq	$t4, $s2, bfor1_loop
	
	sw	$t4, 0($t3)
	#need to switch the first number to where the other number was
	sw	$s2, 0($s1)
	
	addi	$t1, $t1, 1
	li	$s2, 0
	move	$t2, $t1
		#need to start $t2 where $t1 stopped
	j for1_loop
	
	
	#very simple method that adds one to the counter, resets $s2, and moves $t2 to $t1
	#just the last three lines of the switch method
bfor1_loop:
	addi	$t1, $t1, 1
	li	$s2, 0
	move	$t2, $t1
	j	for1_loop
	

###############################################	PRINT SORTED ARRAY ##################################
# this first part is just going to set up the for loop and print the after prompt
after:
	li	$t1, 0	# i = 0
	la	$t2, array
	li	$a1, 20	#length of array is 20
	lw	$t6, afterPrompt
	
	li	$v0, 4		#print after prompt
	la	$a0, afterPrompt
	syscall
	
#this is going to loop through the sorted array and print each element 
printer:
	beq	$t1, $a1, reset	#after it reaches the end it is going to reset the values to start calculations
	lw	$t3, ($t2)
	
	li	$v0, 1	#print the number 
	move	$a0, $t3
	syscall
	
	
	li	$a0, 32 #have to use 32 as the character for spaces
	li	$v0, 11 #have to use 11 to print the space
	syscall
	
	addi	$t2, $t2, 4	#go to the next word
	addi	$t1, $t1, 1	#i++
	
	j printer
	
################################## CALCULATIONS ############################

################################ CALCULATE THE MEAN
#going to call reset before I call mean, median, and standard deviation
reset:
	la	$a0, array
	li	$a1, 20
	#return values in $v0 and float values in one of the $f registers
	

#going to take in an array and return a float
#responsible for calculating the mean 
mean1:
	#going to take in the array
	#need to loop through and add up all the numbers
	#this initalizes the for loop 
	la	$a0, array
	li	$a1, 20
	li	$t1, 0	# i = 0
	la	$t2, array
	li	$t6, 0
	j	adder
	#going to return a float-- single percision
	#store in memory
	

#this function is going to add everything up, return an int and go back to the $ra -- the mean
adder:
	beq	$t1, $a1, divide	#if we go all the way through go back to the mean function
	lw	$t3, ($t2)
	add	$t6, $t6, $t3	#t6 = t6 + t3
	
	addi	$t1, $t1, 1
	addi	$t2, $t2, 4
	j	adder
	
divide:
	mtc1	$t6, $f0
	move	$t1, $a1
	mtc1	$t1, $f3
	cvt.s.w	$f3, $f3
	cvt.s.w	$f1, $f0
	div.s	$f12, $f1, $f3
	
	s.s	$f12, mean	#store a mean to memory as a float
	
	#li	$v0, 2
	#la	$a0, mean	
	#syscall



################################ CALCULATE THE MEDIAN 
#if array is odd... return middle value
#if array is even... get 9th andd 10th number... average

#need to loop and get the length, counter, ever 4 bytes
median1:
	la	$a0, array
	li	$a1, 20
	li	$t1, 0 	#i = 0
	li	$t3, 0	#counter
	move	$t2, $a0
	j oddOrEven

#this is responsible for seeing if the length (in $a1) is even or odd 
oddOrEven:
	move	$t4, $a1
	div	$t4, $t4, 2	#divide the length by 2
	mfhi	$t4	#get the remainder 
	
	bne	$t4, 0, oddMedian	#if the remainder isn't 0 its odd store in $v1	
	
	j evenMedian		#otherwise go to the even method 
	
# the length is oddd --- need to just get the middle number
oddMedian:
	beq	$t1, $a1, exit
	beq	$t1, 10, setOddMedian
	lw	$t3, ($t2)
	
	addi	$t2, $t2, 4
	addi	$t1, $t1, 1

#store the median in $t3 
setOddMedian:
	sw	$t3, median
	
	
#length is even --- need to average the two numbers in the middle
evenMedian:
	beq	$t1, $a1, average	#loop through the array 
	lw	$t3, ($t2)
	beq	$t1, 9, set9		#get the 9th and 10th element 
	beq	$t1, 10, set10
		
	addi	$t2, $t2, 4	#go to the next word
	addi	$t1, $t1, 1	#i++
	
	j	evenMedian

#save the 9th element 
set9:
	move	$t9, $t3
	addi	$t1, $t1, 1
	addi	$t2, $t2, 4
	j	evenMedian	#go back into the loop 

#save the 10th element 
set10:
	move	$t8, $t3
	addi	$t2, $t2, 4
	addi	$t1, $t1, 1
	j	average		#go straight to the average method 

#this justs adds the two numbers, converts it into a float and divides by two 	
average:
	add	$t1, $t9, $t8
	lw	$t0, by2
	mtc1	$t0, $f3
	mtc1	$t1, $f0
	cvt.s.w	$f0, $f0
	div.s	$f12, $f0, $f3
	
	s.s	$f12, median	#store the median to memory as a float
	
	#just to make sure it was in the median variable 
	#li	$v0, 2
	#la	$a0, median
	#syscall

######################################## STANDARD DEVIATION
#this function is going to intitalize the loop to find the standard deviation	
sd1:
	la	$a0, array
	li	$a1, 20
	li	$t1, 0 	#i = 0
	move	$t2, $a0
	j	accumulate	#going to go the next method

#this is going to take the current number
#subtract the average
#square it
#and add it into an accumultion register 
accumulate:
	beq	$t1, $a1, divide1	#if you make it to the end of the array go to the divide function
	lw	$t3, ($t2)	#load the current number
	mtc1	$t3, $f0	#move thhe number into a float register
	cvt.s.w	$f0, $f0	#convert it into a single percision double
	l.s	$f1, mean	#load the mean into $f1
	sub.s	$f3, $f0, $f1	#subtract the float by the average
	mul.s	$f3, $f3, $f3	#square it
	
	add.s	$f5, $f5, $f3	#add into the accumulation register
	addi	$t2, $t2, 4	#go to the next word
	
	addi	$t1, $t1, 1	#i++
	j 	accumulate	
	
#little psuedocode	
	#need to loop through array
		#get the number and subtract the average from it
		#multiply it by itself
		#add it into the accumulator
		#loop
	#divide by n-1

#need to divide the accumulated number by the length of the array minus 1
divide1:
	move	$t1, $a1	#move the length to $t1
	addi	$t1, $t1, -1	#19
	mtc1	$t1, $f0	#move 19 into a float register
	cvt.s.w	$f0, $f0	#convert it to a float
	div.s	$f5, $f5, $f0	#divide the sum by 19
	 
	#square root
	sqrt.s	$f12, $f5
	s.s	$f12, sDev	#store the standard deviation to memory
	
	#printed out the deviaton just to check 
	#li	$v0, 2
	#la	$a0, sDev
	#syscall
	
#####################################	PRINT PROMPTS AND VALUES  ###############################
printEnd:
	li	$v0, 4		#print mean prompt
	la	$a0, meanPrompt
	syscall
	
	l.s	$f12, mean	#load the mean from memory into the $f12 to print
	li	$v0, 2
	la	$a0, mean
	syscall
	
	li	$v0, 4		#print the median prompt
	la	$a0, medianPrompt
	syscall
	
	l.s	$f12, median	#load the median from memory into $f12 to print
	li	$v0, 2
	la	$a0, median
	syscall
	
	li	$v0, 4		#print the standard deviation prompt
	la	$a0, sdPrompt
	syscall
	
	l.s	$f12, sDev	#load the standard deviation from memory into $f12 to print 
	li	$v0, 2
	la	$a0, sDev
	syscall

########################	EXIT PROGRAM	########################	
	
exit:
	li	$v0, 10
	syscall