INSTALL ?= install
SHELLCHECK ?= shellcheck

.PHONY: all check install

all:

check:
	$(SHELLCHECK) ukpdate

install:
	$(INSTALL) -D -m 0755 -t "$(DESTDIR)/usr/bin" ukpdate
	$(INSTALL) -D -m 0644 -t "$(DESTDIR)/etc" ukpdate.conf
	$(INSTALL) -D -m 0644 -t "$(DESTDIR)/usr/share/libalpm/hooks" \
      $(addprefix hooks/,95-ukpdate.hook 50-ukpdate-remove.hook 50-fwupd-sign.hook)
	$(INSTALL) -D -m 0644 -t "$(DESTDIR)/usr/lib/tmpfiles.d" \
      tmpfiles.d/ukpdate.conf
	$(INSTALL) -D -m 0644 -t \
      "$(DESTDIR)$(or $(DOCDIR),/usr/share/doc/sbupdate)" README.md
