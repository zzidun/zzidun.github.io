(define-module (reader latex)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (sxml simple)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 textual-ports)
  #:export (latex-reader))

;; 用 LaTeX 写的文章：文件开头用注释形式的元数据，正文交给 pandoc 转成 HTML，
;; 再把 HTML 片段解析成 SXML，这样它就能和 Markdown 文章共用同一套模板。
;;
;; 元数据示例（都是注释，所以这个 .tex 文件仍然可以直接用 latex 编译）：
;;
;;   % title: 文章标题
;;   % author: zzidun
;;   % date: 2026-03-01
;;   % tags: 编程学习
;;   % ---
;;   \documentclass{article}
;;   \begin{document}
;;   ...
;;   \end{document}

(define (temporary-html-file)
  (string-append (or (getenv "TMPDIR") "/tmp")
                 "/haunt-latex-"
                 (number->string (getpid))
                 "-"
                 (number->string (random 1000000))
                 ".html"))

(define* (latex->html body #:key (pandoc "pandoc"))
  "Run PANDOC on BODY and return the resulting HTML fragment."
  (let ((output (temporary-html-file)))
    (dynamic-wind
      (const #t)
      (lambda ()
        (let ((port (open-pipe* OPEN_WRITE
                                pandoc
                                "-f" "latex"
                                "-t" "html"
                                "--mathjax"
                                "--ascii"
                                "--no-highlight"
                                "--wrap=none"
                                "--shift-heading-level-by=1"
                                "-o" output)))
          (display body port)
          (let ((status (close-pipe port)))
            (unless (zero? status)
              (error "pandoc 转换 LaTeX 失败，退出码: " status))))
        (call-with-input-file output get-string-all))
      (lambda ()
        (when (file-exists? output)
          (delete-file output))))))

(define (html-fragment->sxml html)
  "Parse an HTML fragment into a list of SXML nodes."
  (let* ((tree (xml->sxml (open-input-string (string-append "<div>" html "</div>"))))
         (div (cadr tree)))
    (cdr div)))

(define (read-commented-headers port)
  "Read `% key: value` metadata lines up to `% ---` and return an alist."
  (let loop ((headers '()))
    (let ((line (read-line port)))
      (when (eof-object? line)
        (error "LaTeX 文章缺少 `% ---` 元数据结束行"))
      (let* ((trimmed (string-trim-both line))
             (comment? (string-prefix? "%" trimmed))
             (content (and comment?
                           (string-trim-both (substring trimmed 1)))))
        (cond
         ((not comment?)
          (error "LaTeX 文章开头必须是 `% key: value` 形式的元数据，遇到: " line))
         ((string=? content "---")
          (reverse headers))
         (else
          (let ((colon (string-index content #\:)))
            (unless colon
              (error "无效的 LaTeX 元数据行: " line))
            (let* ((key (string->symbol
                         (string-trim-both (substring content 0 colon))))
                   (value (string-trim-both (substring content (+ colon 1))))
                   ;; 和 Markdown 文章一致，日期允许只写 YYYY-MM-DD，补上零点。
                   (value (if (and (eq? key 'date)
                                   (not (string-contains value " ")))
                              (string-append value " 00:00")
                              value)))
              (loop (alist-cons key (parse-metadata key value) headers))))))))))

(define* (latex-reader #:key (pandoc "pandoc"))
  "Return a reader for `.tex` posts converted with PANDOC."
  (make-reader
   (make-file-extension-matcher "tex")
   (lambda (file)
     (call-with-input-file file
       (lambda (port)
         (let* ((headers (read-commented-headers port))
                (body (get-string-all port)))
           (values headers
                   (html-fragment->sxml
                    (latex->html body #:pandoc pandoc)))))))))
