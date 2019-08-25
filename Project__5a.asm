TITLE Program Template     (program__5a.asm)

; Author: Jamie Loebe
; Last Modified: 08/11/2019
; OSU email address: loebej@oregonstate.edu
; Course number/section: 271-400
; Assignment Number: 5A                Due Date: 08/12/2019
; Description: This program demonstrated low-level I/O procedure. It does so by prompting the user for 10 32-bit integers, which it accepts as numeric strings
; and conerts to integers, before converting them back to integer and printing them to the display. Then it displays the array, it's sum, and average. 

INCLUDE Irvine32.inc

;CONSTANTS

MAXSIZE = 10 ;Maximum size of array

mDisplayString	MACRO	str
	push		edx
	mov			edx, OFFSET str ;Prepare for call to WriteString
	call		WriteString 
	pop			edx 

ENDM


mGetString	MACRO	prompter, userStr
	push		edx
	push		ecx
	mDisplayString	prompter
	mov			edx, OFFSET userStr ; Move @ of userInput into edx
	mov			ecx, (SIZEOF userStr) - 1 ; Move size of userInput (- null terminator) to ecx
	call		ReadString ; Returns # of chars in string to EAX
	pop			ecx
	pop			edx

ENDM


.data

intro1		BYTE	"Hello there!",0
intro2		BYTE	"This program will demonstrate low-level I/O procedures",0
author		BYTE	"Programmed by Jamie Loebe",0
instruct	BYTE	"This program only accepts numbers that can fit into a 32-bit register",0 
prompt		BYTE	"Please input an integer: ",0
OutOfRange	BYTE	"Error! Your input was either not an integer or out of range. Try again",0
goodbye		BYTE	"Cool! Thanks for playing! Come again!",0
userInput	BYTE	21	DUP(?)
strLen		DWORD	0
num			DWORD	?
count		DWORD	0
sum			DWORD	?
array		DWORD	MAXSIZE		DUP(?)
NumArray	BYTE	"Here are your numbers: ",0
SumStr		BYTE	"The sum is: ",0
NumAve		BYTE	"The average is: ",0
comma		BYTE	", ",0

.code
main PROC

	push	OFFSET intro1 ;20
	push	OFFSET intro2 ;16
	push	OFFSET author ;12
	push	OFFSET instruct ;8
	call	intro ;4 WORKING

	mov		ecx, MAXSIZE ; Move 10 into ecx to act as counter for array
looper:
	push	OFFSET array ;8
	push	count ;4
	call	ReadVal
	inc		count ;Increment count until 10
	loop	looper ;Loop thru for each position in array

	call	CrLf

	mDisplayString	numArray ;Display array after 10 numbers input

	push	OFFSET array ;12
	push	count ;8
	call	WriteVal ;4

	push	OFFSET array ;12
	push	OFFSET SumStr ;8
	call	CalcSum ;4

	push	OFFSET array ;12
	push	OFFSET numAve ;8
	call	CalcAverage ;4


	push	OFFSET goodbye ;8
	call	TheEnd ;WORKING



exit	; exit to operating system
main ENDP

intro	PROC
;Procedure to display welcome messages
;receives: intro1, intro2 and instruct all by reference
;returns: introduction strings that introduce program and instructs user on what input is allowed
;preconditions:  none
;registers changed: ebp, edx

	push	ebp
	mov		ebp, esp

	mov		edx, [ebp+20]	;Output Hello string
	call	writeString
	call	CrLf

	mov		edx, [ebp+16]  ;Output intro string
	call	WriteString
	call	CrLf

	mov		edx, [ebp+12] ;Output Program description string
	call	WriteString
	call	CrLf

	mov		edx, [ebp+8] ;Output Programmed By string
	call	WriteString
	call	CrLf

	mov		edx, [ebp+4] ;Output instruct string
	call	WriteString
	call	CrLf

	pop		ebp
	ret 8

intro ENDP



ReadVal	PROC
;Procedure to prompt user for numeric string, and then computes the corresponding integer value
;receives: userInput, OOR and prompt (by reference)
;returns: Value of userInput
;preconditions:  none
;registers changed: ebp, edx, ecx and eax
;***Used Demo6.asm as reference and guideline***

	pushad
	mov		ebp, esp ;Set up stack frame
	mov		eax, [ebp+40] ;Length of string
	add		eax, 1 ;Increment to first position in array
	mGetString	prompt, userInput ;Prompt user for integer
	jmp		setup

