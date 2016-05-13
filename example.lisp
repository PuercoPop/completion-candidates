(defpackage "PATH-COMPLETION"
  (:use #:cl #:completion-candidates #:iolib)
  (:import-from #:split-sequence #:split-sequence)
  (:shadowing-import-from #:completion-candidates #:sort)
  (:documentation "Get candidates for programms in $PATH.

- Setup the cache to clear with iolib system monitoring.
"))

(in-package #:path-completion)

(defclass path-completion (levenshtein-completion-backend)
  ((directories :initarg :directories
                :initform (split-sequence #\: (uiop:getenv "PATH"))
                :reader path-directories
                :documentation "The directories from which to collect the candidates from.")))

(defun make-path-completion (&optional directories)
  (if directories
      (make-instance 'path-completion :directories directories)
      (make-instance 'path-completion)))

(defmethod candidates-for (pattern (backend path-completion))
  "Return a list containing all the (executable?) files found in the
  PATH-DIRECTORIES of the BACKEND."
  (declare (ignore pattern))
  (alexandria:mappend #'uiop:directory-files
                    (split-sequence:split-sequence #\:
                                                   (uiop:getenv "PATH"))))
