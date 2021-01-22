#store/load指令测试
mov $1,0b10000001
storeb $1,$0,0
loadbu $2,$0,0
loadb $3,$0,0
mov $1,0b1000000000000001
storeh $1,$0,4
loadhu $4,$0,4
loadh $5,$0,4
mov $1,0b11000000000000001
storew $1,$0,8
loadw $6,$0,8
storewl $1,$0,12
loadwl $7,$0,12
storewr $1,$0,19
loadwr $8,$0,19