#include <iostream>
#include <vector>

using namespace std;

const int N = 5;
const double V = 3;

int main()
{
	setlocale(LC_ALL, "russian");
	vector<vector<double>> M;
	vector<double> D;
	vector<double> x;
	vector<double> triag_P;
	vector<double> triag_Q;
	vector<vector<double>> tripples;
	
	M.resize(N);
	tripples.resize(N);
	for (int i = 0; i < N; i++)
	{
		M[i].resize(N);
		tripples[i].resize(3);
	}
	D.resize(N);
	x.resize(N);
	triag_P.resize(N);
	triag_Q.resize(N);

	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			if (i == j)
				M[i][j] = V + (i * 2);
			else
				M[i][j] = (V + (i * 2)) / 100;
		}
		x[i] = V + (i * 2);
	}

	tripples[0][0] = 0;
	tripples[0][1] = -M[0][0];
	tripples[0][2] = M[0][1];
	tripples[N - 1][0] = M[N - 1][N - 2];
	tripples[N - 1][1] = -M[N - 1][N - 1];
	tripples[N - 1][2] = 0;

	double sum;
	for (int i = 0; i < N; i++)
	{
		sum = 0;
		for (int j = 0; j < N; j++)
		{
			sum += M[i][j] * x[j];
		}
		D[i] = sum;
		sum = 0;
	}

	cout << "Матрица A:\n";
	for (auto row : M)
	{
		for (auto it : row)
			cout << it << "\t\t";
		cout << '\n';
	}
	cout << "Матрица B:\n";
	for (auto row : D)
		cout << row << '\n';
	cout << '\n';

	for (int i = 1; i < N - 1; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			tripples[i][j] = j == 1 ? -M[i][j + i - 1] : M[i][j + i - 1];
		}
	}

	//Элементы алгоритма прогонки
	for (auto row : tripples)
	{
		for (auto it : row)
			cout << it << '\t';
		cout << '\n';
	}
	cout << '\n';

	triag_P[0] = tripples[0][2] / tripples[0][1];
	triag_Q[0] = -D[0] / tripples[0][1];
	for (int i = 0; i < N - 1; i++)
	{
		triag_P[i + 1] = tripples[i][2] / (tripples[i][1] - tripples[i][0] * triag_P[i]);
		triag_Q[i + 1] = (tripples[i][0] * triag_Q[i] - D[i]) / (tripples[i][1] - tripples[i][0] * triag_P[i]);
	}

	cout << "Прогоночные коэффициенты:\n";
	for (auto row : triag_P)
		cout << row << '\n';
	cout << '\n';

	x[N - 1] = triag_Q[N - 1];
	for (int i = N - 2; i >= 0; i--)
	{
		x[i] = triag_P[i + 1] * x[i + 1] + triag_Q[i + 1];
	}

	cout << "Вектор x:\n";
	for (auto it : x)
		cout << it << '\n';
}