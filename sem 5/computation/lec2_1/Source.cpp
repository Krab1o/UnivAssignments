#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

//размерность матрицы
const int N = 5;
const double V = 3;

int main()
{
	vector<vector<double>> A;
	vector<double> B;
	vector<double> x;

	A.resize(N);
	for (int i = 0; i < N; i++)
		A[i].resize(N);
	B.resize(N);
	x.resize(N);

	setlocale(LC_ALL, "russian");
	//cout << "Введите параметр:\n";
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
			cout << it << "\t\t";
		cout << '\n';
	}


	cout << "Матрица B:\n";
	for (auto row : B)
		cout << row << '\n';

	double currentDiag;
	double multiplier;
	for (int i = 0; i < N; i++)
	{
		currentDiag = A[i][i];
		for (int j = i; j < N; j++)
			A[i][j] /= currentDiag;
		B[i] /= currentDiag;
		
		for (int k = i + 1; k < N; k++)
		{
			multiplier = A[k][i];
			for (int j = i; j < N; j++)
			{
				A[k][j] -= multiplier * A[i][j];
			}
			B[k] -= multiplier * B[i];
		}

		cout << "Матрица A:\n";
		for (auto row : A)
		{
			for (auto it : row)
				cout << setprecision(3) << it << "\t";
			cout << '\n';
		}

		cout << "Матрица B:\n";
		for (auto row : B)
			cout << setprecision(4) << row << '\n';
	}

	for (int i = N - 1; i >= 0; i--)
	{
		x[i] = B[i];
		for (int j = i + 1; j < N; j++)
		{
			x[i] -= A[i][j] * x[j];
		}
	}

	cout << "Матрица X:\n";
	for (auto row : x)
		cout << setprecision(6) << row << '\n';

	return 0;
}