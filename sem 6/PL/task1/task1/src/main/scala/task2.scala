import scala.util._
import scala.io.StdIn._
import scala.util.matching.Regex

object task2 {
  //task 1.1
  @main def task1_1(): Unit = {
    val str = readLine().split(" ")
    if (str.length != 3)
      throw new IllegalArgumentException("Неправильный формат ввода")
    val arg1 = Try(str.head.toDouble)
    val arg2 = Try(str.last.toDouble)

    (arg1, arg2) match {
      case(Success(arg1), Success(arg2)) =>
        println (str(1) match {
                    case "+" => arg1 + arg2
                    case "-" => arg1 - arg2
                    case "*" => arg1 * arg2
                    case "/" => if (arg2 == 0) throw new ArithmeticException("Деление на ноль")
                      else arg1 / arg2
                    case _ => throw new IllegalArgumentException("Неверная операция")
        })
      case _ => throw new IllegalArgumentException("Введены неверные числовые значения")
    }
  }
  //task 2.1
  def task2_1(): Unit = {
    val str = readLine()
    var s = 0
    for (x <- str) {
      if (x.isDigit)
        s += x.toInt - '0'.toInt
    }
    println(s)
  }
  //task 2.2
  def task2_2(): Unit = {
    val str = readLine()
    var s: BigInt = 1
    for (x <- str) {
      s *= x.toInt
    }
    println(s)
  }
  //task 2.3
  def task2_3(): Unit = {
    val N = readInt()
    for (i <- 1 to N) {
      for (j <- 1 to i) {
        print(s"$j ")
      }
      println()
    }
  }
  //task 2.4
  @main def task2_4(): Unit = {
    val rand = Random
    val secret = rand.nextInt(100) + 1
    var guess = 0
    while (guess != secret) {
      guess = readInt()
      if (guess > secret)
        println("Ваше число больше загаданного!")
      else if (guess < secret)
        println("Ваше число меньше загаданного!")
      else println(s"Вы угадали! Это число $secret")
    }
  }

  //task 3.1
    def task3_1(args: Array[String]): Unit = {
      val carNumberPattern: Regex = "[А-Яа-я][0-9]{3}[А-Яа-я]{2}".r
      val input = readLine("Введите номер: ")
      if (carNumberPattern.matches(input)) println("Номер соответствует автомобильному")
      else println("Номер не соответствует автомобильному")
    }

  //task 3.2
    def task3_2(args: Array[String]): Unit = {
      val hasUppercase = ".*[A-Z].*".r
      val hasLowercase = ".*[a-z].*".r
      val hasDigit = ".*[0-9].*".r
      val hasSpecialChar = ".*[!@#$%^&*()].*".r
      val hasEightChars = ".{8,}".r
      val input = readLine("Введите пароль: ")
      val boolPass = hasUppercase.matches(input) && hasLowercase.matches(input) &&
          hasDigit.matches(input) && hasSpecialChar.matches(input) && hasEightChars.matches(input)
      if (boolPass) println("Да")
       else println("Нет")
    }

  //task 3.3
  def task3_3(args: Array[String]): Unit = {
    val carNumberPattern: Regex = "\\d{2}\\.\\d{2}\\.\\d{4}".r
    val input = readLine("Введите дату: ")
    if (carNumberPattern.matches(input)) println("Да")
    else println("Нет")
  }
}
