#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <time.h>
#include <math.h>
#include <iostream>
using namespace std;

#define e 0.0000000000001

// Function for simple initialization of the matrix
// and the vector elements
void DummyDataInitialization(long double* pMatrix, long double* pVector, int Size) {
    /*
    pVector[0] = -9;
    pVector[1] = -146;
    pVector[2] = -10;
    pVector[3] = -26;
    pVector[4] = 37;
    pMatrix[0] = 1;
    pMatrix[1] = 1;
    pMatrix[2] = 4;
    pMatrix[3] = 4;
    pMatrix[4] = 9;
    pMatrix[5] = 2;
    pMatrix[6] = 2;
    pMatrix[7] = 17;
    pMatrix[8] = 17;
    pMatrix[9] = 82;
    pMatrix[10] = 2;
    pMatrix[11] = 1;
    pMatrix[12] = 3;
    pMatrix[13] = -1;
    pMatrix[14] = 4;
    pMatrix[15] = 1;
    pMatrix[16] = 1;
    pMatrix[17] = 4;
    pMatrix[18] = 12;
    pMatrix[19] = 27;
    pMatrix[20] = 1;
    pMatrix[21] = 2;
    pMatrix[22] = 2;
    pMatrix[23] = 10;
    pMatrix[24] = 1;
    */
    pVector[0] = 6;
    pVector[1] = 6;
    pVector[2] = 3;
    pMatrix[0] = 3;
    pMatrix[1] = 1;
    pMatrix[2] = 1;
    pMatrix[3] = 1;
    pMatrix[4] = 4;
    pMatrix[5] = 2;
    pMatrix[6] = 2;
    pMatrix[7] = 2;
    pMatrix[8] = 6;

}

// Function for random initialization of the matrix
// and the vector elements
void RandomDataInitialization(long double* pMatrix, long double* pVector,
    int Size) {
    long double s;
    int i, j;  // Loop variables
    srand(unsigned(clock()));
    for (i = 0; i < Size; i++) {
        pVector[i] = rand() / double(1000);
        for (j = 0; j < Size; j++) {
            pMatrix[i * Size + j] = rand() / double(1000);

        }
    }
        for (i = 0; i < Size; i++) {
            s = 0;
            pVector[i] = rand() / double(1000);
            for (j = 0; j < Size; j++) {
                if (i != j)
                    s += pMatrix[i * Size + j];

            }
            pMatrix[i * Size + i] = rand() / double(1000) + s;

        }
    
}
// Function for memory allocation and definition of the objects elements
void ProcessInitialization(long double*& pMatrix, long double*& pVector,
    long double*& pResult, int& Size) {
    // Setting the size of the matrix and the vector
    do {
        printf("\nEnter size of the matrix and the vector: ");
        scanf_s("%d", &Size);
        printf("\nChosen size = %d \n", Size);
        if (Size <= 0)
            printf("\nSize of objects must be greater than 0!\n");
    } while (Size <= 0);
    // Memory allocation
    pMatrix = new long double[Size * Size];
    pVector = new long double[Size];
    pResult = new long double[Size];
    // Initialization of the matrix and the vector elements

 // DummyDataInitialization(pMatrix, pVector, Size);
   RandomDataInitialization(pMatrix, pVector, Size);
}
// Function for formatted matrix output
void PrintMatrix(long double* pMatrix, int RowCount, int ColCount) {
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
        printf("%7.15f ", pVector[i]);
}

// Function for the execution of Gauss algorithm
void SerialResultCalculation(long double* pMatrix, long double* pVector,
    long double* pResult, int Size) {
    long double* g = new long double[Size];
    long double* d = new long double[Size];
    int t = 0;
#pragma omp parallel for
    for (int i = 0; i < Size; i++) { pResult[i] = 0; g[i] = 0; }
  
    bool flag = false;
    long double sum;

    do {
       //cout << t << endl;
        //t++;
        flag = false;
        for (int i = 0; i < Size; i++) {
            g[i] = pVector[i];
            sum = 0;
#pragma omp parallel for reduction(+: sum)
            for (int j = 0; j < Size; j++) {
                if (i != j) {
                    sum += (pMatrix[Size * i + j] * g[j]);
                }
            }
            g[i] -= sum;
            g[i] = (1.0 * g[i]) / pMatrix[Size * i + i];
            if (fabs(g[i] - pResult[i]) >= e) flag = true;

            pResult[i] = g[i];
        }

    } while (flag);
    delete[] g;
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



// Function for computational process termination
static void ProcessTermination(long double* pMatrix, long double* pVector, long double* pResult) {
    delete[] pMatrix;
    delete[] pVector;
    delete[] pResult;
}

int main() {
    long double* pMatrix; // The matrix of the linear system
    long double* pVector; // The right parts of the linear system
    long double* pResult; // The result vector
    int Size; // The sizes of the initial matrix and the vector
    double start, finish, duration;
    printf("Serial Gauss algorithm for solving linear systems\n");
    // Memory allocation and definition of objects' elements
    ProcessInitialization(pMatrix, pVector, pResult, Size);
    // The matrix and the vector output
    printf("Initial Matrix \n");
   // PrintMatrix(pMatrix, Size, Size);
    printf("Initial Vector \n");
    //PrintVector(pVector, Size);
    // Execution of Gauss algorithm
    start = clock();
    SerialResultCalculation(pMatrix, pVector, pResult, Size);
    finish = clock();

    TestResult(pMatrix, pVector, pResult, Size);
    duration = (finish - start) / CLOCKS_PER_SEC;
    // Printing the result vector
    printf("\n Result Vector: \n");
    PrintVector(pResult, Size);
    // Printing the execution time of Gauss method
    printf("\n Time of execution: %f\n", duration);
    // Computational process termination
    ProcessTermination(pMatrix, pVector, pResult);
    return 0;
}
