- [ ] Simplify array expansions (fixed in Bash 4.4)
- [ ] Consider using pipes instead of temporary files
- [ ] Use `getopt(1)` for argument parsing
- [ ] Avoid creating backup if the new image is the same as the current one
- [ ] Support multiple initramfs per kernel?
- [ ] Consider supporting `kernel-install(8)`
  * ~~What to do with the default `90-loaderentry.install`?~~ Fixed in newer systemd (exit code 77)
  * Use `/etc/kernel/cmdline` in this mode
- [ ] Move `/etc/default/sbupdate` to `/etc/sbupdate.conf`?
- [ ] Generalize initrd prepend mechanism
