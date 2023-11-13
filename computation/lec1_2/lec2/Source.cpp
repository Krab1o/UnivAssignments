#include <iostream>
#include <vector>
#include <utility>

using namespace std;
const int nodeNumber = 4;

int main()
{
	setlocale(LC_ALL, "ru");
	vector<pair<double, double>> functionNodes = { 
		make_pair(-2, -8), make_pair(-1, -1), make_pair(0, 0), make_pair(2, 8)
	};
	/*
	uint8_t nodeNumber;
	cout << "������� ���������� ����� ������������\n";
	cin >> nodeNumber;
	cout << "������� " << nodeNumber << " ����� ������������\n";
	*/
	for (pair<double, double> val : functionNodes)
	{
		for (int i = nodeNumber - 1; i >= 0; i--)
		{
			cout << pow(val.first, i) << '\t';
		}
		cout << val.second << '\n';
	}
	
	return 0;
}