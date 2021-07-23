PREFIX ?= /usr

all:
	@echo RUN \'make install\' to install pm

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@install -Dm755 pm $(DESTDIR)$(PREFIX)/bin/pm
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/neofetch

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/pm
