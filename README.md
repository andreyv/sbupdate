# sbupdate

[![CircleCI](https://circleci.com/gh/andreyv/sbupdate.svg?style=shield)](https://circleci.com/gh/andreyv/sbupdate)

This tool allows you to sign Arch Linux kernels using your own Secure Boot keys.

## Installation

You should be familiar with the process of creating, installing and using
custom Secure Boot keys. See:
* https://wiki.archlinux.org/index.php/Secure_Boot
* https://www.rodsbooks.com/efi-bootloaders/controlling-sb.html

After you have generated your custom keys, proceed with setup:
* Install [sbupdate-git](https://aur.archlinux.org/packages/sbupdate-git/) from AUR
* Place your custom keys in `/etc/efi-keys`
* Configure `/etc/sbupdate.conf` (see [Configuration](#configuration))
* Run `sudo sbupdate` for first-time image generation

For each installed Arch kernel, a signed UEFI image will be generated, by default
in `/boot/EFI/Arch/<NAME>-signed.efi`. Multiple images can be generated with
advanced configuration. Now you can [add these images](#direct-booting-vs-boot-manager)
to your UEFI firmware or boot manager configuration.

After the initial setup, signed images will be (re)generated automatically when
you install or update kernels using Pacman.

Note that the kernel command line, initramfs and boot splash will be embedded in
the signed UEFI image.

## Configuration

Edit the file `/etc/sbupdate.conf`. Set your default kernel command line
in the `CMDLINE_DEFAULT` variable.

The following optional settings are available:
* Command line and initramfs[<sup>1</sup>](#ucode) for each kernel config
  (each kernel can have multiple configs)
* A list of additional boot files to sign
* Locations of the key, ESP and output directories
* Boot splash image

<a name="ucode"><sup>1</sup></a> Intel and AMD microcode updates are handled
automatically.

## Direct booting vs. boot manager

The generated images are UEFI executables and can be directly booted by UEFI
firmware. Therefore, a separate boot manager such as systemd-boot is technically
not required. This is similar to Linux [EFISTUB](https://wiki.archlinux.org/index.php/EFISTUB).

Booting directly from firmware is arguably more secure, but may also be harder
to set up and use. See [Using UEFI directly](https://wiki.archlinux.org/index.php/EFISTUB#Using_UEFI_directly)
in the above article, with the exception that the kernel command line does not
need to be specified in this case.

---

Alternatively, you can use a boot manager. In this case you need to add the generated UEFI
images to the boot manager configuration. For systemd-boot, the basic entry
format is

    title Arch Linux <NAME>
    efi   /EFI/Arch/<NAME>-signed.efi

You also need to sign your boot manager's own UEFI executables with your
custom keys. Add corresponding filenames to the `EXTRA_SIGN` array in
`/etc/sbupdate.conf`, for example (systemd-boot):

    EXTRA_SIGN=('/boot/EFI/BOOT/BOOTX64.EFI' '/boot/EFI/systemd/systemd-bootx64.efi')

and re-run the tool if needed. You should remember to run the tool every time
you update your boot manager's files (e. g., after `sudo bootctl update`).

⚠️ **Note**: When booting with Secure Boot disabled, options passed from an EFI shell
(_even empty_) may override the built-in command line in the combined image, and
the boot may fail. See [#4](https://github.com/andreyv/sbupdate/issues/4).


## ESP mount point

Typically ESP is mounted on `/boot` and contains also the original, unsigned
files such as the Linux kernel image and initramfs. You may choose to mount ESP
on a different directory (for example, [`/efi`](https://www.freedesktop.org/software/systemd/man/bootctl.html#--esp-path=))
and keep `/boot` itself on the secure root file system. This way ESP will only
contain signed images which cannot be tampered with.

See [Configuration](#configuration) to change the ESP directory.

Note that if you use a boot manager such as systemd-boot, then its files still
need to be on the ESP before they are signed. It is customary to sign these
files right after they have been installed on the ESP. Direct booting is
recommended for increased security.

## Related resources

* https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface
* https://wiki.archlinux.org/index.php/Secure_Boot
* https://www.rodsbooks.com/efi-bootloaders/index.html
* https://bentley.link/secureboot/
* https://github.com/gdamjan/secure-boot — a similar project
