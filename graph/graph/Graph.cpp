#include "Graph.h"
#include <iostream>

Graph::Graph(bool isOriented)
{
	this->isOriented = isOriented;
}

Graph::Graph(ofstream& file)
{
	
}

Graph::Graph(const Graph& copiedValue)
{
	//TODO: json handling

}

void Graph::AddVertice(const string& vertice)
{
	//TODO
	adjacencyMatrix[vertice];
}

void Graph::AddEdge(const string& startVertice, const string& endVertice, const int32_t& weight)
{
	adjacencyMatrix[startVertice][endVertice] = weight;
	if (!isOriented)
		adjacencyMatrix[endVertice][startVertice] = weight;
}

void Graph::RemoveVertice(const string& vertice)
{
	adjacencyMatrix.erase(vertice);
}

void Graph::RemoveEdge(const string& startVertice, const string& endVertice)
{
	adjacencyMatrix[startVertice].erase(endVertice);
	if (!isOriented)
	{
		adjacencyMatrix[endVertice].erase(startVertice);
	}
}

void Graph::Save()
{
	json j = *this;
	std::ofstream data("data.json");
	data << std::setw(4) << j;
}

//TODO: create json to_file and json from_file

void to_json(json& j, const Graph& graph)
{
	j["orient"] = graph.isOriented;
	for (auto const& mapEl : graph.adjacencyMatrix)
	{
		j["vertices"][mapEl.first] = mapEl.second;
	}
}

void from_json(const json& j, Graph& graph)
{
	j.at("orient").get_to(graph.isOriented);
	j.at("vertices").get_to(graph.adjacencyMatrix);
}