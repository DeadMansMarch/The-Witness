//
//  Puzzle.swift
//  The Witness
//
//  Created by Liam Pierce on 12/29/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

//Not needed / not good. Was for "the witness", now useless.

class Puzzle : Map{
    
    var starts: [Node];
    var endings: [Node];
    
    var intermodifiers = [Internode:Modifier]()
    
    init(width:Int,height:Int,starts:[Node],endings:[Node]){
        self.starts = starts;
        self.endings = endings;
        super.init(width: width, height: height);
    }
 
    static func create()->Map{
        
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
}
