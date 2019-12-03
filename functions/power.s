# PURPOSE:  Program to illustrate how functions work
#          This program will compute the value of
# 2^3 + 5^2 
#
# Everything in the main program is stored in registers,
# so the data section doesn’t have anything.
.code32  # 64 位系统和 32 位系统的差别引起的 pushl汇编出错
.section .data

.section .text

.global _start

_start:
  pushl $3          # push second argument
  pushl $2          # push first argument
  call power        # call the function 
  addl $8, %esp     # move the stack pointer back
  pushl %eax        # save the first answer of 2^3, before the next function

  push $2           # push the second argument
  push $5           # push the first argument
  call power        # call the function
  addl $8, %esp     # move the stack pointer back

  popl %ebx         # The second answer of 5^2 is already in %eax, we save the first
                    # answer of 2^3 on the stack before, we pop it out into %ebx

  addl %eax, %ebx    # add them together, the result is in %ebx
  movl $1, %eax     # exit(system call exit, %ebx is returned)
  int $0x80


#PURPOSE:  This function is used to compute
#          the value of a number raised to
#          a power. 
#
#INPUT:    First argument - the base number
#
#
#
#OUTPUT:
#
#NOTES:
#
#VARIABLES:
#          %ebx - holds the base number
#          %ecx - holds the power

#
#          -4(%ebp) - holds the current result
#
#          %eax is used for temporary storage
#



#
#          -4(%ebp) - holds the current result
#
#          %eax is used for temporary storage
#
.type power, @function
power:
  pushl %ebp           # save the old base pointer
  movl %esp, %ebp      # make stack pointer the base pointer
  subl $4, %esp        # get root for our local storage

  movl 8(%ebp), %ebx   # put first argument in %ebx
  movl 12(%ebp), %ecx  # put second argument in %ecx

  movl %ebx, -4(%ebp)  # store current result

  power_loop_start:
    cmpl $1, %ecx      # if power is 1, we are done
    je end_power

    movl -4(%ebp), %eax # move the current result into $eax
    imull %ebx, %eax    # multiply the current result by the base number
    movl %eax, -4(%ebp) # store the current result

    decl %ecx           # decrease the power
    jmp power_loop_start# run for the next power

  end_power:
    movl -4(%ebp), %eax # return value goes in %eax
    movl %ebp, %esp     # resotre the stack pointer
    popl %ebp           # restore the base pointer

    ret

# as power.s  -o power.o --32
# ld -m elf_i386 power.o -o power
