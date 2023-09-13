T := yaml
DIR := $(realpath .)

all: vim

vim: $(T).vim
	ln -s $(DIR)/$(T).vim ~/.vim/plugin/$(T).vim

clean:
	rm -f ~/.vim/plugin/$(T).vim

.PHONY: all vim clean
