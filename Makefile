PREFIX ?= /usr
MANDIR ?= $(PREFIX)/share/man

all:
	@echo RUN \'make install\' to install pm

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@cp -p pm $(DESTDIR)$(PREFIX)/bin/pm
	@cp -p pm.1 $(DESTDIR)$(MANDIR)/man1
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/pm

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/pm
	@rm -rf $(DESTDIR)$(MANDIR)/man1/pm.1*
