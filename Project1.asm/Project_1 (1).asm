TITLE Math Program   (program_1.asm)

; Author: Jamie Loebe
; Last Modified: 07/05/2019
; OSU email address: loebej@oregonstate.edu
; Course number/section: 271/400
; Assignment Number: 1                Due Date: 07/08/2019
; Description: This program prompts the user for 2 numbers, and then outputs 
; the sum, difference, product, quotient and the remainder of those 2 numbers.

INCLUDE Irvine32.inc


.data

welcome		BYTE	"Math Program-1, by Jamie Loebe",0
prompt_1	BYTE	"Please enter 2 numbers, and I will output the sum, difference, product, quotient and remainder of those numbers!",0
program_end BYTE	"That was fun! Until next time! Bye!",0
plus		BYTE	" + ",0
minus		BYTE	" - ",0
mult		BYTE	" * ",0
divi		BYTE	" / ",0
equals		BYTE	" = ",0
rem			BYTE	" remainder of ",0
first_num	BYTE	"First Number: ",0
second_num	BYTE	"Second Number: ",0


.data?

num1		DWORD	?
num2		DWORD	?
sum			DWORD	?
difference	DWORD	?
product		DWORD	?
quotient	DWORD	?
remainder	DWORD	?


.code
main PROC

;Procedure to display welcome message
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx	

	mov		edx, OFFSET welcome
	call	WriteString
	call	CrLf
	call	CrLf

;Procedure to prompt user for 2 numbers
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	call	CrLf

;Procedure to get user input values for first_num and second_num
;receives: none
;returns: user input values for first_num and second_num
;preconditions:  none
;registers changed: edx, eax
	mov		edx, OFFSET first_num
	call	WriteString
	call	ReadInt
	mov		num1, eax
	call	CrLf
	
;Receive 2nd number from user and store in variable num2
	mov		edx, OFFSET second_num
	call	WriteString
	call	ReadInt
	mov		Num2, eax
	call	CrLf


;Procedure to calculate the sum of Num1 and Num2 and store in variable sum
;receives: num1 and num2
;returns: variable sum = num1 + num2
;preconditions:  none
;registers changed: eax
	mov		eax, num1
	add		eax, num2
	mov		sum, eax

;Procedure to calculate the difference of Num1 and Num2 and store in variable difference
;receives: num1 and num2
;returns: variable differnece = num1 - num2
;preconditions:  none
;registers changed: eax
	mov		eax, Num1
	sub		eax, Num2
	mov		difference, eax

;Procedure to calculate the product of Num1 and Num2 and store in variable product
;receives: num1 and num2
;returns: variable product = num1 * num2
;preconditions:  none
;registers changed: eax
	mov		eax, Num1
	mul		Num2
	mov		product, eax


;Procedure to calculate the quotient and remainder of Num1 and Num2 and store in variables quotient and remainder
;receives: num1 and num2
;returns: variable quotient = num1 / num2 and variable remainder
;preconditions:  none
;registers changed: edx, eax, ebx
	mov		edx,0
	mov		eax, num1
	mov		ebx, num2
	div		ebx

;Store result of division in quotient, and remainder of division in remainder variable
;receives: quotient and remainder
;returns: none
;preconditions:  none
;registers changed: eax
	mov		quotient, eax
	mov		remainder, edx


;Procedure to display the sum of num1 and num2
;receives: num1, num2, sum
;returns: none
;preconditions: sum was calculated
;registers changed: eax,edx

	mov		eax, Num1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, Num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

;Procedure to display the difference of Num1 and Num2 and store in variable difference
;receives: num1, num2, and difference
;returns: none
;preconditions: difference was calculated
;registers changed: eax, edx

	mov		eax, Num1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString	
	mov		eax, Num2
	call	WriteDec
	mov		edx, OFFSET equals 
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

;Procedure to display the product of Num1 and Num2 and store in variable product
;receives: num1, num2, and product
;returns: none
;preconditions: product was calculated
;registers changed: eax, edx

	mov		eax, Num1
	call	WriteDec
	mov		edx, OFFSET mult
	call	WriteString
	mov		eax, Num2
	call	WriteDec
	mov		edx, OFFSET equals 
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

;Procedure to display the quotient and remainder of Num1 and Num2 and store in variables quotient and remainder
;receives: num1, num2, quotient and remainder
;returns: none
;preconditions: quotient and remainder were both calculated
;registers changed: eax, edx

	mov		edx, 0
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET divi
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals 
	call	WriteString
	mov		eax, quotient
	call	WriteDec

;Display the remainder of the two numbers
	mov		edx, OFFSET rem
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf
	call	CrLf


;Procedure to display the program end message
;receives: none
;returns: none
;preconditions: sum, difference, product, quotient and remainder were all calculated
;registers changed: edx
	mov		edx, OFFSET program_end
	call	WriteString
	call	CrLf

exit	; exit to operating system
main ENDP

END main
