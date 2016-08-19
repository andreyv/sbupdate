# sbupdate

A tool to generate and sign kernel images for UEFI Secure Boot on Arch Linux.

## Installation

You should be familiar with the process of creating, installing and using
custom Secure Boot keys. See:
* https://wiki.archlinux.org/index.php/Secure_Boot
* http://www.rodsbooks.com/efi-bootloaders/controlling-sb.html

After you have generated your custom keys, proceed with setup:
* Install [sbupdate-git](https://aur.archlinux.org/packages/sbupdate-git/) from AUR
* Place your custom keys in `/root/secure-boot`
* Configure `/etc/default/sbupdate` (see [Configuration](#configuration))
* Run `sudo sbupdate` for first-time image generation

For each kernel `/boot/vmlinuz-<NAME>` a signed UEFI image will be generated in
`${ESP}/EFI/Arch/<NAME>-signed.efi`, where `${ESP}` is typically `/boot`. Now
you can add these images to your UEFI firmware or boot manager configuration.

Note that kernel command line, initramfs and boot splash will be embedded in
the signed UEFI image.

## Configuration

The following settings are available:
* Command line and initramfs[¹](#intel-ucode) for each specified kernel
* A list of additional boot files to sign
* Locations of the key, ESP and output directories
* Boot splash image

Edit the file `/etc/default/sbupdate` to change the settings. Note: you **must**
set your kernel command line in the `CMDLINE_DEFAULT` variable.

<a name="intel-ucode">¹</a> Intel microcode updates are handled automatically.

## Direct booting vs. boot manager

The generated images are UEFI executables and can be directly booted by UEFI
firmware. Therefore, a separate boot manager such as systemd-boot is technically
not required. This is similar to Linux [EFISTUB](https://wiki.archlinux.org/index.php/EFISTUB).

Booting directly from firmware is arguably more secure, but may also be harder
to set up and use. See [Using UEFI directly](https://wiki.archlinux.org/index.php/EFISTUB#Using_UEFI_directly)
in the above article, with the exception that kernel command line does not need
to be specified in this case.

If you choose to use the boot manager, you need to add the generated UEFI
images to the boot manager configuration. For systemd-boot, the basic entry
format is

    title Arch Linux <NAME>
    efi   /EFI/Arch/<NAME>-signed.efi

You also need to sign your boot manager's own UEFI executables with your
custom keys. Add the corresponding filenames to the `EXTRA_SIGN` array in
`/etc/default/sbupdate`, for example (systemd-boot):

    EXTRA_SIGN=('/boot/EFI/Boot/BOOTX64.EFI' '/boot/EFI/systemd/systemd-bootx64.efi')

and re-run the tool if needed. You should remember to run the tool every time
you update the boot manager's files (e.g., after `sudo bootctl update`).

## ESP mount point

Typically ESP is mounted on `/boot` and contains also the original, unsigned
files such as the Linux kernel image and initramfs. You may choose to mount ESP
on a different directory (for example, `/boot/esp`) and keep `/boot` itself on
the secure root file system. This way ESP will only contain signed images which
cannot be tampered with.

See [Configuration](#configuration) to change the ESP directory.

Note that if you use a boot manager such as systemd-boot, then its files still
need to be on the ESP before they are signed. The tool has no provision to
verify the authenticity of additional files at this point. If this is a concern,
you may wish to use direct booting instead.

## Further reading

* https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface
* https://wiki.archlinux.org/index.php/Secure_Boot
* http://www.rodsbooks.com/efi-bootloaders/index.html
* https://bentley.link/secureboot/
