#include <iostream>
#include <string>
#include <complex>
#include <stdio.h>
#include <signal.h>
#include <setjmp.h>
#include <unistd.h>
#include <fit.h>
#include <fitparse.h>

int yyparse(void);
int mnparm(int, string, double, double, double, double);


char* progname;
int lineno = 1;

int main(int argc, char** argv) {

	double wt, maxWt = 0.0;
	complex<double> cwt;
	double events;
	int exec_eloop = 1, exec_norm = 0;
	int result_is_complex = 0;
	int output_binary = 0;
	progname = argv[0];

    // extern char *optarg;
    // extern int optind;
    int c;

    while ( (c = getopt(argc,argv, "enchb")) != -1 )
        switch(c) {
        case 'e':
            exec_eloop = 1;
            exec_norm = 0;
            break;
        case 'n': 
            exec_eloop = 0;
            exec_norm = 1;
            break;
        case 'c': 
            result_is_complex = 1;
            break;
        case 'b': 
            output_binary = 1;
            break;
        case 'h': 
            cerr << "usage:" << endl;
            cerr << progname << " -[ench] < inputfile" << endl;
			cerr << "    where:" << endl;
			cerr << "        -e:    execute event_loop prog (default)" << endl;
			cerr << "        -n:    execute normalization prog" << endl;
			cerr << "        -c:    force output as complex #" << endl;
			cerr << "        -b:    binary output (default: ascii)" << endl;
			cerr << "        -h:    print help" << endl;
			exit(0);
            break;
        }

	init();

	if(exec_eloop) {
		install("wt",CTYPE,0.0);

		init_event_code();
		yyparse();
		// read_amps();
		open_ampfiles();
		open_rmatfiles();
		
		// rewind_amps();

		while(update_amps_from_files() && update_rmat_from_files()) {
			execute(event_prog);
			if(result_is_complex) {
				cwt = lookup("wt")->val;
				if(output_binary) {
					cout.write((char*) &cwt,sizeof(cwt));
				}
				else {
					cout << cwt << endl;
				}
			}
			else {
				wt = real(lookup("wt")->val);
				maxWt = (wt>maxWt) ? wt : maxWt;
				if(output_binary) {
					cout.write((char*) &wt,sizeof(wt));
				}
				else {
					cout << wt << endl;
				}
			}

		}
		if(!result_is_complex) {
			cerr << "maximum weight: " << maxWt << endl;
		}
	}

	if(exec_norm) {
		install("events",CTYPE,0.0);

		init_norm_code();
		yyparse();
		
		execute(norm_prog);
		events = real(lookup("events")->val);
		if(output_binary) {
			cout.write((char*) &events,sizeof(events));
		}
		else {
			cout << events << endl;
		}

	}

	return 0;
}

void warning(char* s, char* t) {
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}

void yyerror(char* s) {
	warning(s, (char*) 0);
	exit(1);
}

void execerror(char* s, char* t) {
	warning(s, t);
	exit(1);
}

void fpecatch(int err) {
	execerror("floating point exception", (char*) 0);
}

int mnparm(int, string, double, double, double, double) {
	cerr << "this is impossible" << endl;
	throw "aFit";
	return 0;
}
