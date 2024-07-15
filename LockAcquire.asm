;;
; Name: Kelsey Marquez
; Date:
; Description:
;


	;.syntax unified
	.text
	.align 2
	.thumb


	;.type lock_acquire, %function
	.global lock_acquire

; lock_acquire : This function
;
; NOTES:
;		This function
;---------- Check_Switches ----------
lock_acquire:
	MOV 	r1, #0

	LDREX 	r2, [r0]		; R2 <--- lock value
	CMP		r2, r1			; is it already 0 (already locked)?
	ITT		NE
	STREXNE r2, r1, [r0]	; if not, try to claim it by writing 0
							; R2 <--- 0 if successful, 1 if failure
	CMPNE	r2, #1			; and check success
	BEQ		lf				; branch taken if lock was already 0
							; (so the previous two xxxxNE instructions
							; did not execute) or STREXNE returned 1.
	MOV		r0, #1			; indicate success
	BX		LR

lf:							; local label...branch here from above with destination 'lf'
	CLREX					; we did not get the lock. clear exclusive access.
	MOV		r0, #0			; indicate failure
	BX		LR
