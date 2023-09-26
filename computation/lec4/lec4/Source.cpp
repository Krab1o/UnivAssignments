#include <iostream>
#include <vector>
#include <iomanip>

using namespace std;

int main()
{
	vector<pair<double, double>> functionNodes =
	{
		make_pair(-2, -8),
		make_pair(-1, -1),
		make_pair(0, 0),
		make_pair(2, 8)
	};

	vector<vector<double>> divDiff;
	divDiff.resize(4);
	for (int i = 0; i < 4; i++)
	{
		divDiff[i].resize(4);
	}

	for (int j = 0; j < 4; j++)
	{
		divDiff[0][j] = functionNodes[j].second;
	}

	for (int i = 1; i < 4; i++)
	{
		for (int j = 0; j < 4 - i; j++)
		{
			double a = divDiff[i - 1][j + 1] - divDiff[i - 1][j];
			double b = functionNodes[j + i].first - functionNodes[j].first;
			divDiff[i][j] = (divDiff[i - 1][j + 1] - divDiff[i - 1][j]) /
				(functionNodes[j + i].first - functionNodes[j].first);
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
}