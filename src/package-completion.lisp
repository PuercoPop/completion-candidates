;;;  Copyright Javier Olaechea 2016
;;
;;  This program is free software: you can redistribute it and/or modify it
;;  under the terms of the GNU Affero General Public License as published
;;  by the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful, but
;;  WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  Affero General Public License for more details.
;;
;;  You should have received a copy of the GNU Affero General Public
;;  License along with this program.  If not, see
;;  <http://www.gnu.org/licenses/>
;;
;;;  Code:

(defpackage "COMPLETION-CANDIDATES/PACKAGE-COMPLETION"
  (:use "CL")
  (:import-from "COMPLETION-CANDIDATES"
                "JARO-COMPLETION-BACKEND"
                "CANDIDATE"
                "CANDIDATE-STRING"
                "CANDIDATES-FOR"
                "SCORE"))

(in-package "COMPLETION-CANDIDATES/PACKAGE-COMPLETION")

(defclass package-completion-backend (jaro-completion-backend)
  ()
  ;; TODO:
  ;; - If the pattern matches exactly one package return only that candidate
  ;; instead.
  ;; - Handle package nicknames
  (:documentation "Collect all packages whose name has a non-zero similarity
  with PATTERN."))

(defclass package-candidate (candidate)
  ())


(defun make-package-candidate (package score)
  (make-instance 'package-candidate
                 :candidate package
                 :score score))

(defmethod candidate-string ((object package-candidate))
  (package-name (candidate object)))

;; Look for similarities in nicknames as well
(defmethod candidates-for append (pattern (backend package-completion-backend))
  "Collect all packages which have a non-zero similarity with PATTERN. If the
pattern matches exactly one package return only that candidate instead."
  (let (result)
    (dolist (package (list-all-packages) result)
      (let ((candidate-score (score (package-name package)
                                    pattern
                                   backend)))
        (when (not (zerop candidate-score))
          (push (make-package-candidate package candidate-score)
                result))))))

