#lload/storec指令测试
mov $1,1
storew $1,$0,0
mov $1,2
storec $1,$0,0
loadw $1,$0,0

loop:
nop
jmp loop