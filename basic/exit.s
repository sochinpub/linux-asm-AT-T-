# PURPOSE:  Simple program that exits and returns a
#          status code back to the Linux kernel
#
#INPUT:    none
#
# OUTPUT:   returns a status code.  This can be viewed
# by typing #
# echo $?
#          after running the program
#
# VARIABLES:
#          %eax holds the system call number
#          %ebx holds the return status
#
.section .data
.section .text
.global _start

_start:
  movl $1, %eax # This is the linux command number(system call),
                # for exiting a program
  movl $0, %ebx # This is the status number we will return to the operating
                # system. Change this around and it will return different
                # things to echo $?
  int $0x80     # This wake up the kernel to run the exit command


# 1) assemble
# as exit.s -o exit.o
# 2) link
# ld exit.o -o exit

