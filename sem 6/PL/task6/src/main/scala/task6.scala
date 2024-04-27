import collection.mutable.Map

def pack[T](xs: List[T]): List[List[T]] = xs match {
  case Nil => Nil
  case head :: tail =>
    val (packed, next) = tail.span(_ == head)
    (head :: packed) :: pack(next)
}

@main
def task1(): Unit = {
  println(pack(List('a', 'a', 'k', 'k', 'c', 'c')))
  println(pack(List(1, 2, 2, 3, 1, 1, 4)))
  println(pack(List("aa", "a", "b", "b", "b", "c", "k")))
}

def encode_t2[T](xs: List[T]): List[(T, Int)] = {
  if (xs.isEmpty) Nil
  else {
    val (packed, next) = xs.span(_ == xs.head)
    (xs.head, packed.length) :: encode_t2(next)
  }
}

@main
def task2(): Unit = {
  println(encode_t2(List('a', 'a', 'k', 'k', 'c', 'c')))
  println(encode_t2(List(1, 2, 2, 3, 1, 1, 4)))
  println(encode_t2(List("aa", "a", "b", "b", "b", "c", "k")))
}

def encode_t3[T] (xs: List[T]): List[(T, Int)] = {
  def encodeIter(xs: List[T], map: Map[T, Int]): List[(T, Int)] = {
    if (xs.isEmpty) map.toList
    else if (!map.isDefinedAt(xs.head))
      encodeIter(xs.tail, map + (xs.head -> 1))
    else {
      map.update(xs.head, map(xs.head) + 1)
      encodeIter(xs.tail, map)
    }
  }
  var map: Map[T, Int] = Map()
  encodeIter(xs, map)
}

@main
def task3(): Unit = {
  println(encode_t3(List('a', 'a', 'k', 'k', 'c', 'c')))
  println(encode_t3(List(1, 2, 2, 3, 1, 1, 4)))
  println(encode_t3(List("aa", "a", "b", "b", "b", "c", "b")))
}
