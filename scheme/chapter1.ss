#lang racket
(+ 2 2 3 58 67)

(define (square x) (* x x))

(square 21)

(square (+ 2 5))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(sum-of-squares 3 4)

(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)

(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

(abs -3)

(define (>= x y)
  (or (> x y) (= x y)))

(>= 12 2)

(define (max a b)
  (cond ((= a b) a)
        ((> a b) a)
        ((> b a) b)))

(define (min a b)
  (cond ((= a b) a)
        ((> a b) b)
        ((> b a) a)))

(max 2 5)
(max 5 2)
(max 5 5)
(min 2 5)
(min 5 2)
(min 2 2)

; challenging! sum square of 3 args only using cond
(define (sqsumuniq a b c)
  (define mostmin (min a (min b c)))
  (+ (square (if (= mostmin a) 0 a))
     (square (if (= mostmin b) 0 b))
     (square (if (= mostmin c) 0 c))))

(sqsumuniq 2 5 8) ; 25 + 64 = 89
(sqsumuniq 1 3 2) ; 9 + 4 = 13
(sqsumuniq 5 2 3) ; 25 + 9 = 34

(define (sqrt x)
  (define (average a b)
    (/ (+ a b) 2))
  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess x)
    (average guess (/ x guess)))
  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))
  (sqrt-iter 1.0 x))
(sqrt 9)

;; FACTORIAL

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))
(define (factorial-tail n)
  (define (fact-iter product counter max-count)
    (if (> counter max-count)
        product
        (fact-iter (* counter product)
                   (+ counter 1)
                   max-count)))
  (fact-iter 1 1 n))
(factorial 5)
(factorial-tail 5)

;; FIBONACI

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))
(define (fib-tail n)
  (define (fib-iter a b count)
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))
(fib 6)
(fib-tail 6)

;; COIN CHANGES

(define (count-change amount)
  (define (denomination kind-of-coin)
    (cond ((= kind-of-coin 1) 1)
          ((= kind-of-coin 2) 5)
          ((= kind-of-coin 3) 10)
          ((= kind-of-coin 4) 25)
          ((= kind-of-coin 5) 50)))
  (define (cc-iter amount kind-of-coins)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (= kind-of-coins 0)) 0)
          (else (+ (cc-iter amount
                            (- kind-of-coins 1))
                   (cc-iter (- amount
                               (denomination kind-of-coins))
                            kind-of-coins)))))
  (cc-iter amount 5))
(count-change 100)

;; A function f is defined by the rule that f(n) = n if n < 3
;; and f(n) = f(n-1)+2f(n-2)+3f(n-3) if n>=3.

(define (f3 n)
  (cond ((< n 3) n)
        (else (+ (f3 (- n 1))
                 (* (f3 (- n 2)) 2)
                 (* (f3 (- n 3)) 3)))))
(define (f3-tail n)
  (define (iter acc n)
    (cond ((< n 3) n)
          (else (+ (iter 0 (- n 1))
                   (* (iter 0 (- n 2)) 2)
                   (* (iter 0 (- n 3)) 3)))))
  (iter 0 n))

(println "F3")
(f3 4) ; 11
(f3-tail 4)

;; Pascal

(println "PASCAL")
(define (pascal-sum row)
  (define (n-at row col)
    (cond ((= row 1) 1)
          ((= col 1) 1)
          ((= col row) 1)
          (else (+ (n-at (- row 1) (- col 1))
                   (n-at (- row 1) col)))))
  (define (iter acc row col)
    (cond ((> col row) acc)
          (else (iter (+ (n-at row col) acc) row (+ col 1)))))
  (iter 0 row 1))

(pascal-sum 3)
(pascal-sum 4)

;; GCD

(define (gcd a b)
  (if (= b 0) a
      (gcd b (remainder a b))))
(println "GCD")
(gcd 12 3)
(gcd 928 328)

;; PRIME, this algorithm has O(sqrt(n)) growth since it only need to test
;; divisor between 1 and sqrt(n)

(define (prime? n)
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))
  (define (smallest-divisor n)
    (find-divisor n 2))
  (= n (smallest-divisor n)))
(prime? 3)
(prime? 5)
(prime? 6)
(prime? 18)