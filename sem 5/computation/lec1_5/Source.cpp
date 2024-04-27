#include <iostream>
#include <vector>

using namespace std;

const uint32_t nodeNumber = 4;

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

	int splineNum = nodeNumber - 1;

	vector<vector<double>> matrix;
	matrix.resize(4 * splineNum);
	for (int i = 0; i < 4 * splineNum; i++)
	{
		matrix[i].resize(4 * splineNum + 1);
	}

	for (int j = 'a'; j <= 'd'; j++)
	{
		for (int i = 0; i < splineNum; i++)
		{
			cout << char(j) << '_' << i + 1 << '\t';
		}
	}
	cout << 'f' << '\n';

	double h = functionNodes[1].first - functionNodes[0].first;

	for (int i = 0; i < splineNum; i++)
	{
		for (int j = 0; j < 4 * splineNum; j++)
		{
			if (j == i)
				matrix[i][j] = 1;
			else
				matrix[i][j] = 0;
		}
		matrix[i][4 * splineNum] = functionNodes[i].second;
	}
	for (int i = splineNum; i < 2 * splineNum; i++)
	{
		for (int j = 0; j < 4 * splineNum; j++)
		{
			if (j % splineNum == i % splineNum)
				matrix[i][j] = pow(h, (j / splineNum));
			else
				matrix[i][j] = 0;
		}
		matrix[i][4 * splineNum] = functionNodes[i % splineNum + 1].second;
	}
	for (int i = 2 * splineNum; i < 3 * splineNum - 1; i++)
	{
		for (int j = 0; j < 4 * splineNum; j++)
		{
			if (j / splineNum == 1 && j % splineNum - 1 == i % splineNum)
				matrix[i][j] = -1;
			else if (j % splineNum == i % splineNum)
				matrix[i][j] = (j / splineNum) * pow(h, (j / splineNum));
			else
				matrix[i][j] = 0;
		}
	}

	matrix[8][6] = 2;
	matrix[9][7] = 2;
	matrix[8][7] = -2;
	matrix[9][8] = -2;
	matrix[8][9] = 6 * h;
	matrix[9][10] = 6 * h;
	matrix[8][10] = -2;
	//matrix[8][11] = 0;
	//matrix[8][12] = 0;

	matrix[10][6] = 2;
	matrix[11][8] = 2;
	matrix[11][11] = 6 * h;
	//matrix[10][12] = 0;
	//matrix[11][12] = 0;

	for (auto str : matrix)
	{
		for (auto it : str)
		{
			cout << it << '\t';
		}
		cout << '\n';
	}
}