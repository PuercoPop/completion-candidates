(in-package #:completion-candidates)

(defclass levenshtein-completion-backend (completion-backend)
  ()
  (:documentation "Score the candidates according the levenshtein distance."))

(defmethod score ((candidate string) (pattern string) (backend levenshtein-completion-backend))
  ""
  (vas-string-metrics:normalized-levenshtein-distance candidate pattern))
