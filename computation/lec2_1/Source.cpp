#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

//размерность матрицы
const int N = 5;

int main()
{
	double V;
	vector<vector<double>> A;
	vector<double> B;
	vector<double> x;

	A.resize(N);
	for (int i = 0; i < N; i++)
		A[i].resize(N);
	B.resize(N);
	x.resize(N);

	setlocale(LC_ALL, "russian");
	cout << "Введите параметр:\n";
	cout << setprecision(6);
	cin >> V;
	
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			if (i == j)
				A[i][j] = V + (i * 2);
			else
				A[i][j] = (V + (i * 2)) / 100;
		}
		x[i] = V + (i * 2);
	}
	
	double sum;
	
	//Умножение матриц
	for (int i = 0; i < N; i++)
	{
		sum = 0;
		for (int j = 0; j < N; j++)
		{
			sum += A[i][j] * x[j];
		}
		B[i] = sum;
		sum = 0;
	}

	cout << "Матрица A:\n";
	for (auto row : A)
	{
		for (auto it : row)
			cout << it << '\t';
		cout << '\n';
	}

	cout << "Матрица X:\n";
	for (auto row : x)
		cout << row << '\n';

	cout << "Матрица B:\n";
	for (auto row : B)
		cout << row << '\n';

	double currentDiag;
	for (int i = 0; i < N; i++)
	{
		currentDiag = A[i][i];
		for (int j = i; j < N; j++)
			A[i][j] /= currentDiag;
		B[i] /= currentDiag;
		
		for (int k = i + 1; k < N; k++)
		{
			for (int j = i; j < N; j++)
			{
				A[k][j] -= A[i][j] * A[k][0];
			}	
			B[k] -= B[i] * A[k][0];
		}	

		cout << "Матрица A:\n";
		for (auto row : A)
		{
			for (auto it : row)
				cout << it << '\t';
			cout << '\n';
		}

		cout << "Матрица B:\n";
		for (auto row : B)
			cout << row << '\n';
	}

	return 0;
}