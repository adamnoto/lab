abstract class IntSet {
  def incl(x: Int): IntSet
  def contains(x: Int): Boolean
  //def union(other: IntSet): IntSet
}

object Empty extends IntSet {
  override def contains(x: Int): Boolean = false
  override def incl(x: Int): IntSet = new NonEmpty(x, Empty, Empty)
  override def toString: String = "."
  //override def union(other: IntSet): IntSet = other
}

class NonEmpty(elem: Int, left: IntSet, right: IntSet) extends IntSet {
  override def contains(x: Int): Boolean = {
    if (x < elem) left contains x
    else if (x > elem) right contains x
    else true
  }

  override def incl(x: Int): IntSet = {
    if (x < elem) new NonEmpty(elem, left incl x, right)
    else if (x > elem) new NonEmpty(elem, left, right incl x)
    else this
  }

  override def toString: String = "{" + left + elem + right + "}"
}

trait List[T] {
  def isEmpty: Boolean
  def head: T
  def tail: List[T]
}

class Cons[T](val head: T, val tail: List[T]) extends List[T] {
  override def isEmpty: Boolean = false
}

class Nil[T] extends List[T] {
  override def isEmpty: Boolean = true
  override def head: Nothing = throw new NoSuchElementException("Nil.head")
  override def tail: Nothing = throw new NoSuchElementException("Nil.tail")
}

def singleton[T](elem: T): List[T] = new Cons[T](elem, new Nil[T])

val t1 = new NonEmpty(3, Empty, Empty)
val t2 = t1 incl 4

val intList = singleton[Int](1)
var boolList = singleton(true)
