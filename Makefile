# zzidun 的博客 —— 常用操作
#
# 默认在 manifest.scm 描述的临时环境中执行，跟随当前 Guix（即最新包），
# 不依赖全局 profile 里装了什么：
#   make build      # 生成站点到 docs/
#   make serve      # 本地预览 http://localhost:8080
#   make publish    # 生成 + 提交 docs/ 与 posts/ + 推送
#
# 若已有可用环境（例如已 guix install haunt），可跳过 Guix：
#   make build RUN=

RUN ?= guix shell -m $(CURDIR)/manifest.scm --
MSG ?= build: 重新生成站点

.PHONY: build serve publish

build:
	cd haunt && $(RUN) haunt build

serve:
	cd haunt && $(RUN) haunt serve

publish: build
	git add -A docs posts haunt manifest.scm Makefile
	git diff --cached --quiet || git commit -m "$(MSG)"
	git push
