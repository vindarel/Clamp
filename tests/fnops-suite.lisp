(in-package :clamp-tests)

(defsuite fnops (clamp))

(deftest compose (fnops)
  (assert-eql 5 (call (compose #'1+ #'length) '(1 2 3 4)))
  (assert-equal '(5) (call (compose #'list #'1-) 6)))

(deftest fif (fnops)
  (assert-eql 5 (call (fif) 5))
  (assert-eql 6 (call (fif #'odd #'1+ #'1-) 5))
  (assert-eql 5 (call (fif #'odd #'1+ #'1-) 6))
  (assert-eql 0 (call (fif #'plusp #'1+ #'minusp #'1-) 0))
  (assert-eql 2 (call (fif #'plusp #'1+ #'minusp #'1-) 1))
  (assert-eql -2 (call (fif #'plusp #'1+ #'minusp #'1-) -1)))

(deftest andf (fnops)
  (assert-true  (call (andf #'integerp #'even) 4))
  (assert-false (call (andf #'integerp #'even) 3.5))
  (assert-false (call (andf #'integerp #'even) 3))
  (assert-eql 5 (call (andf #'integerp #'even #'1+) 4))
  (assert-true  (call (andf #'> #'multiple) 10 5)))

(deftest orf (fnops)
  (assert-true  (call (orf #'even #'plusp) 4))
  (assert-true  (call (orf #'even #'plusp) 3))
  (assert-true  (call (orf #'even #'plusp) -2))
  (assert-false (call (orf #'even #'plusp) -3))
  (assert-false (call (orf #'> #'<) 5 5)))

(deftest curry (fnops)
  (assert-eql 15 (call (curry #'+ 5) 10))
  (assert-eql 75 (call (curry #'+ 5 10 15) 20 25))
  (assert-eql 55 (call (curry #'reduce #'+) (range 1 10))))

(deftest rcurry (fnops)
  (assert-eql 15 (call (rcurry #'+ 5) 10))
  (assert-eql 75 (call (rcurry #'+ 5 10 15) 20 25))
  (assert-eql 55 (call (rcurry #'reduce (range 1 10)) #'+)))