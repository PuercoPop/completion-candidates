(in-package #:asdf-user)

(defsystem #:completion-candidates
  :name "completion-candidates"
  :licence "AGPL3"
  :depends-on (#:vas-string-metrics)
  :pathname "src/"
  :components ((:file "packages")
               (:file "core")
               (:file "levenshtein-completion")
               (:file "jaro-completion")
               (:file "symbol-candidate")))
