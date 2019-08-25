TITLE Program Template     (program4.asm)

; Author: Jamie Loebe
; Last Modified: 08/02/2019
; OSU email address: loebej@oregonstate.edu
; Course number/section: 271-400
; Assignment Number: 4                Due Date: 08/05/2019
; Description: This program prompts the user for how many elements in an array they want, and then prints the unsorted, and sorted order and the median

INCLUDE Irvine32.inc

;CONSTANTS

MIN = 15
MAX = 200
HI = 999
LO = 100

.data

intro1		BYTE	"Hello there! Welcome to the Sorting Random Integers Program!",0
intro2		BYTE	"Programmed by Jamie Loebe",0
instruct	BYTE	"In this program, I will show you a list of integers, display them in sorted order, and give median value!",0 
prompt		BYTE	"How many numbers do you want to generate? Please input in the range of 15-200: ",0
OutOfRange	BYTE	"Error! That number is out of range! Please choose in the range of 15 and 200",0
goodbye		BYTE	"That was fun! Bye now!",0
userInput	DWORD	?
array		DWORD	MAX		DUP(?)
unsorted	BYTE	"Here is the unsorted array: ",0
sorted		BYTE	"Here is the sorted array: ",0
median		BYTE	"The median is: ",0
spaces		BYTE	"     ",0

.code
main PROC

	call	randomize

	push	OFFSET intro1 ;16
	push	OFFSET intro2 ;12
	push	OFFSET instruct ;8
	call	intro ;4

	push	OFFSET userInput ;16
	push	OFFSET OutOfRange; 12
	push	OFFSET prompt ;8
	call	getData ;4

	push	OFFSET array ;12
	push	userInput ;8
	call	arrayFill ;4

	push	OFFSET array ;20
	push	userInput ;16
	push	OFFSET unsorted ;12
	push	OFFSET spaces ;8
	call	displayList ;4

	push	OFFSET array ;12
	push	userInput ;8
	call	sortList ;8

	push	OFFSET array ; 16
	push	userInput ;12
	push	OFFSET median ;8
	call	calcMedian ;4

	push	OFFSET array ;20
	push	userInput ;16
	push	OFFSET sorted ;12
	push	OFFSET spaces ;8
	call	displayList

	push	OFFSET goodbye ;8
	call	TheEnd



exit	; exit to operating system
main ENDP

intro	PROC
;Procedure to display welcome message
;receives: intro1, intro2 and instruct all by reference
;returns: introduction strings
;preconditions:  none
;registers changed: ebp, edx

	push	ebp
	mov		ebp, esp

	mov		edx, [ebp+16]	;Output intro strings
	call	writeString
	call	CrLf

	mov		edx, [ebp+12]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+8]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+4]
	call	WriteString
	call	CrLf

	pop		ebp
	ret 8

intro ENDP



getData	PROC
;Procedure to prompt user for number of elements in array. 
;receives: userInput, OOR and prompt (by reference)
;returns: Value of userInput
;preconditions:  none
;registers changed: ebp, edx, ecx and eax

	push	ebp
	mov		ebp, esp

NumInput:
	mov	    edx, [ebp+8] ; Move in prompt
	call	WriteString
	call	ReadInt
	mov		ecx, [ebp+16]  ; get &userInput off stack and put it in ecx
	mov		[ecx], eax    ; store eax into &userinput -- eax contains the return value from ReadInt

cmp		eax, MAX
	jg		OOR
	cmp		eax, MIN ;Jump to OOR -- OutOfRange -- label if beyond MIN or MAX
	jl		OOR
	jmp		goodToGo

OOR:
	call	CrLf
	jmp		NumInput ;Reprompt user if OOR


goodToGo:
	pop		ebp

	ret		4
getData		ENDP


arrayFill	PROC
;Procedure to fill array with random integers. 
;receives: Array, unsorted and spaces (by reference) and userInput (by value)
;returns: Array now populated with random integers
;preconditions:  UserInput was validated
;registers changed: ebp, ecx, edi and eax.
;Used Lecture 20 (Displaying Arrays and Using Random Numbers) as reference for arrayFill

	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]    ; ecx contains &userInput
	mov		edi, [ebp+12]   ; edi contains &array

