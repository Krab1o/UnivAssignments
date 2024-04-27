#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

const int N = 3;
const double V = 3;

int main()
{
	vector<vector<double>> A;
	vector<vector<double>> A_copy;
	vector<double> b;
	vector<double> x;

	A.resize(N);
	for (int i = 0; i < N; i++)
		A[i].resize(N);
	b.resize(N);
	x.resize(N);

	setlocale(LC_ALL, "russian");
	//ввести матрицу
	A[0][0] = 3;
	A[0][1] = 3;
	A[0][2] = -1;
	A[1][0] = 4;
	A[1][1] = 1;
	A[1][2] = 3;
	A[2][0] = 1;
	A[2][1] = -2;
	A[2][2] = -2;
	b[0] = 4;
	b[1] = 8;
	b[2] = 11;

	cout << fixed;
	double determinator = 1;

	double currentDiag;
	double multiplier;
	A_copy = A;
	for (int i = 0; i < N; i++)
	{
		currentDiag = A_copy[i][i];
		for (int j = i; j < N; j++)
			A_copy[i][j] /= currentDiag;

		for (int k = i + 1; k < N; k++)
		{
			multiplier = A_copy[k][i];
			for (int j = i; j < N; j++)
				A_copy[k][j] -= multiplier * A_copy[i][j];
		}
		determinator *= currentDiag;
	}

	cout << "Определитель: " << determinator << "\n\n";

	vector<vector<double>> A_reversed;
	A_reversed.resize(N);
	for (int k = 0; k < N; k++)
	{
		A_reversed[k].resize(N);
		A_copy = A;

		for (int i = 0; i < N; i++)
		{
			if (i == k)
				b[i] = 1;
			else
				b[i] = 0;
		}

		for (int i = 0; i < N; i++)
		{
			currentDiag = A_copy[i][i];
			for (int j = i; j < N; j++)
				A_copy[i][j] /= currentDiag;
			b[i] /= currentDiag;

			for (int k = i + 1; k < N; k++)
			{
				multiplier = A_copy[k][i];
				for (int j = i; j < N; j++)
					A_copy[k][j] -= multiplier * A_copy[i][j];
				b[k] -= multiplier * b[i];

			}
		}
		for (int i = N - 1; i >= 0; i--)
		{
			A_reversed[k][i] = b[i];
			for (int j = i + 1; j < N; j++)
			{
				A_reversed[k][i] -= A_copy[i][j] * A_reversed[k][j];
			}
		}
	}

	cout << "Обратная матрица:\n";
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			cout << A_reversed[j][i] << '\t';
		}
		cout << '\n';
	}
}