(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (templates layout)
  #:use-module (templates post)
  #:use-module (templates collection)
  #:export (zzidun-theme))

(define zzidun-theme
  (theme #:name "zzidun"
         #:layout zzidun-layout
         #:post-template zzidun-post-template
         #:collection-template zzidun-collection-template
         #:pagination-template zzidun-pagination-template))
