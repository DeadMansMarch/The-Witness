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
    
    func neighbors(from map:Map)->[Node]{
        var neighbors = [Node]();
        
        let xLeft = Node(x - 1,y);
        let xRight = Node(x + 1,y);
        let yUp = Node(x,y + 1);
        let yDown = Node(x,y - 1);
        
        if (map.internodes.contains(xLeft)){
            neighbors.append(xLeft);
        }
        
        if (map.nodes.contains(xRight)){
            neighbors.append(xRight);
        }
        
        if (map.nodes.contains(yUp)){
            neighbors.append(yUp);
        }
        
        if (map.nodes.contains(yDown)){
            neighbors.append(yDown);
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
    
    func direction(to: Node)->Path.direction{
        if (self.x == to.x){
            if self.y < to.y{
                return Path.direction.up;
            }else{
                return Path.direction.down;
            }
        }else{
            if self.x < to.x{
                return Path.direction.right;
            }else{
                return Path.direction.left;
            }
        }
    }
    
    func asPath()->Path{
        return Path(nodes: [self])
    }
}
