PY?=python
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/blog
OUTPUTDIR=$(BASEDIR)/output
THEMEDIR=$(BASEDIR)/theme
CONFFILE=$(BASEDIR)/conf/pelicanconf/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/conf/pelicanconf/publishconf.py

SSH_HOST=jondy.net
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/home/www/jondy.net/newblog2

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make upload                         upload the web site via rsync+ssh  '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) -t $(THEMEDIR) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t $(THEMEDIR) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

upload: 
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) -t $(THEMEDIR) $(PELICANOPTS)
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude

.PHONY: html help clean regenerate serve rsync_upload 
