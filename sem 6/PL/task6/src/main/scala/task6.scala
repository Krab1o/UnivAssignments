import collection.mutable.Map

def pack[T](xs: List[T]): List[List[T]] = {
  var ans: List[List[T]] = List()
  var count = 1
  for (i <- 1 until xs.length) {
    if (xs(i) == xs(i - 1))
      count += 1
    else {
      ans = ans :+ List.fill(count)(xs(i - 1))
      count = 1
    }
  }
  ans = ans :+ List.fill(count)(xs.last)
  ans
}

@main
def task1(): Unit = {
  println(pack(List('a', 'a', 'k', 'k', 'c', 'c')))
  println(pack(List(1, 2, 2, 3, 1, 1, 4)))
  println(pack(List("aa", "a", "b", "b", "b", "c", "k")))
}

def encode_t2[T] (xs: List[T]): List[(T, Int)] = {
  var ans: List[(T, Int)] = List()
  var count = 1
  for (i <- 1 until xs.length) {
    if (xs(i) == xs(i - 1))
      count += 1
    else {
      ans = ans :+ (xs(i - 1), count)
      count = 1
    }
  }
  ans = ans :+ (xs.last, count)
  ans
}

@main
def task2(): Unit = {
  println(encode_t2(List('a', 'a', 'k', 'k', 'c', 'c')))
  println(encode_t2(List(1, 2, 2, 3, 1, 1, 4)))
  println(encode_t2(List("aa", "a", "b", "b", "b", "c", "k")))
}

def encode_t3[T] (xs: List[T]): List[(T, Int)] = {
  var map: Map[T, Int] = Map()
  for (it <- xs) {
    if (!map.isDefinedAt(it))
      map = map + (it -> 1)
    else
      map.update(it, map(it) + 1)
  }
  map.toList
}

@main
def task3(): Unit = {
  println(encode_t3(List('a', 'a', 'k', 'k', 'c', 'c')))
  println(encode_t3(List(1, 2, 2, 3, 1, 1, 4)))
  println(encode_t3(List("aa", "a", "b", "b", "b", "c", "b")))
}