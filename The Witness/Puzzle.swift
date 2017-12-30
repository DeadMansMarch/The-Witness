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

class Puzzle{
    var debug = false;
    
    var width:Int = 0;
    var height:Int = 0;
    
    var generated:Int = 0;
    
    var nodes = [Node]();
    var internodes = [Internode]();
    var intermodifiers = [Internode:Modifier]();
    
    var starts = [Node]();
    var endings = [Node]();
    
    init(width:Int,height:Int){
        self.width = width;
        self.height = height;
    }
    
    init(width:Int,height:Int,starts:[Node],endings:[Node]){
        self.width = width;
        self.height = height;
        
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
        
        self.starts = starts;
        self.endings = endings;
    }
    
    static func create()->Puzzle{
        
        print("Puzzle Max Width: ");
        let width = Interpreter.readInt();
        print("Puzzle Max Height: ");
        let height = Interpreter.readInt();
        print("Created with dimension : (\(width),\(height))");
        
        var starts = [Node]();
        var endings = [Node]();
        
        print("Start Points: (x,y) or x,y");
        
       
        while let node = Interpreter.readNode(){
            print("Adding \(node).");
            starts.append(node);
        }
        
        print("End Points: (x,y) or x,y");
        
        while let node = Interpreter.readNode(){
            print("Adding \(node).");
            endings.append(node);
        }
        
        let created = Puzzle(width:width,height:height,starts:starts,endings:endings);
        
        print("Finished creating puzzle...");
        
        return created;
    }
    
    func modify(position:Node,shape:BlockShape,rotatable:Bool=false){
        self.intermodifiers[position] = ShapeModifier(shape: shape, rotatable: rotatable);
    }
    
    func makeStartingPaths()->[Path]{
        var activePaths = [Path]();
        for start in starts{
            activePaths.append(Path(nodes: [start]));
        }
        return activePaths;
    }
    
    func solve(){
        generated = 0;
        
        
        self.makeStartingPaths().forEach{
            $0.superpolate(from: self, to: endings,verify:self.verify);
        }
    }
    
    func generate(){
        generated = 0;
        self.makeStartingPaths().forEach{
            $0.superpolate(from: self, to: endings,verify:{ path in
                generated += 1;
                print("Path \(generated), \(path.readerDescription)");
                return false;
            });
        }
        print("Generated : \(generated)");
    }
    
    func verify(path:Path)->Bool{
        generated += 1;
        if (generated % 2000 == 0){
            print("Generated: \(generated)");
        }
        
        let shapes = path.breakShapes(from:self);
        for shape in shapes{
            let mods = shape.value.internodes.filter{ self.intermodifiers[$0] != nil }.map{ self.intermodifiers[$0]! }
            
            let shapes = mods.filter{ $0.type == .shape };
            let blocks = mods.filter{ $0.type == .block };
            let stars = mods.filter{ $0.type == .star };
            if shapes.count == 1{ //Shape must be the shape.
                if shape.value.internodes.count != (mods.first! as! ShapeModifier).shape.internodes.count{
                    if debug{
                        print("ABORT LINE A");
                    }
                    return false;
                }else{
                    //print("Start: \(shape.value), End: \(shape.value.refactor())")
                    //print(Set<Internode>(shape.value.refactor()),Set<Internode>((mods.first! as! ShapeModifier).shape.internodes))
                    if Set<Internode>(shape.value.refactor()) == Set<Internode>((mods.first! as! ShapeModifier).shape.internodes){
                        continue;
                    }else{
                        if (debug){
                            print("ABORT LINE B");
                        }
                        return false;
                    }
                }
            }else if shapes.count > 1{//Total shape must contain each shape in some way
                if shapes.reduce(0,{$0 + ($1 as! ShapeModifier).shape.internodes.count}) != shape.value.internodes.count{
                    if debug{
                        print("ABORT LINE C");
                    }
                    return false;
                }else{
                    var shapebin = shapes;
                    
                    var cascadeIteration = 0;
                    func cascading(remaining:[Internode],shapes:[ShapeModifier])->Bool{
                        cascadeIteration += 1;
                        var shapeRemainder = shapes;
                        //print("Arrived at cascade : \(shapes.count) remaining.");
                        
                        let localshape = shapeRemainder.popLast();
                        guard let lshape = localshape else{
                            //print("Found acceptable placement for all modifiers!");
                            //print("<-Going up");
                            return true; //Bottom level.
                        }
                        
                        let fitdata = lshape.shape.fits(in: shape.value.internodes);
                        //print("Fit data returned : \(fitdata.count) possible fit points.");
                        for internodeList in fitdata.values{
                            //print("Going down->");
                            if (cascading(remaining:remaining.filter{ !internodeList.contains($0) },shapes:shapeRemainder)){
                                return true;
                            }
                        }
                        //print("<-Going up");
                        return false;
                    }
                    
                    //print("Cascade start.");
                    let cascadedResult = cascading(remaining:shape.value.internodes,shapes:shapebin as! [ShapeModifier]);
                    
                    if debug && !cascadedResult{
                        print("ABORT LINE D");
                    }
                    if (!cascadedResult){
                        return false;
                    }
                    return false;
                }
            }
            
            if blocks.count > 1{
                let activeColor = (blocks.first! as! BlockModifier).color
                for block in blocks{
                    if (block as! BlockModifier).color != activeColor{
                        print("ABORT LINE E");
                        return false
                    }
                }
            }
        }
        
        return true;
    }
}
