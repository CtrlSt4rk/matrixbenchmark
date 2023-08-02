# include "setheader.h"

int main(int argc, char *argv[]){

	struct timeval start, end; //gettimeofday
	double t, sum;
	int i, j, k, tam, threads;

	tam = atoi(argv[1]);
	threads = atoi(argv[2]);

	//Matrices dynamic alocation
	double **ma = (double **)malloc(tam * sizeof(double*));
	for(int i = 0; i < tam; i++) 
			ma[i] = (double *)malloc(tam * sizeof(double));

	double **mb = (double **)malloc(tam * sizeof(double*));
	for(int i = 0; i < tam; i++) 
			mb[i] = (double *)malloc(tam * sizeof(double));

	double **mt = (double **)malloc(tam * sizeof(double*));
	for(int i = 0; i < tam; i++) 
			mt[i] = (double *)malloc(tam * sizeof(double));

	double **mfim = (double **)malloc(tam * sizeof(double*));
	for(int i = 0; i < tam; i++) 
			mfim[i] = (double *)malloc(tam * sizeof(double));

	if (ma == NULL || mb == NULL || mfim == NULL)
    {
        fprintf(stderr, "Out of memory");
        exit(0);
    }

	//fill matrix ma and mb
	for(i=0;i<tam;i++)
		for (j=0;j<tam;j++){
			ma[i][j] = (fmod (rand(), 50.111));
		}
	
	for(i=0;i<tam;i++)
		for (j=0;j<tam;j++){
			mb[i][j] = (fmod (rand(), 50.111));
		}
		
	//matrix multiplication
	gettimeofday(&start, NULL);
	//tranpose mb matrix
	for (i = 0; i < tam; i = i + 1)
   		for (j = 0; j < tam; j = j + 1) 
   			mt[j][i] = mb[i][j];

	#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (i, j, k)
	for(i=0; i<tam; i++)
	{
		for(j=0; j<tam; j++)
		{
			for(k=0; k<tam; k++)
			{
				mfim[i][j] += ma[i][k] * mt[j][k];
			}
		}
	}
	gettimeofday(&end, NULL);
	
	t = (double) ((end.tv_sec * 1000000 + end.tv_usec) - (start.tv_sec * 1000000 + start.tv_usec)) / 1000000.0;
	
	printf ("%f\n", t);

	free(ma); free(mb); free(mfim);
	
	return 0;
}