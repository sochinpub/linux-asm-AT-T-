#PURPOSE:  This program finds the maximum number of a
#          set of data items.
#
#VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data.  A 0 is used
#              to terminate the data
.section .data
data_items:
  .long 3, 67, 34, 222, 45, 74, 54, 34, 44, 23, 11, 66, 0

.section .text

.global _start
_start:
movl $0, %edi      # move 0 to the index register
movl data_items(, %edi, 4), %eax # load the first byte of data
movl %eax, %ebx    # since this is the first element, %eax is the biggest

start_loop:
  cmpl $0, %eax    # check to seee if we hit the end
  je loop_exit
  incl %edi
  movl data_items(, %edi, 4), %eax # load the next value
  cmpl %ebx, %eax
  jle start_loop
  movl %eax, %ebx # move the value to be the biggest
  jmp start_loop  # jump to the beginning

loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
movl $1, %eax             #1 is the exit() syscall
int  $0x80

# as maxium.s -o maxium.o
# ld maxium.o -o maxium
