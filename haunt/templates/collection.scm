(define-module (templates collection)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:export (zzidun-collection-template
            zzidun-pagination-template))

(define (date->string* date)
  "Convert DATE to human readable string."
  (date->string date "~Y年~m月~d日 ~H:~M:~S"))

(define (zzidun-collection-template site title posts prefix)
  (define (post-uri post)
    (string-append (or prefix "") "/"
                   (site-post-slug site post) ".html"))

  `((h2 ,title)
    (ul
     ,@(map (lambda (post)
              `(li
                (a (@ (href ,(post-uri post)))
                   ,(post-ref post 'title)
                   " — "
                   ,(date->string* (post-date post)))))
            posts))))

(define (zzidun-pagination-template site body previous-page next-page)
  `(,@body
    (div (@ (class "pagination"))
     ,(if previous-page
          `(a (@ (href ,previous-page)) "← 上一页")
          '())
     " — "
     ,(if next-page
          `(a (@ (href ,next-page)) "下一页 →")
          '()))))
