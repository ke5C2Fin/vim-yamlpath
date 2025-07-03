T := yaml.vim
DIR := $(realpath .)
TDIR := ~/.vim/ftplugin

all: vim

vim: $(T).vim
	mkdir -p $(TDIR)
	ln -s $(DIR)/$(T) $(TDIR)/$(T)

clean:
	rm -f $(TDIR)/$(T)

.PHONY: all vim clean
