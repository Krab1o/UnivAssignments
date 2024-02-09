#include <iostream>
#include <vector>

using namespace std;

const uint32_t nodeNumber = 4;


double lagrangeSeries(double x, const vector<pair<double, double>>& functionNodes)
{
	double sum = 0;
	double item = 1;
	for (pair<double, double> excl : functionNodes)
	{
		item *= excl.second;
		for (pair<double, double> val : functionNodes)
		{
			if (val.first != excl.first)
				item *= (x - val.first) / (excl.first - val.first);
		}
		sum += item;
		item = 1;
	}
	return sum;
}

int main()
{
	setlocale(LC_ALL, "russian");

	//double x;
	//cout << "¬ведите точку x" << '\n';
	//cin >> x;

	vector<pair<double, double>> functionNodes = 
	{
		make_pair(-2, -8), 

		make_pair(-1, -1), 
		make_pair(0, 0), 
		make_pair(2, 8)
	};

	for (pair<double, double> val : functionNodes)
	{
		for (int i = nodeNumber - 1; i >= 0; i--)
		{
			cout << pow(val.first, i) << '\t';
		}
		cout << val.second << '\n';
	}
	cout << '\n' << '\n';

	for (int i = 0; i < nodeNumber - 1; i++)
	{
		cout << functionNodes[i].first << '\t'
			<< (functionNodes[i].first + functionNodes[i + 1].first) / 2 << '\t';
	}
	cout << functionNodes[nodeNumber - 1].first << '\n';

	for (int i = 0; i < nodeNumber - 1; i++)
	{
		cout << lagrangeSeries(functionNodes[i].first, functionNodes) << '\t'
			<< lagrangeSeries((functionNodes[i].first + functionNodes[i + 1].first) / 2, functionNodes) << '\t';
	}

	cout << lagrangeSeries(functionNodes[nodeNumber - 1].first, functionNodes) << '\n';

	return 0;
}