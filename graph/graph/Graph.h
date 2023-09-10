#pragma once

#include <list>
#include <utility>
#include <fstream>
using std::list; 
using std::pair;

template<typename Type>
class Graph
{
public:
	Graph(isOriented);
	Graph(isOriented, &fstream file);
	Graph(const& Graph);

	void AddVertice(const& Type);
	void AddEdge(const uint32_t& startVertice, const uint32_t& endVertice);

	void RemoveVertice(const& Type);
	void RemoveEdge(const uint32_t& startVertice, const uint32_t& endVertice);

	void Save();

private:
	list<list<Type>> adjacencyMatrix;
	bool isOriented;


};