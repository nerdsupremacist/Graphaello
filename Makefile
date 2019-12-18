prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
assetsdir = $(prefix)/graphaello
xcode_path = $(shell xcode-select -p)

build:
	swift build -c release --disable-sandbox

install: build
	mkdir $(assetsdir)
	[ -d $(bindir) ] || mkdir $(bindir)
	[ -d $(libdir) ] || mkdir $(libdir)
	cp -R "templates" "$(assetsdir)"
	install ".build/release/graphaello" "$(bindir)"
	install "$(xcode_path)/../Frameworks/lib_InternalSwiftSyntaxParser.dylib" "$(libdir)"
	install_name_tool -change \
		".build/x86_64-apple-macosx10.10/release/libSwiftSyntax.dylib" \
		"$(libdir)/lib_InternalSwiftSyntaxParser.dylib" \
		"$(bindir)/graphaello"

uninstall:
	rm -rf $(assetsdir)
	rm -rf "$(bindir)/graphaello"
	rm -rf "$(libdir)/lib_InternalSwiftSyntaxParser.dylib"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
