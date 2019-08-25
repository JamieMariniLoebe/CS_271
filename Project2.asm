TITLE Program 2      (program2.asm)

; Author: Jamie Loebe
; Last Modified: 07/15/2019
; OSU email address: loebej@oregonstate.edu
; Course number/section: 271-400
; Assignment Number: 2                Due Date: 07/15/2019
; Description: This program asks the uswer for how many iterations they would like of the Fibonacci sequence,
; ANd then prints out the sequence up to that number (Limited to 1-46)

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

;Intro
header1		BYTE	"Fibonacci Numbers Program",0
header2		BYTE	"Programmed by Jamie Loebe",0
intro		BYTE	"Hello there! What is your name?",0
hello		BYTE	"Hello, ",0
instruct	BYTE	"I can display the fibonacci terms between 1 and 46!",0
prompt		BYTE	"How many fibonacci terms do you want displayed? Please enter a number between 1-46: ",0
whiteSpace	BYTE	"     "

;Constants
UPPER = 46
LOWER = 1

;Error handling
Above		BYTE	"Error! That number is too high! Try again",0
Below		BYTE	"Error! That number is too low! Try again",0

;End
First		BYTE	"1	",0
Second		BYTE	"1	1",0
Bye			BYTE	"Until next time! Bye!",0

.data?
buffer		BYTE	32 DUP(0)
input		DWORD	?
byteCount	DWORD	?
firstNum	DWORD	?
secondNum	DWORD	?
tmp			DWORD	?


; (insert variable definitions here)

.code
main PROC

;Procedure to display welcome message
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx	

mov		edx, OFFSET header1
call	WriteString
call	CrLf

mov		edx, OFFSET header2
call	WriteString
call	CrLf
call	CrLf

mov		edx, OFFSET intro
call	WriteString
call	CrLf

;Procedure to receive input from user
;receives: string data from user
;returns: none
;preconditions:  none
;registers changed: edx, ecx, and eax


mov		edx, OFFSET buffer
mov		ecx, SIZEOF buffer
call	ReadString
mov		byteCount, eax
call	CrLf

;Procedure to display "Hello, *user name*"
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

mov		edx, OFFSET hello
call	WriteString
mov		edx, OFFSET buffer
call	WriteString
call	CrLf

;Procedure to display instructions
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

mov		edx, OFFSET instruct
call	WriteString
call	CrLf


;Procedure to prompt user for data, then read in that data (int). Moves input to eax register, checks if it is in bounds of the upper/lower limits
;and outputs manual answer for one and two. If larger than 1 or 2 and smaller than 46, moves to GoodToGo
;receives: int from user
;returns: none
;preconditions:  none
;registers changed: edx, and eax

TryAgain:
			mov		eax, 000000h
			mov		edx, 000000h
			mov		edx, OFFSET prompt
			call	WriteString
			call	ReadInt
			
			mov		input, eax

			cmp		input, UPPER
			jg		TooHigh

			cmp		input, LOWER
			jl		TooLow
			je		Equal

			cmp		input, 2
			je		OnlyTwo

			jmp		GoodToGo


;Procedure subtracts 2 from the ecx counter, as we already have done the first two iterations manually.
;Moves 1 and 2 to variables for 3rd iteration to sum correctly
;receives: none
;returns: none
;preconditions:  user has entered an int between 1 and 46
;registers changed: edx, ecx, and eax

GoodToGo:
			mov		ecx, input
			sub		ecx, 2
			mov		edx, OFFSET Second
			call	WriteString
			mov		firstNum, 1
			mov		secondNum, 2
			mov		eax, 1
			jmp		calc


;Procedure that calculates fibonacci numbers. Adds second number to eax, which is the sum of the previous iteration. Places spaces between
;numbers, and moves SecondNum to FirstNum to facilitate new iteration of fibonacci number. 
;receives: none
;returns: none
;preconditions:  user has entered an int between 1-46
;registers changed: edx, ecx, ebx and eax

Calc:
			add		eax, secondNum
			call	WriteDec
			mov		edx, OFFSET WhiteSpace

			mov		tmp, eax
			mov		ebx, tmp
			mov		edx, SecondNum
			mov		firstNum, edx
			mov		secondNum, ebx
			mov		eax, firstNum ;eax is now the previous 2nd num, which is added to from previous sum
			dec		ecx ;Decrement ecx counter for loop

			cmp		ecx, 0
			je		Ending ;Jumps to end if counter equal to 0
			loop	calc ;or loop back to calc for another iteration


;Procedure to re-prompt user if input integer is above 46
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

TooHigh:	
			mov		edx, OFFSET above
			call	WriteString
			call	CrLf
			jmp		TryAgain

;Procedure to re-prompt user if input integer is below 1
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

TooLow:
			mov		edx, offset below
			call	WriteString
			call	CrLf
			jmp		TryAgain


;Procedure to jump if user enters 1
;receives: none
;returns: none
;preconditions:  none
;registers changed: none

Equal:		
			call	CrLf
			jmp		One

;Procedure to jump if user enters 2
;receives: none
;returns: none
;preconditions:  none
;registers changed: none

OnlyTwo:
			call	CrLf
			jmp		Two


;Procedure to output first fibonacci iteration
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx


One:		
			mov		edx, OFFSET First
			call	WriteString
			jmp		Ending


;Procedure to output first and second fibonacci iteration
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

Two:	
			mov		edx, OFFSET Second
			call	WriteString
			jmp		Ending

;Procedure to output goodbye
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

Ending:		
			call	CrLf
			mov		edx, OFFSET Bye	
			call	WriteString


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
