#define _CRT_SECURE_NO_WARNINGS
// SerialGauss.cpp
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <time.h>
#include <math.h>
#include <omp.h>

typedef struct {
	int PivotRow;
	double MaxValue;
} TThreadPivotRow;

int* pPivotPos; // The number of pivot rows selected at the iterations
int* pPivotIter; // The iterations, at which the rows were pivots

// Function for simple initialization of the matrix
// and the vector elements
void DummyDataInitialization(double* pMatrix, double* pVector, int
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
void RandomDataInitialization(double* pMatrix, double* pVector,
	int Size) {
	int i, j; // Loop variables
	srand(unsigned(clock()));
	for (i = 0; i < Size; i++) {
		pVector[i] = rand() / double(1000);
		for (j = 0; j < Size; j++) {
			if (j <= i)
				pMatrix[i * Size + j] = rand() / double(1000);
			else
				pMatrix[i * Size + j] = 0;
		}
	}
}

void TaskInitialization(double* pMatrix, double* pVector, int Size)
{
	//constant terms
	pVector[0] = -9;
	pVector[1] = -146;
	pVector[2] = -10;
	pVector[3] = -26;
	pVector[4] = 37;
	//row 1
	pMatrix[0] = 1;
	pMatrix[1] = 1;
	pMatrix[2] = 4;
	pMatrix[3] = 4;
	pMatrix[4] = 9;
	//row 2
	pMatrix[5] = 2;
	pMatrix[6] = 2;
	pMatrix[7] = 17;
	pMatrix[8] = 17;
	pMatrix[9] = 82;
	//row 3
	pMatrix[10] = 2;
	pMatrix[11] = 0;
	pMatrix[12] = 3;
	pMatrix[13] = -1;
	pMatrix[14] = 4;
	//row 4
	pMatrix[15] = 0;
	pMatrix[16] = 1;
	pMatrix[17] = 4;
	pMatrix[18] = 12;
	pMatrix[19] = 27;
	//row 5
	pMatrix[20] = 1;
	pMatrix[21] = 2;
	pMatrix[22] = 2;
	pMatrix[23] = 10;
	pMatrix[24] = 0;
}
// Function for memory allocation and definition of the objects elements 
void ProcessInitialization(double*& pMatrix, double*
	& pVector,
	double*& pResult, int& Size) {
	// Setting the size of the matrix and the vector
	do {
		printf("\nEnter size of the matrix and the vector: ");
		scanf("%d", &Size);
		printf("\nChosen size = %d \n", Size);
		if (Size <= 0)
			printf("\nSize of objects must be greater than 0!\n");
	} while (Size <= 0);
	// Memory allocation
	pMatrix = new double[Size * Size];
	pVector = new double[Size];
	pResult = new double[Size];
	// Initialization of the matrix and the vector elements
	RandomDataInitialization(pMatrix, pVector, Size);
	//RandomDataInitialization(pMatrix, pVector, Size);
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
void PrintVector(double* pVector, int Size) {
	int i;
	for (i = 0; i < Size; i++)
		printf("%7.4f ", pVector[i]);
}
// Finding the pivot row
int ParallelFindPivotRow(double* pMatrix, int Size, int Iter) {
	int PivotRow = -1; // The index of the pivot row
	int MaxValue = 0; // The value of the pivot element
	int i; // Loop variable
	// Choose the row, that stores the maximum element

#pragma omp parallel
	{
		TThreadPivotRow ThreadPivotRow;
		ThreadPivotRow.MaxValue = 0;
		ThreadPivotRow.PivotRow = -1;
#pragma omp for
		for (i = 0; i < Size; i++) {
			if ((pPivotIter[i] == -1) &&
				(fabs(pMatrix[i * Size + Iter]) > ThreadPivotRow.MaxValue)) {
				ThreadPivotRow.PivotRow = i;
				ThreadPivotRow.MaxValue = fabs(pMatrix[i * Size + Iter]);
			}
		}
		//printf("\n Local thread (id = %i) pivot row: %i", omp_get_thread_num(), ThreadPivotRow.PivotRow);
#pragma omp critical
		{
			if (ThreadPivotRow.MaxValue > MaxValue) {
				MaxValue = ThreadPivotRow.MaxValue;
				PivotRow = ThreadPivotRow.PivotRow;
			}
		}
	}

	return PivotRow;
}

void ParallelColumnElimination(double* pMatrix, double* pVector,
	int Pivot, int Iter, int Size) {
	double PivotValue, PivotFactor;
	PivotValue = pMatrix[Pivot * Size + Iter];
#pragma omp parallel for private(PivotFactor) schedule(dynamic,1)
	for (int i = 0; i < Size; i++) {
		if (pPivotIter[i] == -1) {
			PivotFactor = pMatrix[i * Size + Iter] / PivotValue;
			for (int j = Iter; j < Size; j++) {
				pMatrix[i * Size + j] -= PivotFactor * pMatrix[Pivot * Size + j];
			}
			pVector[i] -= PivotFactor * pVector[Pivot];
		}
	}
}

void ParallelBackSubstitution(double* pMatrix, double* pVector,
	double* pResult, int Size) {
	int RowIndex, Row;
	for (int i = Size - 1; i >= 0; i--) {
		RowIndex = pPivotPos[i];
		pResult[i] = pVector[RowIndex] / pMatrix[Size * RowIndex + i];
#pragma omp parallel for private (Row)
		for (int j = 0; j < i; j++) {
			Row = pPivotPos[j];
			pVector[Row] -= pMatrix[Row * Size + i] * pResult[i];
			pMatrix[Row * Size + i] = 0;
		}
	}
}

// Gaussian elimination
void ParallelGaussianElimination(double* pMatrix, double* pVector,
	int Size) {
	int Iter; // The number of the iteration of the Gaussian
	// elimination
	int PivotRow; // The number of the current pivot row
	for (Iter = 0; Iter < Size; Iter++) {
		// Finding the pivot row
		PivotRow = ParallelFindPivotRow(pMatrix, Size, Iter);
		pPivotPos[Iter] = PivotRow;
		pPivotIter[PivotRow] = Iter;
		ParallelColumnElimination(pMatrix, pVector, PivotRow, Iter, Size);
	}
}

// Function for the execution of Gauss algorithm
void ParallelResultCalculation(double* pMatrix, double* pVector,
	double* pResult, int Size) {
	// Memory allocation
	pPivotPos = new int[Size];
	pPivotIter = new int[Size];
	for (int i = 0; i < Size; i++) {
		pPivotIter[i] = -1;
	}

	ParallelGaussianElimination(pMatrix, pVector, Size);
	ParallelBackSubstitution(pMatrix, pVector, pResult, Size);

	// Memory deallocation
	delete[] pPivotPos;
	delete[] pPivotIter;
}

// Function for computational process termination
void ProcessTermination(double* pMatrix, double* pVector, double*
	pResult) {
	delete[] pMatrix;
	delete[] pVector;
	delete[] pResult;
}

// Function for testing the result
void TestResult(double* pMatrix, double* pVector,
	double* pResult, int Size) {
	/* Buffer for storing the vector, that is a result of multiplication
	of the linear system matrix by the vector of unknowns */
	double* pRightPartVector;
	// Flag, that shows wheather the right parts
	// vectors are identical or not
	int equal = 0;
	double Accuracy = 1.e-6; // Comparison accuracy
	pRightPartVector = new double[Size];
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
		printf("\n\nThe result of the parallel Gauss algorithm is NOT correct."
			"Check your code.\n");
	else
		printf("\n\nThe result of the parallel Gauss algorithm is correct.\n");
	delete[] pRightPartVector;
}


int main() {
	double* pMatrix; // The matrix of the linear system
	double* pVector; // The right parts of the linear system
	double* pResult; // The result vector
	int Size; // The sizes of the initial matrix and the vector
	double start, finish, duration;

	printf("Serial Gauss algorithm for solving linear systems\n");
	// Memory allocation and definition of objects' elements
	ProcessInitialization(pMatrix, pVector, pResult, Size);

	// The matrix and the vector output
	printf("Initial Matrix \n");
	PrintMatrix(pMatrix, Size, Size);
	printf("Initial Vector \n");
	PrintVector(pVector, Size);

	// Execution of Gauss algorithm
	start = clock();
	ParallelResultCalculation(pMatrix, pVector, pResult, Size);
	finish = clock();
	duration = (finish - start) / CLOCKS_PER_SEC;

	TestResult(pMatrix, pVector, pResult, Size);
	// Printing the result vector
	printf("\n Result Vector: \n");
	PrintVector(pResult, Size);

	// Printing the execution time of Gauss method
	printf("\n Time of execution: %f\n", duration);

	// Computational process termination
	ProcessTermination(pMatrix, pVector, pResult);
	return 0;
}