(add-to-load-path (dirname (current-filename)))

(use-modules (haunt asset)
             (haunt artifact)
             (haunt site)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader skribe)
             (haunt reader commonmark)
             (theme)
             (templates layout)
             (pages index)
             (pages links)
             (pages archive)
             (pages tags)
             (pages sitemap))

(define (cname-builder)
  (lambda (site posts)
    (list (verbatim-artifact "CNAME" "CNAME"))))

(define (post-file? filename)
  (or (string-suffix? ".md" filename)
      (string-suffix? ".skr" filename)))

(define (my-static-directory directory dest)
  (lambda (site posts)
    (directory-assets directory (const #t) dest)))

(site #:title "zzidun的博客"
      #:domain "zzidun.eu.org"
      #:default-metadata
      '((author . "zzidun")
        (email  . "zzidun@posteo.com"))
      #:posts-directory ".."
      #:build-directory "site"
      #:file-filter post-file?
      #:readers (list skribe-reader commonmark-reader)
      #:builders (list (blog #:theme zzidun-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (my-static-directory "assets" "assets")
                       (my-static-directory "../resource" "resource")
                       (index-page-builder zzidun-layout)
                       (links-page-builder zzidun-layout)
                       (archive-page-builder zzidun-layout)
                       (tags-page-builder zzidun-layout)
                       (sitemap-builder)
                       (cname-builder)))
