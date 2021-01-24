#lload/storec指令测试
mov $1,1
storew $1,$0,0
nop
mov $1,0
lload $1,$0,0
nop
add $1,$1,1
storec $1,$0,0
loadw $1,$0,0

loop:
nop
jmp loop