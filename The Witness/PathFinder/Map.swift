//
//  Puzzle.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation


/*

Node : x and y from 0 ... dimension
Internode : x and y from 1...dimension
IntersectNode : x and y measured in directional unit,
    from 1 to dimension on native and from 1 to dimension + 1 on non-native.
RayMagNode : XInt, YInt from lowest edge.
._._._._.
|*|*|*|*|
|*|*|*|*|
|*|*|*|*|
|*|*|*|*|
._._._._.
 
 */

class Map{
    var debugEnabled = false;
    
    var nodes = [Node]();
    var internodes = [Internode]();
    
    init(width:Int,height:Int){
        for x in 0...width{
            for y in 0...height{
                self.nodes.append(Node(x,y));
            }
        }
        
        for x in 1...width{
            for y in 1...height{
                self.internodes.append(Node(x,y));
            }
        }
    }
    
    func generatePaths(from start:Node, to end:Node,with callback:((Path)->Bool)?){
        start.asPath().superpolate(from: self, to: end,verify:{ path in
            if (callback != nil){
                callback!(path);
            }
            
            return false;
        });
    }
    
}
