#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	char dir[PATH_MAX+1];
	(void)getcwd(dir, sizeof(dir));
	printf("Program '%s' running in %s\n", basename(argv[0]), dir);

	abort();
}
