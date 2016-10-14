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
                  #'>
                  :key #'(lambda (candidate)
                           (score candidate pattern completion-backend))))


(defclass completion-backend ()
  ()
  (:documentation "The base class for all completion backends."))

(defmethod candidates-for :around (pattern (backend completion-backend))
  (sort (call-next-method) pattern backend))



;; The candidate protocol
(defclass candidate ()
  ((candidate :initarg :candidate
              :reader candidate
              :documentation "The raw candidate object.")
   (score :initarg :score
          :initform 0
          :reader candidate-score
          :documentation "Ranks how ideal the CANDIDATE is on a scale from 0 to 1."))
  (:documentation "A record for candidates for completion."))

;; Because the scoring and sorting works on completion we need a way to view
;; the candidate as a string.
;; XXX: Would it be better to take advantage of print-object instead?
(defgeneric candidate-string (candidate)
  (:documentation "Transform the candidate object to a string."))

(defmethod print-object ((obj candidate) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~A, Score: ~4,2F%" (candidate-string obj) (* (candidate-score obj) 100))))

(defun make-candidate (candidate score)
  (make-instance 'candidate
                 :candidate candidate
                 :score score))
