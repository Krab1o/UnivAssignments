#include "Graph.h"
#include <nlohmann/json.hpp>

Graph::Graph(bool isOriented)
{
	this->isOriented = isOriented;
}

Graph::Graph(fstream& file)
{
	//TODO: json files parsing
}

Graph::Graph(const Graph& copiedValue)
{
	//TODO: json handling

}

void Graph::AddVertice(const string& vertice)
{
	adjacencyMatrix[vertice] = new list<pair<string, int32_t>>;
}

void Graph::AddEdge(const string& startVertice, const string& endVertice, const int32_t& weight)
{
	adjacencyMatrix[startVertice]->push_back(pair<string, int32_t>(endVertice, weight));
	if (!isOriented)
	{
		adjacencyMatrix[endVertice]->push_back(pair<string, int32_t>(startVertice, weight));
	}
}

void Graph::RemoveVertice(const string& vertice)
{
	delete adjacencyMatrix[vertice];
	adjacencyMatrix.erase(vertice);
}

void Graph::RemoveEdge(const string& startVertice, const string& endVertice)
{
	auto lst = adjacencyMatrix[startVertice];
	list<pair<string, int32_t>>::iterator erased;

	for (auto it = lst->begin(); it != lst->end(); it++)
	{
		if (it->first == endVertice)
		{
			lst->erase(it);
			break;
		}
	}

	if (!isOriented)
	{
		lst = adjacencyMatrix[endVertice];
		for (auto it = lst->begin(); it != lst->end(); it++)
		{
			if (it->first == startVertice)
			{
				lst->erase(it);
				break;
			}
		}
	}
}

void Graph::Save()
{
	json j = *this;
	std::ofstream data("data.json");
	data << j;
}

//TODO: create json to_file and json from_file

void to_json(json& j, const Graph& graph)
{
	j["orient"] = graph.isOriented;
	for (auto const& mapEl : graph.adjacencyMatrix)
	{
		for (auto const& listEl : *mapEl.second)
		{
			j[mapEl.first] = { {listEl.first, listEl.second} };
		}
	}
}

void from_json(const json& j, Graph& graph)
{

}