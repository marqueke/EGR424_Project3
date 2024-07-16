// ===== Include appropriate header files =====
#include "msp.h"
#include "Threads.h"
#include "UART.h"
#include "OS.h"

// standard includes
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

// These are the user-space threads. Note that they are completely oblivious
// to the technical concerns of the scheduler. The only interface to the
// scheduler is the single function yield() 

volatile uint32_t delay = 100000;
extern unsigned threadlock;         // external decleration of threadlock
extern int count;                   // external decleration of count

// ===== Thread 0 =====
// ===== Responsible for toggling on-board GREEN RGB LED infinitely ====
// ===== Use BIT-BANDING approach to reference the LED =====
// ===== Control taken away pre-emptively by the KERNEL =====
// BIT-BANDING APPROACH -> alias address of P2DIR and P2OUT
// P2DIR = 0x40004C05
// P2OUT = 0x40004C03
// byte offset = 0x40004C05 - 0x40000000 = 0x00004C05
// bit word offset = (0x00004C05 * 32) + (1 * 4) = 0x000980A4
// bit word address (alias) = 0x42000000 + 0x000980A4 = 0x420980A4

#define LED_DIR (*((volatile unsigned char *) 0x420980A4))
#define LED_OUT (*((volatile unsigned char *) 0x42098064))

void Thread0(void)
{
    // pre-emptive control will be given up by Systick timer
    volatile uint32_t i;

    LED_DIR = 1;

    while(1)
    {
        LED_OUT ^= 0x01;            // Toggle GREEN LED pin
        for(i = delay; i > 0; i--); // Delay
    }
  
}


// ===== Thread 1 =====
// ===== Responsible for printing message to the terminal window =====
// ===== Locks need to be implemented for this thread =====
// ===== Control needs to be given up voluntarily by this thread using yield() =====
void Thread1(void)
{
  
    while(1)
    {
        if(lock_acquire(&threadlock))		// Try to acquire lock and if successful
        {
            printf("\n\rEntered");
            yield();					// Give up control voluntarily (context switch "interrupt")

            printf(" Thread 1 -- pass %d", count);
            Lock_Release(&threadlock);					// Release lock
        }
        yield();                		// Give up control voluntarily (context switch "interrupt")
    }
}


// ===== Thread 2 =====
// ===== Responsible for printing message to the terminal window =====
// ===== Locks need to be implemented for this thread =====
// ===== Control needs to be given up voluntarily by this thread using yield() =====
void Thread2(void)
{
    while(1)
    {
        if(lock_acquire(&threadlock))		// Try to acquire lock and if successful
        {
            printf("\n\rEntered");
            yield();					// Give up control voluntarily (context switch "interrupt")

            printf(" Thread 2");
            Lock_Release(&threadlock);			// Release lock
        }
        yield();                		// Give up control voluntarily (context switch "interrupt")
    }
}

