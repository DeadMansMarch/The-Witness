//
//  Modifier.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

protocol Modifier{
    var type:modification {get};
}

enum modification{
    case shape,star,block;
}

enum Color{
    case red,green,blue,white,black,purple,none;
}


struct BlockShape:CustomStringConvertible{
    var internodes:[Internode];
    
    var description: String{
        return "Shape: " + internodes.description;
    }
    
    func transformedNodes(_ x:Int,_ y:Int)->[Internode]{
        return self.internodes.map{ $0.translate(x, y) }
    }
    
    func transform(_ x:Int,_ y:Int)->BlockShape{
        return BlockShape(internodes: transformedNodes(x, y));
    }
    
    func refactor()->[Internode]{
        //print(internodes);
        var minx = internodes.min(by: {
            $0.x <= $1.x
        })!.x - 1
        var miny = internodes.min(by: {
            $0.y <= $1.y
        })!.y - 1
        
        return self.transformedNodes(-minx, -miny);
    }
    
    func containedInPoints(_ internodes:[Internode])->Bool{
        for internode in self.internodes{
            if !internodes.contains(internode){
                return false;
            }
        }
        return true;
    }
    
    init(internodes:[Node]){
        self.internodes = internodes;
    }
    
    init(internodes:[(Int,Int)]){
        self.internodes = internodes.map{ Node($0.0,$0.1) }
    }
    
    func rotations()->[BlockShape]{
        var rotations = [BlockShape]()
        
        rotations.append(self);
        
        return rotations;
    }
    
    func fits(in points: [Internode])->[Internode:[Internode]]{
        var fits = [Internode:[Internode]]();
        for internode in points{
            let shape = self.transform(internode.x - 1, internode.y - 1);
            if (shape.containedInPoints(points)){
                fits[internode] = shape.internodes;
            }
            
        }
        
        return fits;
    }
    
    static let dot = BlockShape(internodes:[(1,1)]);
    static let threevertical = BlockShape(internodes:[(1,1),(1,2),(1,3)]);
    static let threehorizontal = BlockShape(internodes:[(1,1),(2,1),(3,1)]);
    static let twovertical = BlockShape(internodes:[(1,2),(1,2)]);
    static let twohorizontal = BlockShape(internodes:[(1,1),(2,1)]);
    static let fourvertical = BlockShape(internodes:[(1,1),(1,2),(1,3),(1,4)]);
    static let fourhorizontal = BlockShape(internodes:[(1,1),(2,1),(3,1),(4,1)]);
    static let vertical3left1 = BlockShape(internodes:[(2,1),(2,2),(2,3),(1,3)]);
    static let vertical3right1 = BlockShape(internodes:[(1,1),(1,2),(1,3),(2,3)]);
    static let down1horizontal3 = BlockShape(internodes:[(1,1),(1,2),(2,2),(3,2)]);
    static let up1horizontal3 = BlockShape(internodes:[(1,2),(1,1),(2,1),(3,1)]);
}

struct BlockModifier : Modifier{
    let type:modification = .block;
    var color:Color;
    
    init(color:Color){
        self.color = color;
    }
}

struct ShapeModifier : Modifier, CustomStringConvertible{
    let type:modification = .shape;
    
    var shape:BlockShape;
    var rotatable:Bool;
    
    var description: String{
        return "MOD : \(shape)";
    }
    
    init(shape:BlockShape,rotatable:Bool=false){
        self.shape = shape;
        self.rotatable=rotatable;
    }
}
