################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Add inputs and outputs from these tool invocations to the build variables 
CMD_SRCS += \
../msp432p401r.cmd 

ASM_SRCS += \
../LockAcquire.asm \
../OSasm.asm 

C_SRCS += \
../Kernel.c \
../OS.c \
../Threads.c \
../UART.c \
../startup_msp432p401r_ccs.c \
../system_msp432p401r.c 

C_DEPS += \
./Kernel.d \
./OS.d \
./Threads.d \
./UART.d \
./startup_msp432p401r_ccs.d \
./system_msp432p401r.d 

OBJS += \
./Kernel.obj \
./LockAcquire.obj \
./OS.obj \
./OSasm.obj \
./Threads.obj \
./UART.obj \
./startup_msp432p401r_ccs.obj \
./system_msp432p401r.obj 

ASM_DEPS += \
./LockAcquire.d \
./OSasm.d 

OBJS__QUOTED += \
"Kernel.obj" \
"LockAcquire.obj" \
"OS.obj" \
"OSasm.obj" \
"Threads.obj" \
"UART.obj" \
"startup_msp432p401r_ccs.obj" \
"system_msp432p401r.obj" 

C_DEPS__QUOTED += \
"Kernel.d" \
"OS.d" \
"Threads.d" \
"UART.d" \
"startup_msp432p401r_ccs.d" \
"system_msp432p401r.d" 

ASM_DEPS__QUOTED += \
"LockAcquire.d" \
"OSasm.d" 

C_SRCS__QUOTED += \
"../Kernel.c" \
"../OS.c" \
"../Threads.c" \
"../UART.c" \
"../startup_msp432p401r_ccs.c" \
"../system_msp432p401r.c" 

ASM_SRCS__QUOTED += \
"../LockAcquire.asm" \
"../OSasm.asm" 


