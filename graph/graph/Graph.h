#pragma once

#include <list>
#include <map>
#include <utility>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

using std::string;
using std::map;
using std::vector;
using std::list; 
using std::pair;
using std::fstream;

class Graph
{
public:

	Graph(bool orient);
	Graph(bool orient, fstream& file);
	Graph(const Graph& copiedValue);

	void AddVertice(const string& value);
	void AddEdge(const string& startVertice, const string& endVertice, const int32_t& weight);

	void RemoveVertice(const string& vertice);
	void RemoveEdge(const string& startVertice, const string& endVertice);

	void Save();

private:
	map<string, list<pair<string, int32_t>>*> adjacencyMatrix;
	bool isOriented;

	NLOHMANN_DEFINE_TYPE_INTRUSIVE(Graph, adjacencyMatrix, isOriented)
};