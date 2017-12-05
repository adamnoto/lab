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

(define (sqsumuniq a b c)
  (define mostmin (min a (min b c)))
  (+ (square (if (= mostmin a) 0 a))
     (square (if (= mostmin b) 0 b))
     (square (if (= mostmin c) 0 c))))

(sqsumuniq 2 5 8) ; 25 + 64 = 89
(sqsumuniq 1 3 2) ; 9 + 4 = 13
(sqsumuniq 5 2 3) ; 25 + 9 = 34

