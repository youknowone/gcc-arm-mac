gcc-arm-mac
===========

Download binary: [https://github.com/youknowone/gcc-arm-mac/releases](https://github.com/youknowone/gcc-arm-mac/releases)

I followed the article: [How to build a GCC Cross-Compiler](https://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/)

Preparation:
- [gcc-arm-src-snapshot-9.2-2019.12.tar.xz](https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/srcrel/gcc-arm-src-snapshot-9.2-2019.12.tar.xz?revision=90d3618d-8136-44f2-aeef-42015dd0669a&la=en&hash=00A97AA1ECF0B96A65F831AD719CA04053FBC61E)
- Homebrew gcc@10, m4, gnu-sed, autoconf, automake, bison, whatever what we need
- Make sure the GNU tools have priority.
  - At least gcc, g++, gnumake, make, sed, bison must be replaced
- We need case-sensitive file system for glibc - use disk utility
- Source codes
  - binutils
  - linux
  - glibc

Build:

  0. Read build related sections of [GCC FAQ](https://gcc.gnu.org/wiki/FAQ). This is important.
  1. Make symlink of bundled gcc dependencies into gcc source directory.
  2. Follow the article.
  - Note: I edited asan code a bit to avoid build failure.

Disclaimer: Makefile is not fully tested.
