#ifndef UART_H_
#define UART_H_

#include <stdio.h>
#include <stdlib.h>

void UART0_Init(void);
int UART_Send(char a);
int UART_MSend(char *a);
char UART_Receive(void);

#endif 
