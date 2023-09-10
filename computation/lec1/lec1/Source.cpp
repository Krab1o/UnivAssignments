#include <iostream>
#include <vector>

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

	std::cout << "¬ведите число тестов:" << std::endl;
	std::cin >> computationNumber;

	for (int i = 0; i < computationNumber; i++)
	{
		std::cout << "¬ведите eps" << i << std::endl;
		std::cin >> eps;
		std::cout << "¬ведите x" << i << std::endl;
		std::cin >> arg;

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
	}

	for (auto x : startArr)
	{
		std::cout << x << '\t';
	}
	std::cout << std::endl;
	for (auto x : sumArr)
	{
		std::cout << x << '\t';
	}
	std::cout << std::endl;
	for (auto x : itArr)
	{
		std::cout << x << '\t';
	}

	
	
	return 0;
}