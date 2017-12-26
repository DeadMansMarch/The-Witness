//
//  Internode.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

typealias Internode = Node;
typealias IntersectNode = Node;
typealias RayMagNode = Node;

struct Node:Hashable,CustomStringConvertible{
    
    static func ==(a:Node, b:Node)->Bool{
        return a.x == b.x && a.y == b.y;
    }
    
    var hashValue: Int{
        return (x + 100) * y
    }
    
    let x:Int;
    let y:Int;
    
    init(_ x:Int,_ y: Int){
        self.x = x;
        self.y = y;
    }
    
    var description: String{
        return "(\(x), \(y))";
    }
    
    func neighbors(from:Puzzle)->[Node]{
        var neighbors = [Node]();
        if (x > 0){
            neighbors.append(Node(x - 1,y));
        }
        
        if (y > 0){
            neighbors.append(Node(x,y - 1));
        }
        
        if (x < from.width){
            neighbors.append(Node(x + 1,y));
        }
        
        if (y < from.height){
            neighbors.append(Node(x,y + 1));
        }
        
        return neighbors;
    }
    
    func translate(_ x:Int,_ y:Int)->Node{
        return Node(self.x + x,self.y + y);
    }
    
    func distance(to node: Node)->Node{
        return Node(self.x - node.x,self.y - node.y);
    }
    
    func intersection(with:Node)->(IntersectNode,IsVertical){
        if self.x == with.x{
            //print("\tIntersect Type: Vertical")
            if (self.y < with.y){
                return (with.translate(1,0),true)
            }else{
                return (self.translate(1,0),true)
            }
        }else{
            //print("\tIntersect Type: Horizontal")
            if (self.x < with.x){
                return (with.translate(0, 1),false);
            }else{
                return (self.translate(0, 1),false);
            }
        }
    }
    
    func intersection(between with:Internode)->(IntersectNode,IsVertical){
        if self.y == with.y{
            //print("\tIntersect Type: Vertical")
            if (self.x < with.x){
                return (with,true)
            }else{
                return (self,true)
            }
        }else{
            //print("\tIntersect Type: Horizontal")
            if (self.y < with.y){
                return (with,false);
            }else{
                return (self,false);
            }
        }
    }
}
