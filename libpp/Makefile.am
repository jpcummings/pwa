cxx_exceptions_flag = @cxx_exceptions_flag@
NOWEAVE = @NOWEAVE@
NOTANGLE = @NOTANGLE@

CPPFLAGS = -I. -I$(srcdir) -I$(includedir)
CXXFLAGS = -Wall -g $(cxx_exceptions_flsg)
TEX = latex

lib_LIBRARIES = libpp.a
libpp_a_SOURCES = pputil.cc Vec.cc matrix.cc lorentz.cc particleData.cc \
	particle.cc event.cc massDep.cc \
	pputil.h Vec.h matrix.h lorentz.h particleData.h \
	particle.h event.h massDep.h 
include_HEADERS = pputil.h Vec.h matrix.h lorentz.h particleData.h \
    particle.h event.h massDep.h

BUILT_SOURCES = \
	pputil.cc Vec.cc matrix.cc lorentz.cc particleData.cc \
	particle.cc event.cc massDep.cc \
	pputil.h Vec.h matrix.h lorentz.h particleData.h \
	particle.h event.h massDep.h 

bin_PROGRAMS = event2event

event2event_SOURCES = event2event.cc

event2event_LDADD = -L@libdir@ -lpp

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


