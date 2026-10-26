(define-module (pages tags-common)
  #:use-module (haunt post)
  #:use-module (srfi srfi-1)
  #:export (untagged-tag
            post-untagged?
            all-tags))

;; 没有任何标签的文章归到这里，避免它们既不进标签页、也拿不到文章页。
(define untagged-tag "未分类")

(define (post-untagged? post)
  "Return #t if POST has no tags."
  (null? (post-tags post)))

(define (all-tags posts)
  "Return every tag used by POSTS, plus the pseudo tag `未分类` when at
least one post is untagged."
  (append (delete-duplicates (append-map post-tags posts))
          (if (any post-untagged? posts)
              (list untagged-tag)
              '())))
