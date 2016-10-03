;; A Container for symbol results
(in-package #:completion-candidates)

(defclass symbol-candidate (candidate)
  ()
  (:documentation "A result container for the resulting symbol."))

(defgeneric symbol-candidate-name (candidate)
  (:documentation "Return the SYMBOL-NAME of the CANDIDATE.")
  (:method ((obj symbol-candidate))
     (symbol-name (candidate obj))))

(defgeneric symbol-candidate-package (candidate)
  (:documentation "Return the home package of the CANDIDATE.")
  (:method ((obj symbol-candidate))
    (symbol-package (candidate obj))))

(defmethod print-object ((obj symbol-candidate) stream)
  ;; Print a readable symbol?
  (print-unreadable-object (ob stream :type t)
    (format stream "~A" (candidate-string obj))))

(defun make-symbol-candidate (symbol score)
   (make-instance 'symbol-candidate
                 :candidate symbol
                 :score score))

(defmethod candidate-string ((obj symbol-candidate))
  "Return the name of the symbol."
  (symbol-candidate-name obj))
