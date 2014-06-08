;;;; These are macros which allow allow for different kinds of fns

(in-package "CLAMP")

(defmacro rfn (name parms &body body)
  "Creates a recursive function which can refer to itself through name"
  `(labels ((,name ,parms ,@body))
     #',name))

(defmacro afn (parms &body body)
  "Creates a recursive function which can refer to itself through 'self'"
  `(rfn self ,parms ,@body))
