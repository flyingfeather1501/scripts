#!/usr/bin/env clisp
; vim: filetype=lisp
; random-string [length]

(defvar *charset* "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

(defun select-random-item (seq)
  (elt seq (random (length seq)
                   ;; create a newly randomly seeded random state
                   (make-random-state t))))

(defun random-string (&optional (len 16))
  (map 'string
       (lambda (x) (select-random-item *charset*))
       (make-string len)))

(format t (if *args*
            (random-string (parse-integer (first *args*)))
            (random-string)))
