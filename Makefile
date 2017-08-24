# Makefile for ws_dissector PC and IOS version
# Author  : Xumiao Zhang
# Date    : 2017-08-23
# Version : 1.0

LIB_PREFIX=/usr/local/lib
WS_SRC_PATH=$(HOME)/wireshark-2.4.0
WS_LIB_PATH=$(HOME)/wireshark-2.4.0/build/lib
WIRESHARK_SRC=$(HOME)/wireshark-2.4.0
#LIBPCAP_SRC=/usr/local/Cellar/libpcap/1.8.1
LIBPCAP_SRC=/Users/mssn/compilation/libpcap-1.8.1
GLIB_SRC=/usr/local/Cellar/glib/2.52.3

IOS_PREFIX=$(HOME)/IOS
IOS_LIB_PREFIX=$(HOME)/IOS
ARCH=arm-apple-darwin
CROSS_PATH=${IOS_PREFIX}/bin/${ARCH}
STRIP=${CROSS_PATH}-strip
IOS_CC_FLAGS=-I"$(WIRESHARK_SRC)" \
				-I"$(LIBPCAP_SRC)" \
				-I"$(GLIB_SRC)" \
				-I"$(GLIB_SRC)/lib/glib-2.0/include" \
				-I"$(GLIB_SRC)/include/glib-2.0" \
				-L"$(IOS_LIB_PREFIX)" -lwireshark -lglib-2.0
				#"$(xcrun --sdk iphoneos -f clang)"
DEFAULT_INCLUDES = -I.

build_triplet = x86_64-apple-darwin16.7.0
host_triplet = arm-apple-darwin
target_triplet = arm-apple-darwin
CC = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
CCDEPMODE = depmode=gcc3
CC_FOR_BUILD = gcc
CFLAGS = -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk -arch arm64 -miphoneos-version-min=7.0
CFLAGS_FOR_BUILD = -g -O2
CONFIG_ARGS = --host=arm-apple-darwin --prefix=/Users/mssn/wireshark/build --enable-static --disable-shared --disable-wireshark --with-zlib=no --with-pcap=no
COREFOUNDATION_FRAMEWORKS = -framework CoreFoundation
CPP = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -E
CPPFLAGS = 
CPPFLAGS_FOR_BUILD = 
CPP_FOR_BUILD = gcc -E
#CXX = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++ -isysroot $(xcrun --sdk iphoneos --show-sdk-path)
CXX = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++
CXXCPP = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++ -E -std=c++11
CXXDEPMODE = depmode=gcc3
CXXFLAGS = -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk -arch arm64 -miphoneos-version-min=7.0

HAVE_BLESS = yes
HAVE_CXX11 = 1
HAVE_DOXYGEN = no
HAVE_DPKG_BUILDPACKAGE = yes
HAVE_HDIUTIL = yes
HAVE_OSX_PACKAGING = yes
HAVE_PKGMK = no
HAVE_PKGPROTO = no
HAVE_PKGTRANS = no
HAVE_SHELLCHECK = no
HAVE_SVR4_PACKAGING = no
HAVE_XCODEBUILD = yes
INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_PROGRAM = ${INSTALL}
INSTALL_SCRIPT = ${INSTALL}
INSTALL_STRIP_PROGRAM = $(install_sh) -c -s
LD = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
LDFLAGS_SHAREDLIB = -Wl,-single_module
LEX = flex
LEX_OUTPUT_ROOT = lex.yy
MKDIR_P = ./install-sh -c -d
NM = nm
NMEDIT = nmedit
OBJDUMP = objdump
OBJEXT = o
OSX_APP_FLAGS = -sdkroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk
OSX_MIN_VERSION = 10.12
PERL = /usr/local/bin/perl 
PKG_CONFIG = /usr/local/bin/pkg-config
POD2HTML = /usr/local/bin/pod2html
POD2MAN = /usr/local/bin/pod2man
PORTAUDIO_INCLUDES = 
PORTAUDIO_LIBS = 
PYTHON = /usr/local/bin/python
SED = /usr/bin/sed
SHELL = /bin/sh
STRIP = strip
SYSTEMCONFIGURATION_FRAMEWORKS = -framework SystemConfiguration
abs_builddir = /Users/mssn/ws_dissector
abs_srcdir = /Users/mssn/ws_dissector
abs_top_builddir = /Users/mssn/ws_dissector
abs_top_srcdir = /Users/mssn/ws_dissector
ac_ct_AR = ar
ac_ct_CC_FOR_BUILD = gcc
ac_ct_DUMPBIN = link -dump
am__include = include
am__leading_dot = .
am__tar = tar --format=ustar -chf - "$$tardir"
am__untar = tar -xf -
bindir = ${exec_prefix}/bin
build = x86_64-apple-darwin16.7.0
build_cpu = x86_64
build_os = darwin16.7.0
build_vendor = apple
builddir = .
host = arm-apple-darwin
host_alias = arm-apple-darwin
host_cpu = arm
host_os = darwin
host_vendor = apple
target = arm-apple-darwin
target_alias = 
target_cpu = arm
target_os = darwin
target_vendor = apple


all: ws_dissector

.PHONY: IOS

IOS: ios_ws_dissector ios_pie_ws_dissector

ws_dissector: ws_dissector.cpp packet-aww.cpp
	g++ $^ -o $@ `pkg-config --libs --cflags glib-2.0` -I"$(WS_SRC_PATH)" \
	-L"$(WS_LIB_PATH)" -lwireshark -lwsutil -lwiretap

ios_ws_dissector: ws_dissector.cpp packet-aww.cpp
	$(CXX) $(CXXFLAGS) $(DEFAULT_INCLUDES) $^ -o $@ $(IOS_CC_FLAGS)

ios_pie_ws_dissector: ws_dissector.cpp packet-aww.cpp
	$(CXX) -v $^ -o $@ $(IOS_CC_FLAGS) -pie

strip:
	$(STRIP) ios_ws_dissector ios_pie_ws_dissector
	strip ws_dissector

clean:
	rm ws_dissector ios_ws_dissector ios_pie_ws_dissector
