#
# Makefile for Augustus
#
include common.mk

all:
	mkdir -p bin
	cd src && ${MAKE} CC=$(CC) CXX=$(CXX)
	cd auxprogs && ${MAKE} CC=$(BAMTOOLS_CC) CXX=$(BAMTOOLS_CXX) BAMTOOLS=$(BAMTOOLS)

clean:
	cd src && ${MAKE} clean
	cd auxprogs && ${MAKE} clean

INSTALLDIR = /opt/augustus-$(AUGVERSION)

install:
	install -d $(INSTALLDIR)
	cp -a config bin scripts $(INSTALLDIR)
	ln -sf $(INSTALLDIR)/bin/augustus /usr/local/bin/augustus
	ln -sf $(INSTALLDIR)/bin/etraining /usr/local/bin/etraining
	ln -sf $(INSTALLDIR)/bin/prepareAlign /usr/local/bin/prepareAlign
	ln -sf $(INSTALLDIR)/bin/fastBlockSearch /usr/local/bin/fastBlockSearch
	ln -sf $(INSTALLDIR)/bin/load2db /usr/local/bin/load2db
	ln -sf $(INSTALLDIR)/bin/getSeq /usr/local/bin/getSeq

# for internal purposes:
release:
	find . -name .svn | xargs rm -rf
	find . -name "*~" | xargs rm -f
	rm -f src/.kdbgrc*
	rm -f src/makedepend.pl
	rm -r augustus-training
	make clean all
	make clean
	cd auxprogs/filterBam/; make clean all; cd -
	cd auxprogs/bam2hints; make clean; make ; cd -
	cd auxprogs/aln2wig; make clean; make; cd -
	cd auxprogs/homGeneMapping; make clean; make; cd -
	cd auxprogs/joingenes; make clean; make; cd -
	cd auxprogs/compileSpliceCands; make clean; make; cd -
	cd config/species; rm -rf tobacco xeno1 bombus_terrestris{1,3} symsag xenoturbella meara pavar newest humannew
	tar -czf ../augustus-$(AUGVERSION).tar.gz .
	cd src/parser; rm Makefile; cd -
	cd src/scanner; rm Makefile; cd -

# remove -static from src/Makefile for MAC users
# remove -g -gdb from CFLAGS
