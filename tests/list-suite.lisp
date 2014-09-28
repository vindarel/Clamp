(in-package :clamp-tests)

(defsuite list (clamp))

(deftest range (list)
  (assert-equal '(1 2 3 4 5) (range 1 5))
  (assert-equal '(5) (range 5 5))
  (assert-equal '() (range 5 4))
  (assert-equal '(2 4 6 8 10) (range 2 10 2))
  (assert-equal '(1 3 5 7 9) (range 1 10 2)))

(deftest firstn (list)
  (assert-equal '(1 2 3) (firstn 3 (range 1 5)))
  (assert-equal nil (firstn 0 (range 1 5)))
  (assert-equal (range 1 5) (firstn nil (range 1 5)))
  (assert-equal (range 1 5) (firstn 10 (range 1 5)))
  (assert-equal (range 1 5) (firstn 5 (vector 1 2 3 4 5 6 7 8)))
  (assert-equal (range 1 5) (firstn 10 (vector 1 2 3 4 5))))

(deftest split (list)
  (assert-equal '(() ()) (mvl (split '() 0)))
  (assert-equal '(() (a b c)) (mvl (split '(a b c) 0)))
  (assert-equal '((a) (b c)) (mvl (split '(a b c) 1)))
  ;; Same tests but for vectors.
  (assert-equalp '(#() #()) (mvl (split #() 0)))
  (assert-equalp '(#() #(a b c)) (mvl (split #(a b c) 0)))
  (assert-equalp '(#(a) #(b c)) (mvl (split #(a b c) 1))))

(deftest group (list)
  (assert-equal '() (group '()))
  (assert-equal '() (group '() :by 3))
  (assert-equal '() (group '() :with #'+))
  (assert-equal '((1 2) (3 4)) (group '(1 2 3 4)))
  (assert-equal '((1 2) (3 4) (5)) (group (range 1 5)))
  (assert-equal '((1 2 3) (4 5)) (group (range 1 5) :by 3))
  (assert-equal '(6 9) (group (range 1 5) :by 3 :with #'+))
  (assert-equal '(3 7 11) (group (range 1 6) :with #'+)))

(deftest last1 (list)
  (assert-eql 10 (last1 (range 1 10)))
  (assert-eql 'c (last1 '(a b c))))

(deftest flat (list)
  (assert-equal (range 1 5) (flat '(((1) 2) (3 4) 5)))
  (assert-equal (range 1 5) (flat (range 1 5)))
  (assert-equal (range 1 5) (flat '(((1 2 3 4 5))))))

(deftest len< (list)
  (assert-true  (len< '(1 2 3) 4))
  (assert-false (len< '(1 2 3) 3)
  (assert-false (len< '(1 2 3) 2))))

(deftest len> (list)
  (assert-true  (len> '(1 2 3) 2))
  (assert-false (len> '(1 2 3) 3))
  (assert-false (len> '(1 2 3) 4)))

(deftest n-of (list)
  (assert-equal '(1 1 1) (n-of 3 1))
  (let x 0
    (assert-equal (range 1 5) (n-of 5 (incf x)))))

(deftest drain (list)
  (assert-equal '((1 2) (3 4))
		(w/instring in "(1 2) (3 4)"
		  (drain (read :from in :eof nil))))
  (assert-equal '(128 64 32 16 8 4 2)
		(let x 256
		  (drain (= x (/ x 2)) 1)))
  (assert-equal '(100 50)
                (let x 200
                  (drain (= x (/ x 2)) #'odd))))

(deftest caris (list)
  (assert-false (caris 5 5))
  (assert-false (caris '(1 2 3) 2))
  (assert-true  (caris '(1 2 3) 1)))

(deftest carif (list)
  (assert-eql 5 (carif 5))
  (assert-eql 1 (carif '(1 2 3))))

(deftest consif (list)
  (assert-equal '(1 2 3) (consif 1 '(2 3)))
  (assert-equal '(2 3)   (consif nil '(2 3))))

(deftest conswhen (list)
  (assert-equal '(1 2 3) (conswhen #'idfn 1 '(2 3)))
  (assert-equal '(2 3)   (conswhen #'even 1 '(2 3)))
  (assert-equal '(1 2 3) (conswhen #'odd  1 '(2 3))))

(deftest cars (list)
  (assert-equal '() (cars '()))
  (assert-equal '(1 4 7) (cars '((1 2 3) (4 5 6) (7 8 9)))))

(deftest cdrs (list)
  (assert-equal '() (cdrs '()))
  (assert-equal '((2 3) (5 6) (8 9)) (cdrs '((1 2 3) (4 5 6) (7 8 9)))))
