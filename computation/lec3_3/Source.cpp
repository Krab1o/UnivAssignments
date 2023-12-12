#include <iostream>
#include <vector>

using namespace std;

const int N = 5;
const double V = 8;
const double T = V;

double func(double x)
{
	return 4 * V * x * x * x * x
		- 3 * V * T * x * x * x
		+ 6 * V * x
		- 2 * V * T;
}

double theor_res(double x)
{
	return V * x * x * (x - T);
}

double f1_0(double x)
{
	return pow(x, 2) * (x - T);
}
double f2_0(double x)
{
	return pow(x, 3) * (x - T);
}
double f3_0(double x)
{
	return pow(x, 4) * (x - T);
}
double f4_0(double x)
{
	return pow(x, 5) * (x - T);
}
double f5_0(double x)
{
	return pow(x, 6) * (x - T);
}

double f1_1(double x)
{
	return 3 * pow(x, 2) - 2 * x * T;
}
double f2_1(double x)
{
	return 4 * pow(x, 3) - 3 * pow(x, 2) * T;
}
double f3_1(double x)
{
	return 5 * pow(x, 4) - 4 * pow(x, 3) * T;
}
double f4_1(double x)
{
	return 6 * pow(x, 5) - 5 * pow(x, 4) * T;
}
double f5_1(double x)
{
	return 7 * pow(x, 6) - 6 * pow(x, 5) * T;
}

double f1_2(double x)
{
	return 6 * x - 2 * T;
}
double f2_2(double x)
{
	return 12 * pow(x, 2) - 6 * x * T;
}
double f3_2(double x)
{
	return 20 * pow(x, 3) - 12 * pow(x, 2) * T;
}
double f4_2(double x)
{
	return 30 * pow(x, 4) - 20 * pow(x, 3) * T;
}
double f5_2(double x)
{
	return 42 * pow(x, 5) - 30 * pow(x, 4) * T;
}

int main()
{
	vector<double> nodes;
	nodes.resize(N);
	vector<double> pract_value;
	pract_value.resize(N);
	vector<double> theor_value;
	theor_value.resize(N);
	vector<double> error;
	error.resize(N);

	vector<vector<double>> M;
	vector<double> b;
	M.resize(N);
	for (int i = 0; i < N; i++)
		M[i].resize(N);
	b.resize(N);

	double x = 0;
	double h = (V - x) / (N - 1);
	nodes[0] = x;
	theor_value[0] = theor_res(x);
	x += h;
}