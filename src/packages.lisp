(defpackage #:completion-candidates
  (:use #:cl)
  (:shadow #:sort)
  (:export
   #:candidates-for
   #:score
   #:sort
   #:completion-backend
   #:levenshtein-completion-backend))
