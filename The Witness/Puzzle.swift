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

._._._._.
|*|*|*|*|
|*|*|*|*|
|*|*|*|*|
|*|*|*|*|
._._._._.
 
 */

class Puzzle{
    var width:Int = 0;
    var height:Int = 0;
    
    var generated:Int = 0;
    
    var nodes = [Node]();
    var internodes = [Node]();
    var intermodifiers = [InternodalModifier]();
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
        self.intermodifiers.append(InternodalModifier(position:position,modifier:ShapeModifier(shape: shape, rotatable: rotatable)));
    }
    
    func solve(){
        generated = 0;
        var activePaths = [Path]();
        for start in starts{
            activePaths.append(Path(nodes: [start]));
        }
        
        activePaths.forEach{
            $0.superpolate(from: self, to: endings);
        }
    }
    
    func verify(path:Path)->Bool{
        generated += 1;
        if (generated % 2000 == 0){
            print("Generated: \(generated)");
        }
        
        path.breakShapes(from:self);
        return false;
    }
}
