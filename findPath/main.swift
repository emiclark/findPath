//
//  main.swift
//  findPath
//
//  Created by Emiko Clark on 11/23/17.
//  Copyright © 2017 Emiko Clark. All rights reserved.
//

import Foundation

// basic vertex data structure
class Vertex:  Hashable {
    var name: String
    var next: Vertex?
    
    var hashValue: Int {
        return self.name.hashValue
    }
    
    init(name: String) {
        self.name = name
    }
    
}

// basic edge data structure
class Edge {
    var from: Vertex
    var to: Vertex
    var weight: Int?

    init(from: Vertex, to: Vertex, weight: Int) {
        self.from  = from
        self.to = to
        self.weight = weight
    }
}

class EdgeList{
    
    var vertex: Vertex
    var edges: [Edge]
    
    init(vertex: Vertex, edges: [Edge]) {
        self.vertex = vertex
        self.edges = edges
    }
    
    func addEdge(edgesArray: [Edge], edge: Edge) -> [Edge] {
        
        var newEdgeList = edgesArray
        newEdgeList.append(edge)
        return newEdgeList
    }
}

class Queue {
    var front: Vertex?
    var rear: Vertex?
    
    init() {
        self.front = rear
    }
    
    func addVertex(vertex: Vertex) {
        let newVertex = vertex
        if front == nil {
            // nothing in queue, add 1st element
            front = newVertex
            rear = newVertex
        } else {
            // append to new vertex to rear of queue
            rear?.next = newVertex
            rear = newVertex
        }
    }
    
    func removeAll() {
        front = nil
        rear = front
    }
    
    func getNextVertexInQueue() -> Vertex? {
        let nextVertex = front
        if front?.next != nil {
            front = (front?.next)!
        } else {
            front = nil
        }
        return nextVertex
    }
}


// default directed graph canvas
public class Graph {
    
    var graph = [EdgeList]()
    var queue = Queue()
    var foundPath = false
    var visited = Set<Vertex>()
    var path = ""
    
    public var isDirected: Bool
    
    init() {
        isDirected = true
        initializeGraph()
    }
    
    func hasPath(betweenSourceVertex v1: Vertex, andDestinationVertex v2: Vertex) {
        var nextVertex: Vertex?
        foundPath = false
        path = ""
        visited.removeAll()
        queue.removeAll()

        nextVertex = v1
        
        // process while there are verticies in the queue
        while (foundPath == false && nextVertex != nil) {
            
            // nextVertex as visited by adding it to the visited set
            if visited.contains(nextVertex!) == false {
                visited.insert(nextVertex!)
                path += " \(String(describing: nextVertex?.name))"
                
                // start: add children of nextVertex to queue for processing
                for each in graph {
                    for edge in each.edges {
                        if edge.from == nextVertex {
                            queue.addVertex(vertex: edge.to)
                        }
                    }
                }
            }
        
            if visited.count > 0 {
                // dequeue next vertex if anything in queue
                let nextV = queue.getNextVertexInQueue()
                if nextV != nil {
                    nextVertex = nextV!
                } else {
                    nextVertex = nil
                    continue
                }
            }
        
            if nextVertex == v2 {
                print("There is a path from \(v1.name) to \(v2.name)")
                foundPath = true
            }
        }
        if !foundPath {
            print("There is NO path between \(v1.name) and \(v2.name)")
        }
    }
    
    func initializeGraph() {

        let v1 = Vertex(name: "A")
        let v2 = Vertex(name: "B")
        let v3 = Vertex(name: "C")
        let v4 = Vertex(name: "D")
        let v5 = Vertex(name: "E")
        let v6 = Vertex(name: "F")
        
        let e1 = Edge(from: v1, to: v2, weight: 1)
        let e1a = Edge(from: v1, to: v4, weight: 1)
        let e1b = Edge(from: v1, to: v3, weight: 1)
        var edgeArr1 = [Edge]()
        edgeArr1.append(e1)
        edgeArr1.append(e1a)
        edgeArr1.append(e1b)
        let edgeList1 = EdgeList(vertex: v1, edges: edgeArr1)
        
        let e2 = Edge(from: v2, to: v3, weight: 1)
        var edgeArr2 = [Edge]()
        edgeArr2.append(e2)
        let edgeList2 = EdgeList(vertex: v2, edges: edgeArr2)
        
        let e3 = Edge(from: v6, to: v5, weight: 1)
        var edgeArr3 = [Edge]()
        edgeArr3.append(e3)
        let edgeList3 = EdgeList(vertex: v3, edges: edgeArr3)

        let e4 = Edge(from: v2, to: v1, weight: 1)
        var edgeArr4 = [Edge]()
        edgeArr4.append(e4)
        let edgeList4 = EdgeList(vertex: v4, edges: edgeArr4)

        let e5 = Edge(from: v4, to: v5, weight: 1)
        var edgeArr5 = [Edge]()
        edgeArr5.append(e5)
        let edgeList5 = EdgeList(vertex: v5, edges: edgeArr5)
        
        graph.append(edgeList1)
        graph.append(edgeList2)
        graph.append(edgeList3)
        graph.append(edgeList4)
        graph.append(edgeList5)
    }
    
    
    func printGraph() {
        
        for (i, each) in graph.enumerated()  {
            let edgeArray = each
            for eachEdge in edgeArray.edges {
                print(i, eachEdge.from.name, eachEdge.to.name)
            }
        }
    }
}

extension Vertex: Equatable {
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.name == rhs.name
    }
}

let graph = Graph()
print("\nGraph and adjacency List")
graph.printGraph()

print("\nFind path between A and D")
graph.hasPath(betweenSourceVertex: Vertex(name: "A" ), andDestinationVertex: Vertex(name: "D"))
print("\nFind path between B and D")
graph.hasPath(betweenSourceVertex: Vertex(name: "B" ), andDestinationVertex: Vertex(name: "D"))
print("\nFind path between C and E")
graph.hasPath(betweenSourceVertex: Vertex(name: "C" ), andDestinationVertex: Vertex(name: "E"))
print("\nFind path between B and F")
graph.hasPath(betweenSourceVertex: Vertex(name: "B" ), andDestinationVertex: Vertex(name: "F"))

