(add-to-load-path (dirname (current-filename)))

(use-modules (haunt asset)
             (haunt artifact)
             (haunt site)
             (haunt post)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader skribe)
             (haunt reader commonmark)
             (reader latex)
             (srfi srfi-1)
             (theme)
             (templates layout)
             (pages index)
             (pages links)
             (pages archive)
             (pages sitemap)
             (pages tags-common))

(define (cname-builder)
  (lambda (site posts)
    (list (verbatim-artifact "CNAME" "CNAME"))))

(define (post-file? filename)
  (or (string-suffix? ".md" filename)
      (string-suffix? ".skr" filename)
      (string-suffix? ".tex" filename)))

(define (my-static-directory directory dest)
  (lambda (site posts)
    (directory-assets directory (const #t) dest)))

;; 把每个标签变成一个 Haunt collection：由 blog 构建器统一生成标签页，
;; 同时负责为“至少属于一个 collection”的文章生成文章页。
;; 没有任何标签的文章归入“未分类”，否则它们不会得到文章页。
(define (blog-with-tag-collections theme)
  (lambda (site posts)
    (define (tag-collection tag)
      (list tag
            (string-append "tags/" tag ".html")
            (lambda (all-posts)
              (posts/reverse-chronological
               (filter (lambda (post)
                         (member tag (post-tags post)))
                       all-posts)))))
    (define (untagged-collection)
      (list untagged-tag
            (string-append "tags/" untagged-tag ".html")
            (lambda (all-posts)
              (posts/reverse-chronological
               (filter post-untagged? all-posts)))))
    (define collections
      (append (map tag-collection
                   (delete-duplicates (append-map post-tags posts)))
              (if (any post-untagged? posts)
                  (list (untagged-collection))
                  '())))
    ((blog #:theme theme #:collections collections) site posts)))

(site #:title "zzidun的博客"
      #:domain "zzidun.eu.org"
      #:default-metadata
      '((author . "zzidun")
        (email  . "zzidun@posteo.com"))
      #:posts-directory "../posts"
      #:build-directory "../docs"
      #:file-filter post-file?
      #:readers (list skribe-reader commonmark-reader (latex-reader))
      #:builders (list (blog-with-tag-collections zzidun-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (my-static-directory "assets" "assets")
                       (my-static-directory "../posts/resource" "resource")
                       (index-page-builder zzidun-layout)
                       (links-page-builder zzidun-layout)
                       (archive-page-builder zzidun-layout)
                       (sitemap-builder)
                       (cname-builder)))
