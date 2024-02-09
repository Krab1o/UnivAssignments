#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;

const int N = 4000;
const double V = 8;

double func(double x)
{
	double T = V;
	return 4 * V * x * x * x * x
		- 3 * V * T * x * x * x
		+ 6 * V * x
		- 2 * V * T;
}

double theor_res(double x)
{
	double T = V;
	return V * x * x * (x - T);
}

void triag_method(vector<vector<double>> M, vector<double> D, vector<double>& x)
{
	vector<double> triag_P;
	vector<double> triag_Q;
	vector<vector<double>> tripples;
	triag_P.resize(N);
	triag_Q.resize(N);
	tripples.resize(N);
	for (int i = 0; i < N; i++)
		tripples[i].resize(3);

	tripples[0][0] = 0;
	tripples[0][1] = M[0][0];
	tripples[0][2] = M[0][1];
	tripples[N - 1][0] = M[N - 1][N - 2];
	tripples[N - 1][1] = M[N - 1][N - 1];
	tripples[N - 1][2] = 0;

	for (int i = 1; i < N - 1; i++)
		for (int j = 0; j < 3; j++)
			tripples[i][j] = M[i][j + i - 1];

	triag_P[0] = tripples[0][2] / -tripples[0][1];
	triag_Q[0] = -D[0] / -tripples[0][1];
	for (int i = 1; i < N - 1; i++)
	{
		triag_P[i] = tripples[i][2] / (-tripples[i][1] - tripples[i][0] * triag_P[i - 1]);
		triag_Q[i] = (tripples[i][0] * triag_Q[i - 1] - D[i]) / (-tripples[i][1] - tripples[i][0] * triag_P[i - 1]);
	}
	triag_P[N - 1] = 0;
	triag_Q[N - 1] = (tripples[N - 1][0] * triag_Q[N - 2] - D[N - 1]) / (-tripples[N - 1][1] - tripples[N - 1][0] * triag_P[N - 2]);
	
	x[N - 1] = triag_Q[N - 1];
	for (int i = N - 2; i >= 0; i--)
	{
		x[i] = triag_P[i] * x[i + 1] + triag_Q[i];
	}
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

	M[0][0] = 1;
	M[N - 1][N - 1] = 1;
	for (int i = 1; i < N - 1; i++)
	{
		nodes[i] = x;
		theor_value[i] = theor_res(x);

		M[i][i - 1] = 1 / (h * h) - (x * x) / (2 * h);
		M[i][i] = -2 / (h * h) + x;
		M[i][i + 1] = 1 / (h * h) + (x * x) / (2 * h);
		
		b[i] = func(x);
		x += h;
	}
	nodes[N - 1] = x;
	theor_value[N - 1] = theor_res(x);
	b[0] = b[N - 1] = 0;

	cout << fixed << setprecision(8);

	/*
	for (auto row : M)
	{
		for (auto it : row)
			cout << it << '\t';
		cout << '\n';
	}
	for (auto it : b)
		cout << it << '\n';
	*/

	triag_method(M, b, pract_value);
	
	double max_error = 0;
	int k = 0;
	for (int i = 0; i < N; i++)
	{
		error[i] = abs(theor_value[i] - pract_value[i]);
		if (error[i] > max_error)
		{
			max_error = error[i];
			k = i;
		}
			
	}



	cout << "Значение узлов\t\tПрактическое значение\tТеоретическое значение\tПогрешность\n";
	for (int i = 0; i < N; i++)
	{
		cout << nodes[i] << "\t\t" << pract_value[i] << "\t\t" << theor_value[i] << "\t\t" << error[i] << '\n';
	}

	cout << "Максимальная погрешность: " << max_error << "\nНомер узла максимальной погрешности: " << k;

	/*
	cout << "Значения узлов:\n";
	for (auto it : nodes)
		cout << it << '\t';
	cout << '\n';
	cout << "Практическое значение\n";
	for (auto it : pract_value)
		cout << it << '\t';
	cout << '\n';
	cout << "Теоретическое значение:\n";
	for (auto it : theor_value)
		cout << it << '\t';
	cout << '\n';
	cout << "Погрешность:\n";
	for (auto it : error)
		cout << it << '\t';
	cout << "\n\n";
	*/
	return 0;
}