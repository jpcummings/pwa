cxx_exceptions_flag = @cxx_exceptions_flag@
NOWEAVE = @NOWEAVE@
NOTANGLE = @NOTANGLE@

CPPFLAGS = -I. -I$(srcdir) -I$(includedir)
CXXFLAGS = -Wall -g $(cxx_exceptions_flsg)
YFLAGS = -d -p key
LFLAGS = -olex.yy.c
TEX = latex

lib_LIBRARIES = libpwa.a

libpwa_a_SOURCES =  \
	keyParse.yy keyScan.ll \
	keyfile.cc keyfile.h wave.cc wave.h \
	integral.cc integral.h

include_HEADERS = integral.h

BUILT_SOURCES = \
	keyParse.yy keyScan.ll \
	keyfile.cc keyfile.h wave.cc wave.h \
	integral.cc integral.h gamp.cc vamp.cc int.cc

bin_PROGRAMS = gamp vamp int

gamp_SOURCES = gamp.cc
vamp_SOURCES = vamp.cc
int_SOURCES = int.cc

gamp_LDADD = libpwa.a -L@libdir@ -lpp
int_LDADD = libpwa.a -L@libdir@ -lpp



keyScan.ll: keyfile.nw
	notangle -R$@ $^ | cpif $@

keyParse.yy: keyfile.nw
	notangle -R$@ $^ | cpif $@

%.h: %.nw
	$(NOTANGLE) -L -R$@ $^ | cpif $@

%.cc: %.nw
	$(NOTANGLE) -L -R$@ $^ | cpif $@

%.tex: %.nw
	$(NOWEAVE) -index -option longchunks -option smallcode  $^ | cpif $@

%.html: %.nw
	$(NOWEAVE) -index -html -filter l2h  $^ | htmltoc | cpif $@

%.ps: %.dvi
	dvips $^ -o $@

%.d: %.cc $(h_sources)
	$(SHELL) -ec '$(CXX) -M $(CPPFLAGS) $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'


