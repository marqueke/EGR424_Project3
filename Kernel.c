// ===== Include appropriate header files =====
#include "msp.h"
#include "UART.h"
#include "Threads.h"
#include "OS.h"

// standard includes
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

// ===== This is the kernel that will setup everything and run the scheduler ======


#define TIMESLICE 6000  		    // Thread context switch time in system time units
                                    // timeslice = desired / clock period (desired = 2ms)
unsigned threadlock;            // Variable Lock
int count = 0;                  // Define count

// Code below is the interface to the C standard I/O library
// All the I/O are directed to the console which is UART0
struct __FILE { int handle; };
FILE __stdin = {0};
FILE __stdout = {1};
FILE __stderr = {2};

/**********PIN MAP************
 * * * * * * * * * * * * * * *
 ******* ON-BOARD LEDs *******
 * RED                   >P2.0
 * GREEN                 >P2.1
 * BLUE                  >P2.2
******************************/

// ====== Called by C library console / file output =======
int fputc(int c, FILE *f)
{
    
    return UART_Send((char)c);
}

// ====== For using printf() with format specifiers ======
int fputs(const char *_ptr, register FILE *_fp)
{
    int len = UART_MSend(_ptr);     // Send a string using UART_MSend()
    return len;                     // Return the length of the string
}


// ====== GPIO_Init() =======
void GPIO_Init(void)
{
    // Initialize GPIO periperals needed in this project
    P2->SEL0 &= ~0x07;  // GPIO for LEDs P2.0-P2.2
    P2->SEL1 &= ~0x07;
    P2->DIR |= 0x07;    // set LEDs as outputs
    P2->OUT &= ~0X07;   // turn off all LEDs upon startup
  
}


// ======== Function to initialize LOCK (you need to modify) =============
void Lock_Init(unsigned *lock)
{
    *lock = 0;          // initialize lock to 0 (unlock)
}

// ======= Function to acquire the lock to be written in LockAcquire.asm ======
extern unsigned lock_acquire(unsigned *lock);
/*
unsigned Lock_Acquire(unsigned *lock)
{
  return 1; // always succeeds
}
*/

// ======== Function to release LOCK (you need to modify) ===========
void Lock_Release(unsigned *lock)
{
	*lock = 0;          // release the lock
}


// ======= MAIN =========
int main(void)
{
    WDT_A->CTL = WDT_A_CTL_PW | WDT_A_CTL_HOLD; // stop watchdog timer

    Lock_Init(&threadlock);     // Initialize the global thread lock
    OS_Init();                  // Initialize OS
    UART0_Init();               // Initialize UART0 peripheral
    GPIO_Init();                // Initialize GPIO peripheral

	OS_AddThreads(Thread0, Thread1, Thread2);   // Add Threads to the list
	OS_Launch(TIMESLICE);                // Launch OS

	return 0;            // This never executes

}
