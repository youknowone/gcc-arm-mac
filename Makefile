TARGET = aarch64-linux
PREFIX = /opt/toolchains

MAKE_FLAGS = -j8
SUBDIRS = linux-* build-*


all: build-gcc


gcc-arm-src:
	# download source code
	-ln -s gmp gcc-*/gmp
	-ln -s mpc gcc-*/mpc
	-ln -s mpfr gcc-*/mpfr
	-ln -s isl gcc-*/isl
	-ln -s libiconv gcc-*/libiconv


get-binutils:
	#

get-linux:
	#

get-glibc:
	#


configure-binutils:
	-mkdir build-binutils
	cd build-binutils && ../binutils-2.*/configure --prefix=$(PREFIX) --target=$(target)  --disable-multilib


configure-gcc:
	-mkdir build-gcc
	cd build-gcc && ../gcc-arm-src-*/configure  --prefix=$(PREFIX) --target=$(TARGET)   --enable-languages=c,c++  --disable-gettext --disable-multilib


configure-glibc:
	# - mkdir build-glibc
	PWD=`pwd` cd build-glibc && $(PWD)/glibc-*/configure --prefix=$(PREFIX) --build=x86_64-apple --host=$(TARGET)  --target=$(TARGET)  --with-headers=$(PREFIX)/$(TARGET)/include --disable-multilib libc_cv_forced_unwind=yes


build-binutils: configure-binutils
	$(MAKE) $(MAKE_FLAGS) -C $@
	$(MAKE) -C $@ install


linux-headers:
	$(MAKE) -C linux-* ARCH=arm64 INSTALL_HDR_PATH=$(PREFIX)/$(TARGET) headers_install


build-gcc-compiler: build-binutils linux-headers configure-gcc
	$(MAKE) $(MAKE_FLAGS) -C build-gcc all-gcc
	$(MAKE) -C build-gcc install-gcc


build-glibc-startup: configure-glibc build-gcc-compiler
	$(MAKE) -C build-glibc install-bootstrap-headers=yes install-headers
	$(MAKE) $(MAKE_FLAGS) -C build-glibc csu/subdir_lib
	cd build-glibc && install csu/crt1.o csu/crti.o csu/crtn.o $(PREFIX)/$(TARGET)/lib
	$(PREFIX)/bin/$(TARGET)-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $(PREFIX)/$(TARGET)/lib/libc.so
	touch $(PREFIX)/$(TARGET)/include/gnu/stubs.h

build-gcc-libgcc: build-glibc-startup
	$(MAKE) $(MAKE_FLAGS) -C build-gcc all-target-libgcc
	$(MAKE) -C build-gcc install-target-libgcc

build-glibc: build-gcc-libgcc
	$(MAKE) $(MAKE_FLAGS) -C $@
	$(MAKE) -C $@ install

build-gcc: build-glibc
	$(MAKE) $(MAKE_FLAGS) -C $@
	$(MAKE) -C $@ install


configure-gcc2:
	-mkdir build-gcc2
	cd build-gcc2 && ../gcc-arm-src-*/configure  --prefix=$(PREFIX) --target=$(TARGET)   --enabl  e-languages=c,c++  --disable-gettext --disable-multilib --with-headers=/opt/cross/aarch64-linux-gnu/include --enable-multiarch

build-gcc2: configure-gcc2
	$(MAKE) $(MAKE_FLAGS) -C build-gcc2


.PHONY: $(SUBDIRS)
