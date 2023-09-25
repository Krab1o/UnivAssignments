#include <iostream>
#include "Graph.h"
#include <string>

void InitialMessage()
{
	std::cout << "Select command:" << '\n'
		<< "1 - Print Vertices" << '\n'
		<< "2 - Add vertice" << '\n'
		<< "3 - Remove vertice" << '\n'
		<< "4 - Add edge" << '\n'
		<< "5 - Remove edge" << '\n'
		<< "Press 'q' to exit" << '\n';
}

Graph* CreateGraph()
{
	string enteredValue = "";
	std::cout << "No graph found. Choose directed or undirected graph" << '\n'
		<< "1 - Directed graph" << '\n'
		<< "2 - Undirected graph" << std::endl;
	while (enteredValue != "1" && enteredValue != "2")
	{
		std::cin >> enteredValue;
		if (enteredValue == "1")
		{
			std::cout << "Created a new graph";
			return new Graph(true);
		}
		if (enteredValue == "2")
		{
			std::cout << "Created a new graph";
			return new Graph(false);
		}
		else
		{
			std::cout << "Invalid value";
		}
	}
}

int main()
{
	Graph* graph;
	string enteredValue = "";
	string verticeTitle1 = "";
	string verticeTitle2 = "";
	graph = CreateGraph();
	while (enteredValue != "q")
	{
		InitialMessage();
		std::cin >> enteredValue;
		if (enteredValue == "1")
		{

		}
		if (enteredValue == "2")
		{
			std::cout << "Enter vertice title" << '\n';
			std::cin >> verticeTitle1;
			graph->AddVertice(verticeTitle1);
		}
		if (enteredValue == "3")
		{

		}
		if (enteredValue == "4")
		{
			std::cout << "Enter start vertice" << '\n';
			std::cin >> verticeTitle1;
			std::cout << "Enter end vertice" << '\n';
			std::cin >> verticeTitle2;
			graph->AddEdge(verticeTitle1, verticeTitle2);
		}
		if (enteredValue == "5")
		{

		}
	}
	graph->Save();
	return 0;
}