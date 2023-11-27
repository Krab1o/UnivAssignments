#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;

const int N = 5;
const double V = 8;

double func(double x, double y_x)
{
	double T = V;
	return 4 * V * x * x * x
		- 3 * V * T * x * x * x
		+ 6 * V * x
		- 2 * V * T;
}

double theor_res(double x)
{
	double T = V;
	return V * x * x * (x - T);
}

void algos()
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
}

int main()
{
	setlocale(LC_ALL, "ru");
	vector<double> nodes;
	nodes.resize(N);
	vector<double> pract_value_m1;
	pract_value_m1.resize(N);
	vector<double> theor_value;
	theor_value.resize(N);
	vector<double> error_m1;
	error_m1.resize(N);
	double x = 0;
	double h = (V - x) / N;

	for (int i = 0; i < N; i++)
	{
		nodes[i] = x;
		theor_value[i] = theor_res(x);
		x += h;
	}



	return 0;
}