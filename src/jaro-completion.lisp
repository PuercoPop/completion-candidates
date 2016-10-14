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

(defclass jaro-completion-backend (completion-backend)
  ()
  (:documentation "Score the candidates according to the jaro distance."))

(defmethod score ((candidate string) (pattern string) (backend jaro-completion-backend))
  (vas-string-metrics:jaro-distance candidate pattern))

(defmethod candidates-for :around (pattern (backend levenshtein-completion-backend))
  "Filter all the candidates that have zero similariry."
  (remove-if #'zerop (call-next-method)
             :key #'(lambda (candidate)
                      (vas-string-metrics:jaro-distance candidate pattern))))
