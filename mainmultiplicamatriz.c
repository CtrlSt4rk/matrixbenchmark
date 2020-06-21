# include "setheader.h"

int main(int argc, char *argv[]){

	struct timeval start, end; //gettimeofday
	double t, sum;
	int i, j, k, tam, threads, version;

	tam = atoi(argv[1]);
	threads = atoi(argv[2]);
	version = atoi(argv[3]);

	//Matrices dynamic alocation
	int **ma = (int **)malloc(tam * sizeof(int*));
	for(int i = 0; i < tam; i++) 
			ma[i] = (int *)malloc(tam * sizeof(int));

	int **mb = (int **)malloc(tam * sizeof(int*));
	for(int i = 0; i < tam; i++) 
			mb[i] = (int *)malloc(tam * sizeof(int));

	int **mfim = (int **)malloc(tam * sizeof(int*));
	for(int i = 0; i < tam; i++) 
			mfim[i] = (int *)malloc(tam * sizeof(int));

	if (ma == NULL || mb == NULL || mfim == NULL)
    {
        fprintf(stderr, "Out of memory");
        exit(0);
    }

	mfim[i][j] = 0;

	//fill matrix ma and mb
	for(i=0;i<tam;i++)
		for (j=0;j<tam;j++){
			ma[i][j] = (rand() % 50);
		}
	
	for(i=0;i<tam;i++)
		for (j=0;j<tam;j++){
			mb[i][j] = (rand() % 50);
		}
		
		//matrix multiplication
		if (version==1){
			gettimeofday(&start, NULL);
			#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (i, j, k) reduction(+:sum)
			for(i=0; i<tam; i++)
			{
				for(j=0; j<tam; j++)
				{
					sum=0;
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}
		if (version==2){
			gettimeofday(&start, NULL);
			for(i=0; i<tam; i++)
			{
				#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (j, k) reduction(+:sum)
				for(j=0; j<tam; j++)
				{
					sum=0;
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}
		if (version==3){
			gettimeofday(&start, NULL);
			for(i=0; i<tam; i++)
			{
				for(j=0; j<tam; j++)
				{
					sum=0;
					#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (k) reduction(+:sum)
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}
		if (version==4){
			gettimeofday(&start, NULL);
			#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (i, j, k) reduction(+:sum)
			for(i=0; i<tam; i++)
			{
				#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (j, k) reduction(+:sum)
				for(j=0; j<tam; j++)
				{
					sum=0;
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}
		if (version==5){
			gettimeofday(&start, NULL);
			#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (i, j, k) reduction(+:sum)
			for(i=0; i<tam; i++)
			{
				for(j=0; j<tam; j++)
				{
					sum=0;
					#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (k) reduction(+:sum)
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}
		if (version==6){
			gettimeofday(&start, NULL);
			for(i=0; i<tam; i++)
			{
				#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (j, k) reduction(+:sum)
				for(j=0; j<tam; j++)
				{
					sum=0;
					#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (k) reduction(+:sum)
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}
		if (version==7){
			gettimeofday(&start, NULL);
			#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (i, j, k) reduction(+:sum)
			for(i=0; i<tam; i++)
			{
				#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (j, k) reduction(+:sum)
				for(j=0; j<tam; j++)
				{
					sum=0;
					#pragma omp parallel for num_threads(threads) shared(ma, mb, mfim) private (k) reduction(+:sum)
					for(k=0; k<tam; k++)
					{
						sum += ma[i][k] * mb[k][j];
					}
					mfim[i][j] = sum;
				}
			}
			gettimeofday(&end, NULL);
		}

	t = (double) ((end.tv_sec * 1000000 + end.tv_usec) - (start.tv_sec * 1000000 + start.tv_usec)) / 1000000.0;
	
	printf ("t %f\n", t);

	printf("Matrix A\n");
	for(i=0; i<tam; i++)
	{
		for(j=0; j<tam; j++)
		{
			printf("%d  ", ma[i][j]);
		}
		printf("\n");
	}

	printf("\nMatrix B\n");
	for(i=0; i<tam; i++)
	{
		for(j=0; j<tam; j++)
		{
			printf("%d  ", mb[i][j]);
		}
		printf("\n");
	}

	printf("\nMatrix C=AxB\n");
	for(i=0; i<tam; i++)
	{
		for(j=0; j<tam; j++)
		{
			printf("%d  ", mfim[i][j]);
		}
		printf("\n");
	}
	printf("\n");

	free(ma); free(mb); free(mfim);
	
	return 0;
}
