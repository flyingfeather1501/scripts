#lang racket/base
(require racket/port
         racket/list
         racket/string
         data/collection
         threading)

;; should probably use a struct for this
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

(define (videostring-set videostr key val)
  "Set Field in Videostr to Val."
  (videostring
   (videostring-time videostr)
   (dict-set
    (videostring-meta videostr)
    key
    val)))

(define (videostring-update videostr key updater)
  "Prompt for new tags for videostr."
  (videostring
   (videostring-time videostr)
   (dict-update
    (videostring-meta videostr)
    key
    updater)))

(define (videostring-add-to-field videostr field sym)
  (videostring-update
   videostr
   field
   (lambda (l)
     (conj l sym))))

(define (videostring-remove-from-field videostr field sym)
  (videostring-update
   videostr
   field
   (lambda (l)
     (filter l (lambda (x) (not (eq? x sym)))))))

(define videostring-change-in-field videostring-set)

;; ((title Title) (place Place) (tags Tag1 Tag2))
(define (add-tag videostr tag)
  (videostring-add-to-field videostr 'tag tag))

(define (edit-tag videostr)
  "Prompt for new tags for videostr."
  (videostring-update
   videostr
   'tags
   (lambda (l)
     (display "Current tags: ")
     (displayln l)
     (display "New tags: ")
     (read (open-input-string (read-line))))))

(define (remove-tag videostr tag)
  (videostring-remove-from-field videostr 'tag tag))

(define (rename-file-or-directory/update file updater)
  ;; More convenient when in a repl as file is already bound
  (rename-file-or-directory
   file
   (updater file)))

(define (add-tag! file tag)
  (rename-file-or-directory
   file
   (add-tag (path->string f) tag)))
