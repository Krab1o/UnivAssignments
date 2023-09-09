fun square_formula 
          ( x1 : real, y1 : real
          , x2 : real, y2 : real
          , x3 : real, y3 : real)
          : real =
  let 
    fun dots_distance
      ( x1 : real, y1 : real
      , x2 : real, y2 : real) 
      : real = 
      Math.sqrt( (x1 - x2) * (x1 - x2)
               + (y1 - y2) * (y1 - y2))

    val side1 = dots_distance(x1, y1, x2, y2)
    val side2 = dots_distance(x2, y2, x3, y3)
    val side3 = dots_distance(x3, y3, x1, y1)
    val halfPerimeter = (side1 + side2 + side3) / 2.0
  in
    Math.sqrt(halfPerimeter * (halfPerimeter - side1) 
                             * (halfPerimeter - side2) 
                             * (halfPerimeter - side3))
  end

val test1 = square_formula(0.0, 0.0, 0.0, 5.0, 5.0, 5.0)


