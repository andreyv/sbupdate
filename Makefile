INSTALL ?= install
SHELLCHECK ?= shellcheck

.PHONY: all check install

all:

check:
	$(SHELLCHECK) sbupdate

install:
	$(INSTALL) -D -m 0755 -t "$(DESTDIR)/usr/bin" sbupdate
	$(INSTALL) -D -m 0644 -t "$(DESTDIR)/etc" sbupdate.conf
	$(INSTALL) -D -m 0644 -t "$(DESTDIR)/usr/share/libalpm/hooks" \
      $(addprefix hooks/,95-sbupdate.hook 50-sbupdate-remove.hook 50-fwupd-sign.hook)
	$(INSTALL) -D -m 0644 -t "$(DESTDIR)/usr/lib/tmpfiles.d" \
      tmpfiles.d/sbupdate.conf
	$(INSTALL) -D -m 0644 -t \
      "$(DESTDIR)$(or $(DOCDIR),/usr/share/doc/sbupdate)" README.md
