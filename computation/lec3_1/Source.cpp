#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;

const int N = 5;
const double V = 3;
const double h = 0.01;

double func(double x, double y_x)
{
	return 2 * V * x + V * x * x - y_x;
}

double theor_res(double x)
{
	return V * x * x;
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
	double x = 1;

	for (int i = 0; i < N; i++)
	{
		nodes[i] = x;
		theor_value[i] = theor_res(x);
		x += h;
	}

	pract_value_m1[0] = V;
	for (int i = 1; i < N; i++)
	{
		pract_value_m1[i] = pract_value_m1[i - 1] + h * func(nodes[i - 1], pract_value_m1[i - 1]);
	}
	
	for (int i = 0; i < N; i++)
	{
		error_m1[i] = abs(theor_value[i] - pract_value_m1[i]);
	}

	cout << fixed << setprecision(8);
	cout << "Значения узлов:\n";
	for (auto it : nodes)
		cout << it << '\t';
	cout << '\n' << "Значения метода:\n";
	for (auto it : pract_value_m1)
		cout << it << '\t';
	cout << '\n';
	cout << "Теоретическое значение:\n";
	for (auto it : theor_value)
		cout << it << '\t';
	cout << '\n';
	cout << "Погрешность:\n";
	for (auto it : error_m1)
		cout << it << '\t';
	cout << "\n\n";

	vector<double> pract_value_m2;
	pract_value_m2.resize(N);
	vector<double> error_m2;
	error_m2.resize(N);
	
	pract_value_m2[0] = V;
	double func_half_h;
	for (int i = 1; i < N; i++)
	{
		func_half_h = pract_value_m2[i - 1] + h / 2 * func(nodes[i - 1], pract_value_m2[i - 1]);
		pract_value_m2[i] = pract_value_m2[i - 1] + h * func(nodes[i - 1] + h / 2, func_half_h);
	}

	for (int i = 0; i < N; i++)
	{
		error_m2[i] = abs(theor_value[i] - pract_value_m2[i]);
	}

	cout << "Значения узлов:\n";
	for (auto it : nodes)
		cout << it << '\t';
	cout << '\n' << "Значения метода:\n";
	for (auto it : pract_value_m2)
		cout << it << '\t';
	cout << '\n';
	cout << "Теоретическое значение:\n";
	for (auto it : theor_value)
		cout << it << '\t';
	cout << '\n';
	cout << "Погрешность:\n";
	for (auto it : error_m2)
		cout << it << '\t';
	cout << "\n\n";

	vector<double> pract_value_m3;
	pract_value_m3.resize(N);
	vector<double> error_m3;
	error_m3.resize(N);

	pract_value_m3[0] = V;
	double func_h;
	for (int i = 1; i < N; i++)
	{
		func_h = pract_value_m3[i - 1] + h * func(nodes[i - 1], pract_value_m3[i - 1]);
		pract_value_m3[i] = pract_value_m3[i - 1] + h / 2 * (func(nodes[i - 1], pract_value_m3[i - 1]) + func(nodes[i], func_h));
	}

	for (int i = 0; i < N; i++)
	{
		error_m3[i] = abs(theor_value[i] - pract_value_m3[i]);
	}

	cout << "Значения узлов:\n";
	for (auto it : nodes)
		cout << it << '\t';
	cout << '\n' << "Значения метода:\n";
	for (auto it : pract_value_m3)
		cout << it << '\t';
	cout << '\n';
	cout << "Теоретическое значение:\n";
	for (auto it : theor_value)
		cout << it << '\t';
	cout << '\n';
	cout << "Погрешность:\n";
	for (auto it : error_m3)
		cout << it << '\t';
	cout << "\n\n";

	return 0;
}