import scala.collection._

//TASK 1

def insertionSort[T](list: List[T])(implicit ord: Ordering[T]): List[T] = {
  import ord._
  def insert(x: T, xs: List[T]): List[T] = xs match {
    case Nil => List(x)
    case head :: tail if x <= head => x :: xs
    case head :: tail => head :: insert(x, tail)
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

// Function to generate an infinite lazy stream of prime numbers starting from 'a'
def primesFrom(a: Int): LazyList[Int] = {
  def sieve(stream: LazyList[Int]): LazyList[Int] = {
    stream.head #:: sieve(stream.tail.filter(_ % stream.head != 0))
  }

  def primes: LazyList[Int] = sieve(LazyList.from(2))
}

@main def main(): Unit = {
  val a = 10 // Change this to any starting number
  val primeStream = primesFrom(a)

  // Print the first 10 prime numbers starting from 'startingNumber'
  primeStream.take(10).foreach(println)
}