randomizer:
	mov		eax, hi	;Calculate range for user input
	sub		eax, lo
	inc		eax
	call	RandomRange
	add		eax, lo
	mov		[edi], eax
	add		edi, 4
	loop	randomizer ;Continue looping for all elements of array

	pop		ebp
	ret		8

arrayFill	ENDP

displayList	PROC
;Procedure to output the array in unsorted and sorted order. 
;receives: Array, unsorted/sorted, and spaces (by reference) and userInput (by value)
;returns: Unsorted/sorted list of integers
;preconditions:  UserInput has been validated and array is populated with random integers
;registers changed: ebp, edi, ecx, ebx, eax
;Referenced Demo5 PDF in getting started

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+20]		;Move in array
	mov		ecx, [ebp+16]
	xor		edx, edx
	mov		ebx, 0				;Use as line counter

	mov		edx, [ebp+12]
	call	WriteString
	call	CrLf

printNum:
	mov		eax, [edi]			;Move in array[0], and increment each iteration
	call	WriteDec
	mov		edx, [ebp+8]
	call	WriteString

	add		edi, 4
	inc		ebx

	cmp		ebx, 10
	jge		nextLine
	jmp		continue

nextLine:
	mov		ebx, 0	;Reset line counter
	call	CrLf

continue:
	loop	printNum
	call	CrLf
	call	CrLf

	pop		ebp
	ret		12

displayList		ENDP


sortList	PROC
;Procedure to sort array in descending order using bubble sort
;receives: Array (by reference) and userInput (by value)
;returns: The array now in sorted order
;preconditions: UserInput was validated and array was populated correctly
;registers changed: ebp, edi, ecx, eax
;*****Borrowed code outline from Irvine example program BubbleSort (Pg. 275, Ch.9)********

	push	ebp
	mov		ebp, esp
	;mov		edi, [ebp+12] ; this should contain &array
	mov		ecx, [ebp+8]  ; this should contain userInput
	dec		ecx

L1:
	push	ecx
	mov		edi, [ebp+12]	;Move in @array

L2:
	mov		eax, [edi]
	cmp		[edi+4], eax
	jl		L3
	xchg	eax, [edi+4]
	mov		[edi], eax

L3:
	add		edi, 4
	loop	L2

	pop		ecx
	loop	L1

	pop		ebp
	ret	 8
	
sortList	ENDP


calcMedian	PROC
;Procedure to calculate median of the array
;receives: Array (by reference) and userInput (by value)
;returns: The calculated median of the array
;preconditions:  none
;registers changed: ebp, edi, eax, edx, ebx
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+16]
	mov		eax, [ebp+12]
	xor		edx, edx	;Zero out edx to make sure it's clean

	mov		ecx, 2
	div		ecx		;Divide # of elements by 2
	cmp		edx,0	;Check remainder for even or odd
	je		evenSteven
	jne		odd

odd:
	mov		ebx, 4
	mul		ebx		;Multiply by 4 bytes
	mov		ebx, [edi+eax]		;Move middle position to ebx
	mov		eax, ebx			;Move to eax for print
	jmp		printMed

evenSteven:
	mov		ebx, 4
	mul		ebx
	mov		ebx, [edi+eax]		;High median
	sub		eax, 4
	mov		eax, [edi+eax]		;Low median
	add		eax, ebx			;Add both
	mov		ecx, 2
	div		ecx					;divide by 2
	;add		eax, edx
	jmp		printMed


printMed:
	mov		edx, [ebp+8]		;Move in string output for median
	call	WriteString
	call	WriteDec
	call	CrLf
	call	CrLf

	pop		ebp
	ret		8

calcMedian	ENDP
	

TheEnd	PROC
;Procedure to output goodbye message
;receives: goodbye (by reference)
;returns: Output of "Goodbye!"
;preconditions:  Program ran successfully
;registers changed: ebp, edi, eax, edx, ebx

	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+8]
	call	WriteString

TheEnd	ENDP

exit

END main
