#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

const int N = 5;
const double V = 8;
const double T = V;

double p(double x)
{
	return x * x;
}
double q(double x)
{
	return x;
}

double func(double x)
{
	return 4 * V * x * x * x * x
		- 3 * V * T * x * x * x
		+ 6 * V * x
		- 2 * V * T;
}

double phi(int k, double x, double T) 
{
	return pow(x, k + 1) * (x - T);
}

double phi_1(int k, double x, double T) 
{
	return  (k + 2) * pow(x, k + 1) - (k + 1) * T * pow(x, k);
}

double phi_2(int k, double x, double T) 
{
	return (k + 1) * (k + 2) * pow(x, k) - k * (k + 1) * T * pow(x, k - 1);
}

double coefs(int k, double x, double T) 
{
	return phi_2(k, x, T) + p(x) * phi_1(k, x, T) + q(x) * phi(k, x, T);
}

double theor_res(double x)
{
	return V * x * x * (x - T);
}


int main()
{
	setlocale(LC_ALL, "ru");
	vector<double> nodes;
	nodes.resize(N);
	vector<double> pract_value;
	pract_value.resize(N);
	vector<double> theor_value;
	theor_value.resize(N);
	vector<double> error;
	error.resize(N);

	vector<vector<double>> M;
	vector<double> B;
	M.resize(N);
	for (int i = 0; i < N; i++)
		M[i].resize(N);
	B.resize(N);

	double x = 0;
	double h = (V - x) / (N - 1);

	for (int i = 0; i < N; i++)
	{
		/*
		M[i][0] = (6 * pow(x, 1) - 2 * T) 
			+ (p(x) * (3 * pow(x, 2) - 2 * x * T)) 
			+ (q(x) * (pow(x, 2) * (x - T)));
		M[i][1] = (12 * pow(x, 2) - 6 * pow(x, 1) * T)
			+ (p(x) * (4 * pow(x, 3) - 3 * pow(x, 2) * T))
			+ (q(x) * (pow(x, 3) * (x - T)));
		M[i][2] = (20 * pow(x, 3) - 12 * pow(x, 2) * T)
			+ (p(x) * (5 * pow(x, 4) - 4 * pow(x, 3) * T))
			+ (q(x) * (pow(x, 4) * (x - T)));
		M[i][3] = (30 * pow(x, 4) - 20 * pow(x, 3) * T)
			+ (p(x) * (6 * pow(x, 5) - 5 * pow(x, 4) * T))
			+ (q(x) * (pow(x, 5) * (x - T)));
		M[i][4] = (42 * pow(x, 5) - 30 * pow(x, 4) * T)
			+ (p(x) * (7 * pow(x, 6) - 6 * pow(x, 5) * T))
			+ (q(x) * (pow(x, 6) * (x - T)));
		*/
		for (int j = 0; j < N; j++)
		{
			M[i][j] = coefs(j + 1, x, T);
		}
		B[i] = func(x);

		nodes[i] = x;
		theor_value[i] = theor_res(x);
		x += h;
	}

	for (auto row : M)
	{
		for (auto it : row)
			cout << it << '\t';
		cout << '\n';
	}
	cout << '\n';

	double currentDiag;
	double multiplier;
	for (int i = 0; i < N; i++)
	{
		currentDiag = M[i][i];
		for (int j = i; j < N; j++)
			M[i][j] /= currentDiag;
		B[i] /= currentDiag;

		for (int k = i + 1; k < N; k++)
		{
			multiplier = M[k][i];
			for (int j = i; j < N; j++)
			{
				M[k][j] -= multiplier * M[i][j];
			}
			B[k] -= multiplier * B[i];
		}
	}
	
	for (int i = N - 1; i >= 0; i--)
	{
		pract_value[i] = B[i];
		for (int j = i + 1; j < N; j++)
		{
			pract_value[i] -= M[i][j] * pract_value[j];
		}
		error[i] = abs(pract_value[i] - theor_value[i]);
	}
	for (auto row : M)
	{
		for (auto it : row)
			cout << it << '\t';
		cout << '\n';
	}
	cout << "Значение узлов\tПрактическое значение\tТеоретическое значение\tПогрешность\n";
	for (int i = 0; i < N; i++)
	{
		cout << setprecision(4) << nodes[i] << "\t\t" << pract_value[i] << "\t\t\t" << theor_value[i] << "\t\t\t" << error[i] << '\n';
	}
}