import numpy as np

# task 1
# Сгенерировать матрицу размером 4 × 9, заполненную случайными целыми числами из отрезка [0,20] и вывести ее на на экран.
matrix = np.random.randint(low=0, high=21, size=(4, 9))
print("task 1")
print(matrix)
# task 2
# Вывести на экран элемент с индексами [2, 6].
print("task 2")
print(matrix[2, 6])
# task 3
# Вывести на экран столбец матрицы под номером 3.
print("task 3")
print(matrix[:, 2])
# task 4
# Вывести на экран каждый второй элемент третьей строки матрицы.
print("task 4")
print(matrix[2][1::2])
# task 5
# Вывести на экран элементы последнего столбца в обратном порядке.
print("task 5")
print(matrix[::-1, -1])
# task 6
# Изменить форму матрицы с 4 × 9 на 6 × 6.
print("task 6")
reshaped = matrix.reshape((6, 6))
print(reshaped)
# task 7
# Возвести каждый элемент матрицы в заданную степень.
print("task 7")
n = int(input("input power: "))
print(np.power(reshaped, n))
# task 8
# Найти минимум на главной диагонали.
print("task 8")
print(np.min(np.diag(reshaped)))
# task 9
# Найти максимальный элемент в предпоследнем столбце.
print("task 9")
print(np.max(reshaped[: , -2]))
# task 10
# Определить, образуют ли элементы сжатого до одной оси массива невозрастающую последовательность. Для этого задания обратите внимание на функции  diff и all из numpy
print("task 10")
is_non_increasing = np.all(np.diff(reshaped.flatten()) <= 0)
if (np.all(np.diff(reshaped.flatten()) <= 0) == True):
    print("Элементы образуют невозрастающую последовательность")
else:
    print("Элементы не образуют невозрастающую последовательность")
# task 11
# Подсчитать произведение ненулевых элементов на побочной диагонали.
print("task 11")
notzero= np.diagonal(reshaped[:, ::-1])
multi = np.prod(notzero[notzero != 0])
print("Произведение ненулевых элементов на побочной диагонали: ", multi)
# task 12
# Создать массив из случайных целых чисел из [-20, 20] размерностью 15.
print("task 12")
matrix_2 = np.random.randint(low=-20, high=21, size=(4, 9))
print(matrix_2)
# task 13
# Выведите только положительные элементы массива
print("task 13")
print(matrix_2[np.where(matrix_2 > 0)])
# task 14
# Посчитайте количество четных элементов в массиве
print("task 14")
print(matrix_2[matrix_2 % 2 == 0].size)
