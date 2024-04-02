#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <time.h>
#include <math.h>
#include <omp.h>

const double eps = 0.00001;
const double relaxParam = 1;

int* pPivotPos; // The number of pivot rows selected at the iterations
int* pPivotIter; // The iterations, at which the rows were pivots

// Function for simple initialization of the matrix
// and the vector elements
void DummyDataInitialization(long double* pMatrix, long double* pVector, int
	Size) {
	int i, j; // Loop variables
	for (i = 0; i < Size; i++) {
		pVector[i] = i + 1;
		for (j = 0; j < Size; j++) {
			if (j <= i)
				pMatrix[i * Size + j] = 1;
			else
				pMatrix[i * Size + j] = 0;
		}
	}
}

// Function for random initialization of the matrix
// and the vector elements
void RandomDataInitialization(long double* pMatrix, long double* pVector, int Size) {
	int i, j; // Loop variables
	srand(unsigned(clock()));
	for (i = 0; i < Size; i++) {
		pVector[i] = rand() / long double(1000);
		for (j = 0; j < Size; j++) {
			if (j <= i)
				pMatrix[i * Size + j] = rand() / long double(1000);
			else
				pMatrix[i * Size + j] = 0;
		}
	}
}
// Function for memory allocation and definition of the objects elements 
void ProcessInitialization(long double*& pMatrix, long double*
	& pVector, long double*& pResult, int& Size) {
	// Setting the size of the matrix and the vector
	do {
		printf("\nEnter size of the matrix and the vector: ");
		scanf("%d", &Size);
		printf("\nChosen size = %d \n", Size);
		if (Size <= 0)
			printf("\nSize of objects must be greater than 0!\n");
	} while (Size <= 0);
	// Memory allocation
	pMatrix = new long double[Size * Size];
	pVector = new long double[Size];
	pResult = new long double[Size];
	// Initialization of the matrix and the vector elements
	//RandomDataInitialization(pMatrix, pVector, Size);
	DummyDataInitialization(pMatrix, pVector, Size);
}
// Function for formatted matrix output
void PrintMatrix(double* pMatrix, int RowCount, int ColCount) {
	int i, j; // Loop variables
	for (i = 0; i < RowCount; i++) {
		for (j = 0; j < ColCount; j++)
			printf("%7.4f ", pMatrix[i * RowCount + j]);
		printf("\n");
	}
}

// Function for formatted vector output
void PrintVector(long double* pVector, int Size) {
	int i;
	for (i = 0; i < Size; i++)
		printf("%7.4f ", pVector[i]);
}

// Function for the execution of Gauss algorithm
void ParallelResultCalculation(long double* pMatrix, long double* pVector,
	long double* prevResult, int Size) {

	long double* curResult = new long double[Size];
//#pragma omp parallel for 
	for (int i = 0; i < Size; i++) 
	{ 
		prevResult[i] = 0; 
		curResult[i] = 0; 
	}
	bool flag = false;
	long double sum;
	do {
		flag = false;
		for (int i = 0; i < Size; i++) {
			curResult[i] = pVector[i];
			sum = 0;
			for (int j = 0; j < Size; j++) {
				if (i != j)
					sum += pMatrix[Size * i + j] * curResult[j];
			}
			curResult[i] -= sum;
			//curResult[i] = (1 - relaxParam) * prevResult[i] + relaxParam * curResult[i] / pMatrix[Size * i + i];
			curResult[i] = relaxParam * curResult[i] / pMatrix[Size * i + i];
		}

		//Check if difference between current computations and previous ones exceed eps
		for (int i = 0; i < Size; i++) {
			if (fabs(curResult[i] - prevResult[i]) >= eps) 
				flag = true;
			prevResult[i] = curResult[i];
		}
	} while (flag);
	delete[] curResult;
}

// Function for computational process termination
void ProcessTermination(long double* pMatrix, long double* pVector, long double* pResult) {
	delete[] pMatrix;
	delete[] pVector;
	delete[] pResult;
}

// Function for testing the result
void TestResult(long double* pMatrix, long double* pVector,
	long double* pResult, int Size) {
	/* Buffer for storing the vector, that is a result of multiplication
	of the linear system matrix by the vector of unknowns */
	long double* pRightPartVector;
	// Flag, that shows wheather the right parts
	// vectors are identical or not
	int equal = 0;
	long double Accuracy = 1.e-6; // Comparison accuracy
	pRightPartVector = new long double[Size];
	for (int i = 0; i < Size; i++) {
		pRightPartVector[i] = 0;
		for (int j = 0; j < Size; j++) {
			pRightPartVector[i] +=
				pMatrix[i * Size + j] * pResult[j];
		}
	}
	for (int i = 0; i < Size; i++) {
		if (fabs(pRightPartVector[i] - pVector[i]) > Accuracy)
			equal = 1;
	}
	if (equal == 1)
		printf("The result of the parallel Gauss algorithm is NOT correct."
			"Check your code.");
	else
		printf("The result of the parallel Gauss algorithm is correct.");
	delete[] pRightPartVector;
}


int main() {
	long double* pMatrix; // The matrix of the linear system
	long double* pVector; // The right parts of the linear system
	long double* pResult; // The result vector
	int Size; // The sizes of the initial matrix and the vector
	long double start, finish, duration;

	printf("Serial Gauss algorithm for solving linear systems\n");
	// Memory allocation and definition of objects' elements
	ProcessInitialization(pMatrix, pVector, pResult, Size);

	// The matrix and the vector output
	printf("Initial Matrix \n");
	//PrintMatrix(pMatrix, Size, Size);
	printf("Initial Vector \n");
	//PrintVector(pVector, Size);

	// Execution of Gauss algorithm
	start = clock();
	ParallelResultCalculation(pMatrix, pVector, pResult, Size);
	finish = clock();
	duration = (finish - start) / CLOCKS_PER_SEC;

	TestResult(pMatrix, pVector, pResult, Size);
	//Printing the result vector
	printf("\n Result Vector: \n");
	PrintVector(pResult, Size);

	// Printing the execution time of Gauss method
	printf("\n Time of execution: %f\n", duration);

	// Computational process termination
	ProcessTermination(pMatrix, pVector, pResult);
	return 0;
}