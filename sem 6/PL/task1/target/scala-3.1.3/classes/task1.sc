import scala.math.sqrt
import math.max

def square(x: Double) = x * x

//task1
3 - square(sqrt(3))

//task2
"csit"*3

//task3
//max определено в классе RichInt
10 max 2

//task4
BigInt(2) pow 1024

//task5
import BigInt.probablePrime
import util.Random
//Метод возвращает положительное вероятно простое число
//класса BigInt с указанным занимаемым размером числа в битах
probablePrime(100, Random)

//task6
val str = "test1csitfaculty"
//Первый символ
str.head
str(0)
//Последний символ
str.last
str(str.length - 1)

//task7
//Метод take(n) выбирает первые n элементов в коллекции
str.take(2)
//Метод drop(n) выбирает все элементы кроме первых n
str.drop(6)
//Метод takeRight(n) выбирает первые n элементов справа
str.takeRight(7)
//Метод dropRight(n) выбирает все элементы кроме последних n
str.dropRight(7)