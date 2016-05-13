(in-package #:asdf-user)

(defsystem #:completion-candidates
  :name "completion-candidates"
  :depends-on (#:vas-string-metrics)
  :pathname "src/"
  :components ((:file "packages")
               (:file "core")
               (:file "levenshtein-completion")))
