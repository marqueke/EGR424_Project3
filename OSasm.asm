; ============================================================================
;   OSasm.asm: low-level OS commands, written in assembly
;   Runs on MSP432
;   A very simple real time operating system with minimal features.
; ============================================================================

        .thumb
        .text
        .align 2


        .global  RunPt            		; currently running thread
        .global  OS_DisableInterrupts
        .global  OS_EnableInterrupts
        .global  StartOS
        .global  SysTick_Handler

RunPtAddr .field RunPt,32

OS_DisableInterrupts:  .asmfunc			; Complete this
        CPSID	I						; Disable interrupts
		BX		LR						; Return from function
       .endasmfunc


OS_EnableInterrupts:  .asmfunc			; Complete this
        CPSIE	I						; Enable interrupts
		BX		LR						; Return from function
       .endasmfunc

SysTick_Handler:  .asmfunc     	; 1) Handler automatically saves R0-R3,R12,LR,PC,PSR on stack upon entry
	; 2) Disable interrupt mechanism to prevent interrupts from happening during switch
	CPSID	I			; disable interrupt

	; 3) Save remaining regs r4-11 on stack (of current thread)
	MRS 	R0, PSP				; load process stack pointer
	STMDB 	R0!, {R4-R11}		; store multiple decrement before
								; address R0 decrements before operation
								; '!' indicates post update of base register address

	; 4) Load R0 with the address of RunPt, current thread
	LDR 	R0, RunPtAddr

	; 5) Load R1 with the value of RunPt
	LDR 	R1, [R0]

	; 6) Save current SP into TCB structure
	STR 	R0, [R1]

	; 7) Load R1 with the value of RunPt->next
	LDR 	R1, [R1, #4]	; load register with value of next TCB

	; 8) Store it in RunPt (so it points to next thread)
	STR 	R1, [R0]		; update RunPt to point to next thread

	; 9) Load new thread SP; SP = RunPt->sp;
	LDR 	R0, [R1]		; load SP for next thread

	;10) Restore regs r4-11 (next thread)
	LDMIA 	R0!, {R4-R11}	; load multiple increment after
						; '!' indicates post update of base register address

	;11) Enable interrupt mechanism
	CPSIE 	I

	;12) Return to calling function (R0-R3,R12,LR,PC,PSR are automatically restored upon exit
	BX 		LR

    .endasmfunc


StartOS:  .asmfunc			   ; 1) Kickstarts the process with 1st thread
	; 2) Load R0 with the address of RunPt, current thread
	LDR R0,	RunPtAddr	; R0 contains address of pointer to current TCB

	; 3) Load R2 with the value of RunPt
	LDR R2,	[R0]		; R2 contains pointer of current TCB

	; 4) Load SP with new thread SP; SP = RunPt->stackPointer;
	LDR SP, [R2]		; SP is now on top of the stack for current thread

	; 5) Restore regs r4-11
	LDMIA 	SP!, {R4-R11}	; registers restored with values saved on stack
							; SP is updated

	; 6) Restore regs r0-3
	LDMIA	SP!, {R0-R3}	;registers restored with values saved on stack
							; SP is updated

	; 7) Restore reg r12
	LDR		R12, [SP], #4	; load R12 from stack and update SP

	; 8) Restore LR and discard LR from initial stack
	LDR		LR, [SP], #4	; load LR from stack and updates SP

	; 9) Restore return address and store it in LR (start location)
	LDR		LR, [SP], #4	; load return address into stack and update SP

	;10) Restore PSR into R1 and discard PSR
	LDR		R1, [SP], #4	; load PSR into R1 and updates SP

	;11) Enable interrupt mechanism at processor level
	CPSIE 	I

	;12) Return to calling function whcih would start the first thread
	BX		LR
    .endasmfunc

    .end
