(define-module (pages index)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt page)
  #:use-module (haunt html)
  #:use-module (haunt artifact)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-19)
  #:export (index-page-builder))

(define (date->string* date)
  (date->string date "~Y年~m月~d日"))

(define (index-content site posts)
  `((br)
    (br)
    (br)
    (p "如果你要去寻找真理的话, 能把我带上吗?")
    (br)
    (br)
    (br)
    "邮箱: zzidun@posteo.com"
    (br)
    (p
     (img (@ (src "/assets/images/firefox.jpg") (style "height:2rem; width:2rem;")))
     "本站将永远适配Firefox, 狐门"
     (img (@ (src "/assets/images/firefox.jpg") (style "height:2rem; width:2rem;"))))
    (h2 "近期文章:")
    ,@(let ((recent (take (posts/reverse-chronological posts) (min 5 (length posts)))))
        (map (lambda (post)
               `(p (a (@ (href ,(string-append "/" (site-post-slug site post) ".html")))
                      ,(post-ref post 'title)
                      " — "
                      ,(date->string* (post-date post)))))
             recent))
    (p "…更多内容, 见此 " (a (@ (href "/archive.html")) "归档") ".")))

(define (index-page-builder layout)
  (lambda (site posts)
    (let ((body (index-content site posts))
          (title "主页"))
      (list (serialized-artifact "index.html"
                                 (layout site title body)
                                 sxml->html)))))
