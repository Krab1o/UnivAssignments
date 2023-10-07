#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

const uint32_t nodeNumber = 4;

double newtoneSeries(double x, vector<vector<double>>& divDiff, const vector<pair<double, double>>& functionNodes)
{
	double ans = divDiff[0][0];
	double currentProd = 1;

	for (int j = 1; j < 4; j++)
	{
		for (int i = 0; i < 4 - j; i++)
		{
			divDiff[i][j] = (divDiff[i + 1][j - 1] - divDiff[i][j - 1]) / (functionNodes[i + j].first - functionNodes[i].first);
		}
		currentProd *= (x - functionNodes[j - 1].first);
		ans += divDiff[0][j] * currentProd;
	}
	return ans;
}

int main()
{
	vector<pair<double, double>> functionNodes =
	{
		make_pair(-2, -8),
		make_pair(-1, -1),
		make_pair(0, 0),
		make_pair(2, 8)
	};

	cout << "x:\t";
	for (pair<double, double> val : functionNodes)
		cout << val.first << '\t';
	cout << '\n';
	cout << "f:\t";
	for (pair<double, double> val : functionNodes)
		cout << val.second << '\t';
	cout << '\n' << '\n';

	vector<vector<double>> divDiff;
	divDiff.resize(4);
	for (int i = 0; i < 4; i++)
	{
		divDiff[i].resize(4 - i);
		divDiff[i][0] = functionNodes[i].second;
	}

	for (int j = 1; j < 4; j++)
	{
		for (int i = 0; i < 4 - j; i++)
		{
			divDiff[i][j] = (divDiff[i + 1][j - 1] - divDiff[i][j - 1]) / (functionNodes[i + j].first - functionNodes[i].first);
		}
	}

	for (auto el : divDiff)
	{
		for (auto el2 : el)
		{
			cout << setprecision(4) << el2 << '\t';
		}
		cout << '\n';
	}
	cout << '\n';

	for (int i = 0; i < nodeNumber - 1; i++)
	{
		cout << functionNodes[i].first << '\t'
			<< (functionNodes[i].first + functionNodes[i + 1].first) / 2 << '\t';
	}
	cout << functionNodes[nodeNumber - 1].first << '\n';

	for (int i = 0; i < nodeNumber - 1; i++)
	{
		cout << newtoneSeries(functionNodes[i].first, divDiff, functionNodes) << '\t'
			<< newtoneSeries((functionNodes[i].first + functionNodes[i + 1].first) / 2, divDiff, functionNodes) << '\t';
	}

	cout << newtoneSeries(functionNodes[nodeNumber - 1].first, divDiff, functionNodes) << '\n';
}