(defun say-hello ()
  (print "Please type your name:")
  (let ((name (read-line)))
    (print "Nice to meet you, ")
    (print name)))

(defun add-five ()
  (print "please enter a number:")
  (let ((num (read)))
    (print "When I add five I get")
    (print (+ num 5))))

(defun game-repl ()
  (loop (print (eval (read)))))

(defun game-repl ()
  (let (
    (cmd (game-read)))
    (unless (eq (car cmd) 'quite)
      (game-print (game-eval cmd))
      (game-repl))
  ))

(defun game-read ()
  (let ((cmd (read-from-string (concatenate 'string "(" (read-line) ")"))))
  (flet ((quote-it (x) (list 'quote x)))
    (cons (car cmd) (mapcar #'quote-it (cdr cmd)))
  )
  )
)

(defparameter *allowed-commands* '(look walk pickup inventory))

(defun game-eval (sexp)
  (if (member (car sexp) *allowed-commands*)
    (eval sexp)
    '(i do not know that command))
)

;; lit - "treat capitalization as shown literally"
(defun tweak-text (lst caps lit)
(when lst
  (let (
    (item (car lst))
    (rest (cdr lst))
    )
    (cond
      ((eq item #\space)
        (cons item (tweak-text rest caps lit))
      )
      ((member item '(#\! #\? #\.))
        (cons item (tweak-text rest t lit))
      )
      ((eq item #\")
        (tweak-text rest caps (not lit))
      )
      (lit
        (cons item (tweak-text rest nil lit))
      )
      ((or caps lit)
        (cons (char-upcase item) (tweak-text rest nil lit)
      ))
      (t
        (cons (char-downcase item) (tweak-text rest nil nil)))
      
    )
  )
)
)

(defun game-print (lst)
  (princ (coerce (tweak-text (coerce (string-trim "() " (prin1-to-string lst))
        'list)
      t
      nil)
    'string)
  )
(fresh-line))

