#!/usr/bin/racket
#lang racket
(require threading)

(~> #("female" "male")
    (dict-ref _ (random 2))
    (displayln))
