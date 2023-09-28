#t0 - array size 
#t1 - == 10
#t2 - array iterator
#t3 - const array size
#t4 - max int
#t5 - min int
#t6 - sum
#a1 - max_int - array[i]
#a2 - min_int - array[i]
#a3 - array iterator value

.data

array: .space 40
enter_msg: .asciz "Enter array size -> "
fill_array_msg: .asciz "Enter all array elements: \n"
sum_msg: .asciz "Total sum: "
ERROR_wrong_array_size_msg: .asciz "Error! Wrong array size (should be between 1 and 10)\n"
ERROR_sum_overflow_msg: .asciz "Overflow! Not all sum has counted \n"


.text

enter_array_size:          # Принимает целое число - размер массива
#============
li a7, 4
la a0, enter_msg
ecall
#============
li a7, 5
ecall
mv t0, a0
mv t3, a0
li t1, 10
la t2, array
li t4, 2147483647         # Это - максимальное и минимальное значение int
li t5, -2147483648
bgt t0, t1, ERROR_wrong_array_size    # Проверяем размер массива на корректность
blez t0, ERROR_wrong_array_size
#============
li a7, 4
la a0, fill_array_msg
ecall
#============
j fill_array



fill_array:               # Заполняем массив введенными числами
li a7, 5
ecall
sw a0, (t2)
addi t0, t0, -1
beqz t0, count_sum
addi t2, t2, 4
j fill_array



count_sum:                    # Посчитаем сумму
la t2, array
mv t0, t3
go_in_array_and_sum:
lw a3, (t2)
li a1, 2147483647
li a2, -2147483648
sub a1, a1, a3
sub a2, a2, a3
j check_overflow                  # На каждом шаге будем проверять на переполнение
go_in_array_and_sum_continue:
add t6, a3, t6
addi t0, t0, -1
addi t2, t2, 4
bgtz t0, go_in_array_and_sum
j end



check_overflow:                     
bgtz a1, check_overflow_max         # Проверяет, произошло ли переполнение
bltz a2, check_overflow_min
j go_in_array_and_sum_continue

check_overflow_max:                 # Проверяет, произошло ли переполнение сверху
bgt t6, a1, ERROR_sum_overflow
j go_in_array_and_sum_continue

check_overflow_min:                 # Проверяет, произошло ли переполнение снизу
bgt a2, t6, ERROR_sum_overflow
j go_in_array_and_sum_continue




ERROR_wrong_array_size:             # Если неправильный размер
#============
li a7, 4
la a0, ERROR_wrong_array_size_msg
ecall
#============
j end



ERROR_sum_overflow:                     # Если переполнение
#============
li a7, 4
la a0, ERROR_sum_overflow_msg
ecall
#============
j end



end:                                     # В конце вывести сумму
#============
li a7, 4
la a0, sum_msg
ecall
#============
li a7, 1
mv a0, t6
ecall
