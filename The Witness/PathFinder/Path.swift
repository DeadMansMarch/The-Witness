//
//  Path.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

typealias IsVertical = Bool

struct Path:CustomStringConvertible, Hashable{
    
    static func ==(_ a: Path,_ b: Path)->Bool{
        return Set<Node>(a.nodes) == Set<Node>(b.nodes);
    }
    
    var hashValue: Int{
        return nodes.reduce(0,{ $0 + $1.hashValue });
    }
    
    var nodes = [Node]();
    
    var crossedNodes : ([Node],[Node]){
        if (self.nodes.count == 0){
            return ([Node](),[Node]());
        }
        
        var crossed = ([Node](),[Node]());
        
        //print("Parsing path...");
        for (index, node) in self.nodes.enumerated(){
            if index + 1 >= self.nodes.count{
                break;
            }
            
            let nextNode = self.nodes[index + 1];
            //print("Parsing node intersect : \(node)->\(nextNode)");
            
            let intersects = node.intersection(with: nextNode);
            if (intersects.1){
                //print("\tInserting : Vertical \(intersects.0)");
                crossed.0.append(intersects.0);
            }else{
                //print("\tInserting : Horizontal \(intersects.0)");
                crossed.1.append(intersects.0);
            }
        }
        
        return crossed;
    }
    
    init(nodes:[Node]){
        self.nodes = nodes;
    }
    
    init(nodes:[(Int,Int)]){
        self.nodes = nodes.map{
            Node($0.0,$0.1);
        }
    }
    
    func extended(by node:Node)->Path{
        var newPath = Path(nodes:self.nodes);
        newPath.nodes.append(node);
        return newPath;
    }
    
    func extrapolate(from map:Map)->[Path]{
        let currentEnding = nodes.last!
        let neighborNodes = currentEnding.neighbors(from:map).filter{!self.nodes.contains($0)};
        return neighborNodes.map{
            self.extended(by:$0);
        }
    }
    
    func superpolate(from map:Map,leadingPath:Path,to ending:Node,verify callback:(Path)->Bool){
        var extrapolatedPaths = leadingPath.extrapolate(from: map);
        
        for path in extrapolatedPaths{
            if path.nodes.last! == ending{
                if (callback(path)){
                    print(path);
                }
            }else{
                path.superpolate(from: map, leadingPath: path, to: ending, verify: callback)
            }
        }
    }
    
    func superpolate(from map:Map,to ending:Node,verify callback:(Path)->Bool){
        self.superpolate(from:map,leadingPath:self,to:ending,verify:callback)
    }
    
    func subpath(from:Int,to:Int)->Path{
        return Path(nodes: [Node](self.nodes[from...to]))
    }
    
    func subpath(count:Int)->Path{
        return subpath(from:0,to:count - 1);
    }
    
    enum direction:String{
        case up="up",down="down",left="left",right="right"
    }
    
    var readerDescription: String{
        var rDescription = "";
        for (index,node) in self.nodes.enumerated(){
            if (index + 1 == self.nodes.count){
                break;
            }
            rDescription += " \(node.direction(to: nodes[index + 1])), "
        }
        return rDescription
    }
    
    var description: String{
        return "Path(" + String(describing:nodes) + ")";
    }
    
    func breakShapes(from:Map)->[RayMagNode:BlockShape]{
        
        var shapecollection = [RayMagNode:BlockShape]();
        var shapeassoc = [Node:RayMagNode]();
        
        let crossNode = self.crossedNodes;
        let horizontalCross = crossNode.1;
        let verticalCross = crossNode.0;
        
        //print("Horizontal Crosses: \(horizontalCross)");
        //print("Vertical Crosses: \(verticalCross)");
        from.internodes.forEach{ internode in
            let xcrosses = verticalCross.filter{
                return $0.y == internode.y && $0.x <= internode.x;
            }.count
            
            let ycrosses = horizontalCross.filter{
                $0.x == internode.x && $0.y <= internode.y;
            }.count
            
            //print("Internode \(internode) crossed x: \(xcrosses), y: \(ycrosses).");
            
            let nodalPos:RayMagNode = Node(xcrosses,ycrosses);
            
            if (shapecollection[nodalPos] == nil){
                shapecollection[nodalPos] = BlockShape(internodes:[Node]());
            }
            
            shapeassoc[internode] = nodalPos;
        }
        
        var rayAssoc = [RayMagNode:RayMagNode]();
        
        from.internodes.forEach{ internode in
            let neighbors = internode.neighbors(from: from);
            neighbors.forEach{
                if shapeassoc[$0] != nil{
                    if shapeassoc[$0] != shapeassoc[internode]{
                        //print("Border check between nodes \(internode) and \($0) :");
                        let intersect = internode.intersection(between: $0)
                        //print("\tIntersect position: \(intersect.0)");
                        if intersect.1{
                            if !verticalCross.contains(intersect.0){
                                rayAssoc[shapeassoc[$0]!] = shapeassoc[internode]!;
                                //print("\tAssociating \(shapeassoc[$0]!) with corrected shape \(shapeassoc[internode]!) through node \($0)")
                            }
                        }else{
                            if !horizontalCross.contains(intersect.0){
                                rayAssoc[shapeassoc[$0]!] = shapeassoc[internode]!;
                                //print("\tAssociating \(shapeassoc[$0]!) with corrected shape \(shapeassoc[internode]!) through node \($0)")
                            }
                        }
                    }
                }
            }
            //URGENT TODO : IF no adjacent tiles from referred shape, new RayMagNode.
            //Two shapes on same x y cast will be grouped incorrectly...
            shapecollection[shapeassoc[internode]!]!.internodes.append(internode);
        }
        
        var slaved = Set<RayMagNode>();
        rayAssoc.forEach{
            if slaved.contains($0.key){ return; }
            
            let master = $0.key;
            slaved.insert($0.value);
            if (shapecollection[$0.value] != nil){
                shapecollection[master]!.internodes += shapecollection[$0.value]!.internodes;
            }
            shapecollection.removeValue(forKey: $0.value);
        }
        /*
        for shape in shapecollection{
            print("\(shape.key): \(shape.value.internodes)");
        }
    */
        return shapecollection;
    }
}
