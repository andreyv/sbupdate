- [ ] Support multiple initramfs per kernel
- [ ] Consider supporting `kernel-install(8)`
  * What to do with the default `90-loaderentry.install`?
  * Use `/etc/kernel/cmdline` in this mode
- [ ] Decide whether to create `/etc/secure-boot` using `tmpfiles.d(5)` instead of `/root/secure-boot`
