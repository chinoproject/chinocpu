#jng指令测试1
mov $1,300 
mov $2,200
jng $1,$2,y
x:
mov $5,300
mov $3,200
y:
mov $3,400