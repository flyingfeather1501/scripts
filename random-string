#!/usr/bin/env racket
#lang racket
; vim: filetype=racket
; random-string [length]

(define charset (or (getenv "CHARSET")
                    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"))

(define (select-random-item seq)
  (sequence-ref seq (random (sequence-length seq))))

(define (random-string [len 16])
  (list->string
    (map (λ (x) (select-random-item charset))
         (make-list len #f))))

(if (empty? (vector->list (current-command-line-arguments)))
  (displayln (random-string))
  (displayln (random-string (string->number (vector-ref (current-command-line-arguments) 0)))))
