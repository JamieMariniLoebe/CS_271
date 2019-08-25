TITLE Composite Numbers   (program_3.asm)

; Author: Jamie Loebe
; Last Modified: 07/27/2019
; OSU email address: loebej@oregonstate.edu
; Course number/section: 271/400
; Assignment Number: 3                Due Date: 07/29/2019
; Description: This program prompts the user for the number of composite numbers and then outputs that amount of composite numbers.

INCLUDE Irvine32.inc

UPPER = 300
LOWER = 1

.data

intro1	BYTE	"Hello there! Welcome to the Compositem Number Program",0
intro2	BYTE	"Programmed by Jamie Loebe",0
intro3	BYTE	"In this program, I will show you a list of composite numbers based on how many you want!",0 
intruct	BYTE	"You can choose any number between 1 and 300",0
prompt	BYTE	"How many composite numbers would you like to see? ",0
error	BYTE	"Error! That number is out of range! Please choose between 1 and 300",0
goodbye	BYTE	"That was fun! Bye now!",0
spaces	BYTE	"     "


.data?

userInput	DWORD	?
composite   DWORD	?
lines		DWORD	?

.code
main PROC

	call	intro
	call	getInput
	call	ShowComposites
	call	TheEnd



exit	; exit to operating system
main ENDP

intro	PROC
;Procedure to display welcome message
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx	

	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET intro3
	call	WriteString
	call	CrLf
	ret
intro ENDP


getInput	PROC
;Procedure to prompt user for 2 numbers
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt
	mov		userInput, eax
	call	validate
	ret
getInput	ENDP


validate	PROC
;Procedure to prompt user for 2 numbers
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
	cmp		userInput, UPPER
	jg		OutOfRange
	cmp		userInput, LOWER
	jl		OutOfRange
	ret

OutOfRange:
	mov		edx, OFFSET error
	call	WriteString
	call	CrLf
	jmp		getInput
validate	ENDP

ShowComposites	PROC
;Procedure to output composite numbers
;receives: none
;returns: none
;preconditions:  UserInput has been validated
;registers changed: ebx, ecx, edx, esi and ebp
	mov		ebx, 3		;Start at 4
	mov		ecx, userInput	;Put number of composites user wants in ecx. Used as counter
	mov		ebp, 2
	;dec		ecx				;1 less number because we go up until n-1
top:
	cmp		ecx, 0
	je		ending
	inc		ebx
	call	IsComposite	
	cmp		esi, 0			;Check if flag is true or false
	je		top				;If false, jump back to top with new divisor
	mov		eax, ebx

	call	WriteDec
	;inc		ebx
	mov		edx,	OFFSET spaces
	call	WriteString
	loop	top				;This will decrement ECX, so that there is 1 less num to print. And if not done, jump to top

ending:
	ret
	
ShowComposites	ENDP

IsComposite	PROC
;Procedure to check if a number is composite or not
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx, eax, esi, ebp
	xor		edx, edx			;Caused  integer overflow, needed to zero out edx
	mov		eax, ebx			;Put cur_num into eax
	;mov		ebp, 2				;Move divisor into ebp 
	;div		ebp					;Divide current num by 2
	mov		esi, 0				;set flag to false
	
top:
	div		ebp
	cmp		edx, 0				;compare edx and 0
	jne		notComposite		;If remainder, not composite
	;cmp		edx, 0			;Duplicate
	je		foundComposite		;If remainder is 0, composite
	;dec		eax					;Decrements to next possible composite
	inc		eax					;Increment to next possible composite (4,5,6,7,8.....)
	mov		ebp, ebx			;Move cur num to ebp
	;mov		eax, ebx
	jmp		top

foundComposite:
	mov		esi, 1				;Composite found, flag is true
	ret

notComposite:
	mov		esi, 0				;composite not found, flag is false
	inc		ebp					;increment divisor (divide by 2,3,4,5,6......)
	ret
	
IsComposite	ENDP

TheEnd	PROC
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString

TheEnd	ENDP

exit

END main