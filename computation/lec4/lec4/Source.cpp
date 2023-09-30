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
		divDiff[i].resize(4 - i);
		divDiff[i][0] = functionNodes[i].second;
	}

	double x;
	cin >> x;
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

	for (auto el : divDiff)
	{
		for (auto el2 : el)
		{
			cout << setprecision(4) << el2 << '\t';
		}
		cout << '\n';
	}
	cout << ans;
}