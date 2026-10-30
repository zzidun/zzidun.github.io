;; 博客构建依赖。
;;
;; 刻意不写版本号：每次 `guix pull` 后，这里解析到的就是当前 Guix 的最新版本，
;; 不会把环境钉死在旧版本上。
;;
;; 用法：
;;   guix shell -m manifest.scm -- haunt build
;;   make build

(specifications->manifest
 '("guile"
   "haunt"
   "pandoc"))
