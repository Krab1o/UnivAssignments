import scala.util.*
import scala.io.StdIn.*
import scala.util.matching.Regex

//TASK 1
def weightChips(potato: BigInt, waterPotato: Double, waterChips: Double): String = {
  (potato.toDouble * (1 - waterPotato) / (1 - waterChips)).formatted("%.2f")
}

def weightChipsCurried: BigInt => Double => Double => String =
  potato => waterPotato => waterChips =>
    (potato.toDouble * (1 - waterPotato) / (1 - waterChips)).formatted("%.2f")

//TASK 2
def strToColDigits(str: String): Int = {
  var s = 0
  for (x <- str) {
    if (x.isDigit)
      s += 1
  }
  s
}

def strToSumDigits(str: String): Int = {
  var s = 0
  for (x <- str) {
    if (x.isDigit)
      s += x.toInt - '0'.toInt
  }
  s
}

def strToColAlpha(str: String): Int = {
  var s = 0
  for (x <- str) {
    if (x.isLetter)
      s += 1
  }
  s
}

def compareString(f: String => Int): (String, String) => Boolean = {
  (s1, s2) => f(s1) > f(s2)
}

//TASK3

def calculate(f: (Double, Double) => Double, a: Double, b: Double): Double = {
  f(a, b)
}

def sum(a: Double, b: Double): Double = {
  a + b
}

def sub(a: Double, b: Double): Double = {
  a - b
}

def mult(a: Double, b: Double): Double = {
  a * b
}

def div(a: Double, b: Double): Double = {
  if (b == 0) throw new ArithmeticException("Деление на ноль")
  a / b
}

//MAIN

@main def task1(): Unit = {
  //A
  val str = readLine().split(' ')
  println(weightChips(BigInt(str(0)), str(1).toDouble, str(2).toDouble))
  //B
  println(weightChips.curried(BigInt(str(0))))
  println(weightChips.curried(BigInt(str(0)))(str(1).toDouble))
  println(weightChips.curried(BigInt(str(0)))(str(1).toDouble)(str(2).toDouble))
  //C
  println(weightChipsCurried(BigInt(str(0))))
  println(weightChipsCurried(BigInt(str(0)))(str(1).toDouble))
  println(weightChipsCurried(BigInt(str(0)))(str(1).toDouble)(str(2).toDouble))
}

@main def task2(): Unit = {
  val str1 = readLine()
  val str2 = readLine()
  println(compareString(strToColDigits)(str1, str2))
  println(compareString(strToSumDigits)(str1, str2))
  println(compareString(strToColAlpha)(str1, str2))
}

@main def task3(): Unit = {
  val taskType = 3
  val str = readLine().split(" ")
  if (str.length != 3)
    throw new IllegalArgumentException("Неправильный формат ввода")
  val arg1 = Try(str.head.toDouble)
  val arg2 = Try(str.last.toDouble)


  taskType match {
    case 1 =>
      (arg1, arg2) match {
        case (Success(arg1), Success(arg2)) =>
          println(str(1) match {
            case "+" => calculate(sum, arg1, arg2)
            case "-" => calculate(sub, arg1, arg2)
            case "*" => calculate(mult, arg1, arg2)
            case "/" => calculate(div, arg1, arg2)
            case _ => throw new IllegalArgumentException("Неверная операция")
            })
        case _ => throw new IllegalArgumentException("Введены неверные числовые значения")
      }
    case 2 =>
      (arg1, arg2) match {
        case (Success(arg1), Success(arg2)) =>
          val part: PartialFunction[String, Double] = {
            case "+" => sum(arg1, arg2)
            case "-" => sub(arg1, arg2)
            case "*" => mult(arg1, arg2)
            case "/" => div(arg1, arg2)
          }
          println(part(str(1)))
        case _ => throw new IllegalArgumentException("Введены неверные числовые значения")
      }
    case 3 =>
      (arg1, arg2) match {
        case (Success(arg1), Success(arg2)) =>
          println(str(1) match {
            case "+" => calculate((x, y) => x + y, arg1, arg2)
            case "-" => calculate((x, y) => x - y, arg1, arg2)
            case "*" => calculate((x, y) => x * y, arg1, arg2)
            case "/" => calculate((x, y) =>
              if (y == 0) throw new ArithmeticException("Деление на ноль") else x / y, arg1, arg2)
            case _ => throw new IllegalArgumentException("Неверная операция")
          })
        case _ => throw new IllegalArgumentException("Введены неверные числовые значения")
      }
  }
}


