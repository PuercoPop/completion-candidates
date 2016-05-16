;;;;    Copyright Javier Olaechea 2016
;;;;
;;;;    This program is free software: you can redistribute it and/or modify it
;;;;    under the terms of the GNU Affero General Public License as published
;;;;    by the Free Software Foundation, either version 3 of the License, or
;;;;    (at your option) any later version.
;;;;
;;;;    This program is distributed in the hope that it will be useful, but
;;;;    WITHOUT ANY WARRANTY; without even the implied warranty of
;;;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;;;    Affero General Public License for more details.
;;;;
;;;;    You should have received a copy of the GNU Affero General Public
;;;;    License along with this program.  If not, see
;;;;    <http://www.gnu.org/licenses/>

(defpackage "PATH-COMPLETION"
  (:use #:cl #:completion-candidates #:iolib)
  (:import-from #:split-sequence #:split-sequence)
  (:shadowing-import-from #:completion-candidates #:sort)
  (:documentation "Get candidates for programms in $PATH.

- Setup the cache to clear with iolib system monitoring.
"))

(in-package #:path-completion)

(defclass path-completion (jaro-completion-backend)
  ((directories :initarg :directories
                :initform (split-sequence #\: (uiop:getenv "PATH"))
                :reader path-directories
                :documentation "The directories from which to collect the candidates from.")))

(defun make-path-completion (&optional directories)
  (if directories
      (make-instance 'path-completion :directories directories)
      (make-instance 'path-completion)))

(defmethod candidates-for append (pattern (backend path-completion))
  "Return a list containing all the (executable?) files found in the
  PATH-DIRECTORIES of the BACKEND."
  (declare (ignore pattern))
  (mapcar #'file-namestring
          (alexandria:mappend #'uiop:directory-files
                              (split-sequence:split-sequence #\:
                                                             (uiop:getenv "PATH")))))
