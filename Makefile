PY?=python
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/blog
OUTPUTDIR=$(BASEDIR)/output
THEMEDIR=$(BASEDIR)/theme
BOOKSDIR=$(BASEDIR)/books
CONFFILE=$(BASEDIR)/conf/pelicanconf/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/conf/pelicanconf/publishconf.py

SSH_HOST=jondy.net
SSH_PORT=22
SSH_USER=root
BLOG_TARGET_DIR=/home/www/jondy.net/output
BOOKS_TARGET_DIR=/home/www/jondy.net/books

FTP_HOST=bxu2713750120.my3w.com
FTP_USER=bxu2713750120
FTP_TARGET_DIR=/htdocs

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make clean                          remove the generated files         '
	@echo '   make html                           generated files                    '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make dev [PORT=8000]                start/restart develop_server.sh    '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make upload                         upload the web site via rsync+ssh  '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) -t $(THEMEDIR) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

dev:
ifdef PORT
	$(BASEDIR)/conf/pelicanconf/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/conf/pelicanconf/develop_server.sh restart
endif

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
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(BLOG_TARGET_DIR) --cvs-exclude
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(BOOKSDIR)/ $(SSH_USER)@$(SSH_HOST):$(BOOKS_TARGET_DIR) --cvs-exclude

ftp_upload: html
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

.PHONY: html help clean regenerate serve rsync_upload 
