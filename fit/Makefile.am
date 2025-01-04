## Process this file with automake to produce Makefile.in

NOWEAVE = @NOWEAVE@
NOTANGLE = @NOTANGLE@

BUILT_SOURCES = fitlog.h fitparse.cc

bin_PROGRAMS = fit camp selectEvent logview

fit_SOURCES = fit.cc fitparse.yy lex.ll parseutils.cc code.cc \
init.cc math.cc symbol.cc minuit.cc minuit91.f fort_open.f intrac.c fitlog.cc fitlog.h  

camp_SOURCES = fitparse.yy camp.cc lex.ll code.cc init.cc math.cc symbol.cc 

selectEvent_SOURCES = selectEvent.cc

logview_SOURCES = logview.cc fitlog.cc fitparse.yy lex.ll parseutils.cc \
code.cc init.cc math.cc symbol.cc fitlog.h 

CLEANFILES = fitlog.cc fitlog.h fitparse.cc fitparse.h lex.cc logview.cc

LDADD=-L@libdir@ -lpwa -lpp 
fit_LDADD=-L@libdir@ -lpwa -lpp @FLIBS@
camp_LDADD=-L@libdir@ -lpwa -lpp @FLIBS@
selectEvent_LDADD=-L@libdir@ -lpwa -lpp 
logview_LDADD=-L@libdir@ -lpwa -lpp 

CXXFLAGS=-g -O2 -Wall
YFLAGS=-d

# some rules for noweb files --
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


