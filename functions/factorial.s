
#PURPOSE - Given a number, this program computes the
#          factorial.  For example, the factorial of
#          3 is 3*2*1,or6. The factorial of
#          4 is 4 * 3 * 2 * 1, or 24, and so on.
#
#This program shows how to call a function recursively.
.code32
.section .data
#This program has no global data
.section .text

.global _start
.global factorial  # this is unneeded unless we want to share this
                   # function among other program
_start:
 push $4

 call factorial
 addl $4, %esp
 movl %eax, %ebx  # system call exit return %ebx

 mov $1, %eax
 int $0x80

# This is the actual function definition

.type factorial, @function  # 
factorial:
  pushl %ebp                # standard function stuff, we have to restor %ebp to 
                            # its prior state before returing, so we have to push it
  movl %esp, %ebp           # This is because we don't want to modify the stack pointer
                            # so we use %ebp later

  movl 8(%ebp), %eax        # This moves the first argument to %eax, 4(%ebp) hold the
                            # return address, and 8(%ebp) holds the first argument.
  cmpl $1, %eax             # If the number is 1, that is our base
                            # case, and we simply return (1 is
                            # already in %eax as the return value)
  je end_factorial

  decl %eax                 # otherwise, decrease the value
  pushl %eax                # push it to stack as our next call parameter to factorial function
  call factorial            # recursive call factorial
  movl 8(%ebp), %ebx        # %eax has the return value, so we reload our parameter into
                            # %ebx
  imull %ebx, %eax          # multiply that by the result of the
                            # last call to factorial (in %eax)
                            # the answer is stored in %eax, which
                            # is good since that’s where return
                            # values go.

  end_factorial:
    movl %ebp, %esp         # standard function return stuff - we
    popl %ebp               # have to restore %ebp and %esp to where
                            # they were before the function started
    ret                     # return to the function (this pops the
                            # return value, too
# as --32 factorial.s -o factorial.o
# ld -m elf_i386 factorial.o -o factorial
