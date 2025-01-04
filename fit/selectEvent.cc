#include <iostream>
#include <event.h>
#include <unistd.h>

double randr(double min, double max);
void printUsage();

extern particleDataTable PDGtable;

int main(int argc, char** argv) {

	int c;
    extern char *optarg;
    // extern int optind;
	ifstream weightfile;
	double maxwt = 0, wt = 0;
	int printmaxwt = 0;

	event e;
	
	PDGtable.initialize();

    while ( (c = getopt(argc,argv, "w:m:h")) != -1 )
        switch(c) {
            case 'w':
                weightfile.open(optarg);
                break;
            case 'm':
                maxwt = atof(optarg);
                break;
            case 'p':
                printmaxwt = 1;
                break;
            case 'h':
	    default:
		printUsage();
		exit(0);
        }

	if(printmaxwt) {
	    while ( !(weightfile >> wt).eof() ) {
		maxwt = wt>maxwt?wt:maxwt;
	    }
	    cout << maxwt << endl;
	    exit(0);
	}

	while ( !(cin >> e).eof() && !(weightfile >> wt).eof() ) {
		if ( wt > randr(0,maxwt) )
			cout << e;
	}

	return 0;
}

double randr(double min, double max) {

	return(min + drand48()*(max-min));

}

void printUsage() {
	cerr << "selectEvent -w wtfile -m maxwt < eventfile.gamp" << endl;
	cerr << "selectEvent -w wtfile -p" << endl;
}
