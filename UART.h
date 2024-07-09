#ifndef UART_H_
#define UART_H_

#include <stdio.h>
#include <stdlib.h>

void UART0_Init(void);
int UART_Send(char a);
int UART_MSend(char *a);
char UART_Receive(void);
int fputc(int c, FILE *f);
int fputs(const char *_ptr, register FILE *_fp);

#endif 
