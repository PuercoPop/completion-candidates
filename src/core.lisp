(in-package #:completion-candidates)

(defgeneric candidates-for (pattern completion-backend)
  (:method-combination append)
  (:documentation "Return the list of candidates for PATTERN according the
  strategy provided by COMPLETION-BACKEND."))

(defgeneric score (candidate pattern completion-backend)
  (:documentation "Return a number between 0 and 1 ranking how well the
  CANDIDATE matches PATTERN. The higher the score the better the candidate."))

(defun sort (candidate-list pattern completion-backend)
  "Return the sorted CANDIDATE-LIST according the SCORE."
  (cl:stable-sort candidate-list
                  #'(lambda (candidate)
                      (score candidate pattern completion-backend))))


(defclass completion-backend ()
  ()
  (:documentation "The base class for all completion backends."))
