package funsets

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class FunSetSuite extends FunSuite {

  /**
   * Link to the scaladoc - very clear and detailed tutorial of FunSuite
   *
   * http://doc.scalatest.org/1.9.1/index.html#org.scalatest.FunSuite
   *
   * Operators
   *  - test
   *  - ignore
   *  - pending
   */

  /**
   * Tests are written using the "test" operator and the "assert" method.
   */
  // test("string take") {
  //   val message = "hello, world"
  //   assert(message.take(5) == "hello")
  // }

  /**
   * For ScalaTest tests, there exists a special equality operator "===" that
   * can be used inside "assert". If the assertion fails, the two values will
   * be printed in the error message. Otherwise, when using "==", the test
   * error message will only say "assertion failed", without showing the values.
   *
   * Try it out! Change the values so that the assertion fails, and look at the
   * error message.
   */
  // test("adding ints") {
  //   assert(1 + 2 === 3)
  // }


  import FunSets._

  test("contains is implemented") {
    assert(contains(x => true, 100))
  }

  /**
   * When writing tests, one would often like to re-use certain values for multiple
   * tests. For instance, we would like to create an Int-set and have multiple test
   * about it.
   *
   * Instead of copy-pasting the code for creating the set into every test, we can
   * store it in the test class using a val:
   *
   *   val s1 = singletonSet(1)
   *
   * However, what happens if the method "singletonSet" has a bug and crashes? Then
   * the test methods are not even executed, because creating an instance of the
   * test class fails!
   *
   * Therefore, we put the shared values into a separate trait (traits are like
   * abstract classes), and create an instance inside each test method.
   *
   */

  trait TestSets {
    val s1 = singletonSet(1)
    val s2 = singletonSet(2)
    val s3 = singletonSet(3)
  }

  /**
   * This test is currently disabled (by using "ignore") because the method
   * "singletonSet" is not yet implemented and the test would fail.
   *
   * Once you finish your implementation of "singletonSet", exchange the
   * function "ignore" by "test".
   */
  test("singletonSet(1) contains 1") {

    /**
     * We create a new instance of the "TestSets" trait, this gives us access
     * to the values "s1" to "s3".
     */
    new TestSets {
      /**
       * The string argument of "assert" is a message that is printed in case
       * the test fails. This helps identifying which assertion failed.
       */
      assert(contains(s1, 1), "Singleton")
    }
  }

  test("union contains all elements of each set") {
    new TestSets {
      val s = union(s1, s2)
      assert(contains(s, 1), "Union 1")
      assert(contains(s, 2), "Union 2")
      assert(!contains(s, 3), "Union 3")
    }
  }

  test("intersection contains element that is both in the set") {
    new TestSets {
      val s = union(s1, s2)
      assert(contains(intersect(s, s1), 1))
      assert(contains(intersect(s, s2), 2))
      assert(!contains(intersect(s, s1), 3))
    }
  }

  test("difference returns all ements of s not in another set") {
    new TestSets {
      val sUni1 = union(s1, union(s2, s3))
      val sUni2 = union(s2, s3)
      val sDiff = diff(sUni1, sUni2)
      assert(contains(sDiff, 1))
      assert(!contains(sDiff, 2))
      assert(!contains(sDiff, 3))
    }
  }

  test("filter returns subset for which the function holds") {
    new TestSets {
      val sUnion = union(s1, union(s2, s3))
      val sFiltered = filter(sUnion, x => x > 2)
      assert(contains(sFiltered, 3))
      assert(!contains(sFiltered, 2))
      assert(!contains(sFiltered, 1))
    }
  }

  test("forall returns boolean true if all bounded integer within s satisfy the function") {
    new TestSets {
      val sUnion = union(s1, union(s2, s3))
      assert(forall(sUnion, x => x > 0))
      assert(!forall(sUnion, x => x > 1))
    }
  }

  test ("exists returns boolean true if there exist a bounded integer within s that satisfy the function") {
    new TestSets {
      val sUnion = union(s1, union(s2, s3))
      assert(exists(sUnion, x => x == 1))
      assert(exists(sUnion, x => x == 2))
      assert(exists(sUnion, x => x == 3))
      assert(!exists(sUnion, x => x > 3))
      assert(!exists(sUnion, x => x < 1))
    }
  }

  test ("map returns a transformed set") {
    new TestSets {
      var sUnion = union(s1, union(s2, s3))
      sUnion = map(sUnion, x => x + 1)
      assert(contains(sUnion, 2))
      assert(contains(sUnion, 3))
      assert(contains(sUnion, 4))
      assert(!contains(sUnion, 1))
      assert(!contains(sUnion, 5))
      assert(!contains(sUnion, 0))

      var setWithBound = union(s1, singletonSet(1000))
      setWithBound = map(setWithBound, x => x * 2)
      assert(contains(setWithBound, 2))
      assert(contains(setWithBound, 2000))
    }
  }
}
