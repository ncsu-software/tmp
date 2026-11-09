MAKEFLAGS += --silent
SHELL=/bin/bash
Top=$(shell git rev-parse --show-toplevel)

help: ## print help
	gawk 'BEGIN {FS = ":.*?## "; print "\nmake: [OPTIONS]\n"}\
	          /^[^ \t].*##/     {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

pull: ## download
	git pull

push: ## save
	echo -en "\033[33mWhy this push? \033[0m"; read x; git commit -am "$$x"; git push; git status

all: ## stamp README's header (after front matter, before first h1) on every *.md
	for f in *.md; do \
	  [ "$$f" = "README.md" ] && continue; \
	  { gawk 'NR==1 && /^---$$/{fm=1} fm{print} fm && NR>1 && /^---$$/{exit}' $$f; \
	    gawk 'NR==1 && /^---$$/{fm=1; next} fm && /^---$$/{fm=0; next} fm{next} /^# /{exit} {print}' README.md; \
	    gawk '/^# /{p=1}p' $$f; } > $$f.tmp \
	  && mv $$f.tmp $$f; \
	done
