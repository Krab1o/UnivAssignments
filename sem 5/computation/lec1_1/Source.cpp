#include <iostream>
#include <vector>
#include <iomanip>

int main()
{
	double eps,
		sum,
		arg,
		term;
	unsigned int fact = 1,
		stepNumber = 0,
		computationNumber;

	std::vector<double> startArr;
	std::vector<double> sumArr;
	std::vector<double> itArr;

	setlocale(LC_ALL, "Russian");

	std::cout << "Введите число тестов:" << std::endl;
	std::cin >> computationNumber;

	std::cout << std::setprecision(8);

	for (int i = 0; i < computationNumber; i++)
	{
		std::cout << "Введите x" << i << std::endl;
		std::cin >> arg;
		std::cout << "Введите eps" << i << std::endl;
		std::cin >> eps;

		term = arg;
		sum = arg;

		while (abs(term) > eps)
		{
			fact += 2;
			term *= -arg * arg / (fact * (fact - 1));
			sum += term;
			stepNumber++;
		}

		startArr.push_back(arg);
		sumArr.push_back(sum);
		itArr.push_back(stepNumber);

		fact = 1;
		stepNumber = 0;
	}
	std::cout << "Аргумент\t" << "Значение\t" << "Количество итераций\n";
	for (int i = 0; i < startArr.size(); i++)
	{
		std::cout << startArr[i] << "\t\t" << sumArr[i] << '\t' << itArr[i] << '\n';
	}
	return 0;
}