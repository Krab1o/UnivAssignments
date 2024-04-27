#include <iostream>
#include <vector>
using namespace std;

const int N = 5;
const double V = 3;
const double eps = 0.0001;

int main()
{
	setlocale(LC_ALL, "ru");
	vector<vector<double>> A;
	vector<double> b;
	vector<double> x;

	vector<vector<double>> alpha;
	vector<double> beta;

	A.resize(N);
	b.resize(N);
	x.resize(N);
	alpha.resize(N);
	beta.resize(N);
	for (int i = 0; i < N; i++)
	{
		A[i].resize(N);
		alpha[i].resize(N);
	}

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
	for (int i = 0; i < N; i++)
	{
		sum = 0;
		for (int j = 0; j < N; j++)
		{
			sum += A[i][j] * x[j];
		}
		b[i] = sum;
		sum = 0;
	}

	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			alpha[i][j] = i == j ? 0 : -(A[i][j] / A[i][i]);
		}
		beta[i] = b[i] / A[i][i];
		x[i] = 0;
	}

	cout << "Матрица A:\n";
	for (auto row : A)
	{
		for (auto it : row)
			cout << it << "\t\t";
		cout << '\n';
	}
	cout << '\n';

	cout << "Матрица b:\n";
	for (auto row : b)
		cout << row << '\n';
	cout << '\n';

	cout << "Вектор x:\n";
	for (auto row : x)
		cout << row << '\n';

	vector<double> new_x;
	new_x.resize(N);
	bool finished;
	while (true)
	{
		finished = true;
		double sum;
		for (int i = 0; i < N; i++)
		{
			sum = 0;
			for (int j = 0; j < N; j++)
			{
				sum += alpha[i][j] * x[j];
			}
			new_x[i] = sum + beta[i];
			if (abs(new_x[i] - x[i]) >= eps)
				finished = false;
			sum = 0;
		}
		x = new_x;
		if (finished)
			break;
	}

	cout << "Вектор x:\n";
	for (auto row : x)
		cout << row << '\n';
}