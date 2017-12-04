package recfun

object Main {
  def main(args: Array[String]) {
    println("Pascal's Triangle")
    for (row <- 0 to 10) {
      for (col <- 0 to row)
        print(pascal(col, row) + " ")
      println()
    }
  }

  /**
   * Exercise 1
   */
    def pascal(c: Int, r: Int): Int = {
      if (r == 0) return 1
      else if (c == 0) return 1
      else if (r == c) return 1
      else {
        val a = pascal(c - 1, r-1)
        val b = pascal(c, r-1)
        print(a, b)
        return a + b
      }
    }
  
  /**
   * Exercise 2
   */
    def balance(chars: List[Char]): Boolean = {
      def isBalanced(currentChar: Char, chars: List[Char], openCount: Int): Boolean = {
        var newOpenCount = openCount

        if (currentChar == '(') newOpenCount = newOpenCount + 1
        else if (currentChar == ')') newOpenCount = newOpenCount - 1

        if (openCount < 0) return false
        else {
          if (chars.isEmpty) return newOpenCount == 0
          else return isBalanced(chars.head, chars.tail, newOpenCount)
        }
      }

      return isBalanced(chars.head, chars.tail, 0)
    }
  
  /**
   * Exercise 3
   */
    def countChange(money: Int, coins: List[Int]): Int = {
      if (money < 0) return 0
      else if (coins.isEmpty) return 0
      else if (money == 0) return 1
      else return countChange(money, coins.tail) + countChange(money - coins.head, coins)
    }
  }
