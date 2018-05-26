#lang racket
(require threading
         data/collection)

;; Open this file with emacs, run this in a repl, cd to the video assets folder, and start editing
;; videostring-set!*, add-tag! are the current useful functions

(provide (all-defined-out))

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

(define (videostring-set* videostr key val . rest)
  "Set each odd-numbered argument as even-numbered key's value in Videostr."
  (if (empty? rest)
      (videostring-set videostr key val)
      (apply
       videostring-set*
       (videostring-set videostr key val)
       (first rest)
       (second rest)
       (drop 2 rest))))

(define (videostring-update videostr key updater)
  "Update value of Key in Videostr with Updater."
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

(define (add-tag videostr tag)
  (videostring-add-to-field videostr 'tags tag))

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
  (videostring-remove-from-field videostr 'tags tag))

(define (rename-file-or-directory/update file updater)
  ;; More convenient when in a repl as file is already bound
  (rename-file-or-directory
   file
   (updater file)))

(define (videostring-time->path videostr-time)
  "Return the file path that matches videostr-time"
  (~> (directory-list)
      (map path->string _)
      (filter (lambda (s) (string-prefix? s videostr-time)) _)
      stream->list
      ((lambda (l) (if (= (length l) 1) (first l) l)) _)))

(define (videostring-set!* videostr-time #:extension [ext ""] . rest)
  (rename-file-or-directory
   (videostring-time->path videostr-time)
   (string-append
    (apply
     videostring-set*
     (videostring-time->path videostr-time)
     rest)
    ext)))

(define (add-tag! videostr-time tag #:extension [ext ""])
  (rename-file-or-directory
   (videostring-time->path videostr-time)
   (string-append
    (add-tag (videostring-time->path videostr-time) tag)
    ext)))

;; These bang functions can be generated with a macro
