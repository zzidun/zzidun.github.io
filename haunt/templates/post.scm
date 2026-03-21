(define-module (templates post)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:export (zzidun-post-template
            date->string*))

(define (date->string* date)
  "Convert DATE to human readable string."
  (date->string date "~Y年~m月~d日 ~H:~M:~S"))

(define (tag-links tags)
  (if (null? tags)
      '()
      (let loop ((tags tags) (result '()))
        (cond
         ((null? tags) (reverse result))
         ((null? (cdr tags)) (reverse (cons `(a (@ (href ,(string-append "/tags/" (car tags) ".html"))) ,(car tags)) result)))
         (else (loop (cdr tags) (cons " · " (cons `(a (@ (href ,(string-append "/tags/" (car tags) ".html"))) ,(car tags)) result))))))))

(define (zzidun-post-template post)
  `((h1 ,(post-ref post 'title))
    (p (@ (style "font-size: 0.9em; color: #666;"))
       "作者: " ,(post-ref post 'author)
       "  |  时间: " ,(date->string* (post-date post))
       "  |  标签: " ,@(tag-links (post-tags post)))
    (div ,(post-sxml post))))
