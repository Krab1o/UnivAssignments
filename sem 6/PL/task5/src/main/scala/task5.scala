import scala.util._
import scala.io.StdIn._
import scala.collection._

import scala.util.Sorting
import scala.collection.immutable

//TASK 1
def insertionSort[T](list: List[T])(implicit ord: Ordering[T]): List[T] = {
  import ord._

  def insert(x: T, xs: List[T]): List[T] = xs match {
    case Nil => List(x)
    case xsHead :: xsTail if x <= xsHead => x :: xs
    case xsHead :: xsTail => xsHead :: insert(x, xsTail)
  }

  list match {
    case Nil => Nil
    case head :: tail => insert(head, insertionSort(tail))
  }
}
@main def task1(): Unit = {
  //Ints
  val unsortedListInt = List(5, 2, 4, 6, 1, 3)
  val sortedListInt = insertionSort(unsortedListInt)
  println("Unsorted list: " + unsortedListInt)
  println("Sorted list: " + sortedListInt)
  //Doubles
  val unsortedListDouble = List(5.0, 2.3, 4.7, 4.6, 6.343, 3.077)
  val sortedListDouble = insertionSort(unsortedListDouble)
  println("Unsorted list: " + unsortedListDouble)
  println("Sorted list: " + sortedListDouble)
  //Strings
  val unsortedListString = List("aa", "bcd", "ab", "Ab", "cd", "0dfff")
  val sortedListString = insertionSort(unsortedListString)
  println("Unsorted list: " + unsortedListString)
  println("Sorted list: " + sortedListString)
}

//TASK 2
def findKthStatistic(arr: Array[Int], k: Int): Int = {
  if (k > 0 && k <= arr.length) {
    val pivotIndex = Random.nextInt(arr.length)
    val pivot = arr(pivotIndex)

    var (left, middle, right) = (Array[Int](), Array[Int](), Array[Int]())

    for (elem <- arr) {
      if (elem < pivot) {
        left :+= elem
      } else if (elem == pivot) {
        middle :+= elem
      } else {
        right :+= elem
      }
    }

    val leftSize = left.length
    val middleSize = middle.length

    if (k <= leftSize) {
      findKthStatistic(left, k)
    } else if (k <= leftSize + middleSize) {
      pivot
    } else {
      findKthStatistic(right, k - leftSize - middleSize)
    }
  } else {
    throw new IllegalArgumentException("Invalid k value")
  }
}
@main def task2(): Unit = {
  println(findKthStatistic(Array(3, 8, 1, 12, 23), 3))
  println(findKthStatistic(Array(6, 5, 8, 51, 5, 42, 1, 5), 4))
  println(findKthStatistic(Array(81, -3, 9, 5, 3, 53, 9, 3), 5))
}

//TASK 3
def sieve(stream: LazyList[Int]): LazyList[Int] = {
  stream.head #:: sieve(stream.tail.filter(_ % stream.head != 0))
}

@main def task3(): Unit = {
  val primes = sieve(LazyList.from(2))
  val a = readInt()
  val primeNumbers = primes.dropWhile(_ <= a)
  primeNumbers.take(10).foreach(println)
}


//TASK 4
type Point = (Int, Int)
type Ship = List[Point]
type Field = Vector[Vector[Boolean]]

class ShipExists(s:String) extends Exception(s){}

def addShip(field: Field, ship: Ship): Field = {
  ship.foldLeft(field) { (updatedField, point) =>
    val (x, y) = point
    if (updatedField(x)(y)) {
      throw new ShipExists(s"There is a ship already in ($x, $y)!")
    }
    updatedField.updated(x, updatedField(x).updated(y, true))
  }
}

@main def task4(): Unit = {
  val initialField: Field = Vector.fill(10, 10)(false)
  val ship1: Ship = List((4, 4), (5, 7), (5, 6), (5, 9))
  val ship2: Ship = List((4, 9), (6, 9))
  var updatedField = addShip(initialField, ship1)
  updatedField = addShip(updatedField, ship2)

  // Вывод поля
  updatedField.foreach(row => println(row.mkString(" ")))
}

