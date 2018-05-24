#lang racket
(require racket/port
         racket/list
         racket/string
         threading)

(define (videostring-meta videostr)
  "Extract the meta sexp from a videostring."
  (read
   (open-input-string
    (~> (string-split videostr "%")
        second
        (string-replace _ ".mp4" "")))))

(define (videostring time meta #:extension [ext ""])
  "Make a videostring from time and meta."
  (string-append time
                 "%"
                 (with-output-to-string
                   (lambda () (display meta)))
                 ext))

(define (videostring-time videostr)
  "Extract the time from a videostring."
  (~> (string-split videostr "%")
      first))
