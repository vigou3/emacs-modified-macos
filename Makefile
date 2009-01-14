# Makefile for GNU Emacs.app Modified

# Copyright (C) 2009 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs.app Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a disk image to distribute the software.
# The code is based on a Makefile created by Remko Troncon
# (http://el-tramo.be/about).

include ./Makeconf

# DMG building. No editing should be needed beyond this point

MASTER_DMG=$(NAME)-$(VERSION).dmg
TEMPLATE_DMG=template.dmg
WC_DMG=wc.dmg
WC_DIR=wc

.PHONY: all
all: $(MASTER_DMG)

$(TEMPLATE_DMG): $(TEMPLATE_DMG).bz2
	bunzip2 -k $<

$(TEMPLATE_DMG).bz2:
	@echo
	@echo Generating empty template...
	mkdir template
	hdiutil create -size 160m "$(TEMPLATE_DMG)" -srcfolder template -format UDRW -volname "$(NAME)" -quiet
	rmdir template
	bzip2 "$(TEMPLATE_DMG)"
	@echo

$(WC_DMG): $(TEMPLATE_DMG)
	cp $< $@

$(MASTER_DMG): $(WC_DMG) $(SOURCE_FILES)
	@echo
	@echo Creating Disk Image...
	mkdir -p $(WC_DIR)
	hdiutil attach "$(WC_DMG)" -noautoopen -quiet -mountpoint "$(WC_DIR)"
	for i in $(SOURCE_FILES); do  \
		rm -rf "$(WC_DIR)/$$i"; \
		ditto -rsrc "$(SOURCE_DIR)/$$i" "$(WC_DIR)/$$i"; \
	done
	WC_DEV=`hdiutil info | grep "$(WC_DIR)" | grep "Apple_HFS" | awk '{print $$1}'` && \
	hdiutil detach $$WC_DEV -quiet -force
	rm -f "$(MASTER_DMG)"
	hdiutil convert "$(WC_DMG)" -quiet -format UDZO -imagekey zlib-level=9 -o "$@"
	rm -rf $(WC_DIR)
	@echo

.PHONY: clean
clean:
	-rm -rf $(TEMPLATE_DMG) $(MASTER_DMG) $(WC_DMG)


PREFIX=$VOLUME/$NAME-$VERSION/Emacs.app/Contents

cp -p README.txt $VOLUME/$NAME-$VERSION
cp -p NEWS $VOLUME/$NAME-$VERSION
cp -R Applications $VOLUME/$NAME-$VERSION
cp -p site-start.el ${PREFIX}/Resources/site-lisp
cp -p psvn.el ${PREFIX}/Resources/site-lisp
ess_install.sh
auctex_install.sh
aspell_install.sh
dict_install.sh
