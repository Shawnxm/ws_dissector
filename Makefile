# Makefile for ws_dissector PC and IOS version
# Author  : Xumiao Zhang
# Date    : 2017-08-18
# Version : 1.0

LIB_PREFIX=/usr/local/lib
WS_SRC_PATH=$(HOME)/wireshark-master
GLIB_SRC=/usr/local/Cellar/glib/2.52.3
LIBPCAP_SRC=/usr/local/Cellar/libpcap/1.8.1
WS_LIB_PATH=$(HOME)/wireshark-master/build/lib
IOS_PREFIX=$(HOME)/IOS
IOS_LIB_PREFIX=$(HOME)/IOS
ARCH=arm64-apple-darwin
CROSS_PATH=${ios_PREFIX}/bin/${ARCH}
CXX="$(xcrun --sdk iphoneos -f clang++)"
STRIP=${CROSS_PATH}-strip
IOS_CC_FLAGS=-I"$(WIRESHARK_SRC)" \
				-I"$(LIBPCAP_SRC)" \
				-I"$(GLIB_SRC)" \
				-I"$(GLIB_SRC)/glib" \
				
				#-I"$(GLIB_SRC)/gmodule" \
				-I"$(GLIB_SRC)/ios" \
				-L"$(ios_LIB_PREFIX)" -lwireshark -lglib-2.0


all: ws_dissector

.PHONY: IOS

IOS: IOS_ws_dissector IOS_pie_ws_dissector

ws_dissector: ws_dissector.cpp packet-aww.cpp
	/Applications/Xcode.app/Contents/Developer/usr/bin/g++ $^ -o $@ `pkg-config --libs --cflags glib-2.0` -I"$(WS_SRC_PATH)" \
	-L"$(WS_LIB_PATH)" -lwireshark -lwsutil -lwiretap

ios_ws_dissector: ws_dissector.cpp packet-aww.cpp
	$(CXX) -v $^ -o $@ $(IOS_CC_FLAGS)

ios_pie_ws_dissector: ws_dissector.cpp packet-aww.cpp
	$(CXX) -v $^ -o $@ $(IOS_CC_FLAGS) -pie

strip:
	$(STRIP) ios_ws_dissector ios_pie_ws_dissector
	strip ws_dissector

clean:
	rm ws_dissector ios_ws_dissector ios_pie_ws_dissector
