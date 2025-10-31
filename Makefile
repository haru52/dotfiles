.PHONY: install dev-install lint lint-npm lint-text lint-yaml lint-sh update-gi
.PHONY: update-gi-global

install:
	./install.sh

dev-install:
	npm ci
	vale sync

lint: lint-npm lint-text lint-yaml lint-sh

lint-npm:
	npm run lint

lint-text:
	vale README.md CONTRIBUTING.md SECURITY.md .github/*.md .github/ISSUE_TEMPLATE

lint-yaml:
	yamllint --strict .

lint-sh:
	shellcheck *.sh bin/**/*.sh .husky/commit-msg .husky/pre-commit

update-gi:
	gibo update
	cat .gitignore_custom >| .gitignore
	gibo dump macOS Linux Windows VisualStudioCode JetBrains Vim Node >> .gitignore

update-gi-global:
	gibo update
	cat .gitignore_global_custom >| dotfiles/.gitignore_global
	gibo dump macOS Linux Windows VisualStudioCode JetBrains Vim >> dotfiles/.gitignore_global
