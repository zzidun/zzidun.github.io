(define-module (templates collection)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (srfi srfi-19)
  #:export (zzidun-collection-template
            zzidun-pagination-template))

(define (date->string* date)
  "Convert DATE to human readable string."
  (date->string date "~Y年~m月~d日"))

;; 一个 collection 就是一页“按条件聚合的文章列表”，目前用于标签页。
(define (zzidun-collection-template site title posts prefix)
  (define (post-uri post)
    (string-append (or prefix "") "/"
                   (site-post-slug site post) ".html"))

  `((h1 ,title)
    (p "共 " ,(number->string (length posts)) " 篇文章")
    (ul
     ,@(map (lambda (post)
              `(li
                (a (@ (href ,(post-uri post)))
                   ,(post-ref post 'title))
                " — "
                ,(date->string* (post-date post))))
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
