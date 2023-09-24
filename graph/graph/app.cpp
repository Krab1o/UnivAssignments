#include <iostream>
#include "Graph.h"
#include <string>

void initialMessage()
{
	std::cout << "Select command:" << '\n'
		<< "1 - Print Vertices" << '\n'
		<< "2 - Add vertice" << '\n'
		<< "3 - Remove vertice" << '\n'
		<< "4 - Add edge" << '\n'
		<< "5 - Remove edge" << '\n'
		<< "Press 'q' to exit";
}

int main()
{
	string enteredValue = "";
	while (enteredValue != "q")
	{
		initialMessage();
		if (enteredValue == "1")
		{

		}
		if (enteredValue == "2")
		{

		}
		if (enteredValue == "3")
		{

		}
		if (enteredValue == "4")
		{

		}
		if (enteredValue == "5")
		{

		}
		std::cin >> enteredValue;
	}
	return 0;
}