TryAgain:
	mGetString prompt, userInput ;Reprompt user for integer
	jmp		setup

error:
	mDisplayString	OutOfRange ;Output error message
	call	CrLf
	jmp		TryAgain

setup: 
	mov		strLen, eax ;Setting strLen to actually have the length
	mov		ecx, eax ;Set up counter
	mov		esi, OFFSET userInput ;source
	mov		edi, OFFSET num ;destination

counter:
	lodsb ;****Referenced Lecture 23****
	cmp		al, 48 
	jb		error
	cmp		al, 57
	ja		error
	loop	counter
	jmp		GTG

GTG: ;****Referenced chapters 6.7.1 and 5.4.2 in the Irvine textbook for the below****
	mov		edx, OFFSET userInput ;edx is passed to ParseDecimal32
	mov		ecx, strLen ;ecx is passed to ParseDecimal32
	call	ParseDecimal32 
	.IF CARRY? ;Check if carry flag is set
	jmp		TryAgain
	.ENDIF ;End if statement
	mov		edx, [ebp+40] ;Move array into edx to store chars
	mov		ebx, [ebp+36] ;Count into ebx
	imul	ebx, 4		  ;Find pos
	mov		[edx+ebx], eax ;Value stored in eax moved into pos in array

	popad
	ret 8
ReadVal		ENDP


WriteVal	PROC
;Procedure to output numbers in the array
;receives: Array by reference and count by value
;returns: N/A
;preconditions: User input 10 integers, and they were converted into integers and stored in the array.
;registers changed: ebp, edi, ecx, eax

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]
	mov		ecx, MAXSIZE ;Move 10 into ecx. MAXSIZE is constant.
	call	CrLf

ShowArray:
	mov		eax, [edi] ;Move num in pos[] into eax to be output by WriteDec
	call	WriteDec
	cmp		ecx, 1 ;Check if counter has reached 0
	je		EndArr ;Skip comma for last num
	mDisplayString comma
	add		edi, 4 ;Move onto next pos in array (assuming full of DWORD)

EndArr:
	loop ShowArray


pop ebp
ret 8


WriteVal	ENDP


CalcSum	PROC
;Procedure to calculate the sum of the array
;receives: Array and numAve by reference
;returns: N/A
;preconditions:  Array is populated with integers that can be summed.
;registers changed: ebp, edi, ecx, ebx
;Referenced Demo5 PDF in getting started****

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12] ;Move in array
	call	CrLf
	call	CrLf
	mdisplayString	SumStr ;Sum string
	mov		ecx, MAXSIZE
	xor		ebx, ebx ;Clear out ebx

Summer:
	mov		edx, [edi]
	add		ebx, edx ;Add value at array pos[] to ebx, which will ultamately hold sum
	add		edi, 4 ;Move to next position in array
	loop	Summer

	mov		eax, ebx ;Move final sum into eax
	mov		sum, eax
	call	WriteDec

	pop		ebp
	ret		8

CalcSum		ENDP


CalcAverage	PROC
;Procedure to calculate average of the array
;receives: Array and numAve by reference
;returns: The calculated address of the array
;preconditions:  Array is populated with integers
;registers changed: ebp, edi, edx, eax, ecx

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12] ;Move in awway
	xor		edx, edx ;Clear out edx
	call	CrLf
	call	CrLf
	mDisplayString	NumAve ;Display average string
	mov		eax, sum
	mov		ecx, 2
	div		ecx ;Divide sum by 2
	call	WriteDec

	pop ebp
	ret 8


CalcAverage	ENDP


TheEnd	PROC
;Procedure to output goodbye message
;receives: goodbye (by reference)
;returns: Outputs goodbye message
;preconditions:  Program ran successfully
;registers changed: ebp, edi, eax, edx, ebx

	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+8] ;Output goodbye message
	call	CrLf
	call	CrLf
	call	WriteString
	call	CrLf
	call	CrLf

TheEnd	ENDP

exit

END main
