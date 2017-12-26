//
//  Modifier.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

enum modification{
    case shape,star,block;
}

/* shape */
struct BlockShape{
    var internodes:[Node];
    
    static let dot = BlockShape(internodes:[Node(1,1)]);
    static let threevertical = BlockShape(internodes:[Node(1,1),Node(1,2),Node(1,3)]);
    static let threehorizontal = BlockShape(internodes:[Node(1,1),Node(2,1),Node(3,1)]);
    static let twovertical = BlockShape(internodes:[Node(1,2),Node(1,2)]);
    static let twohorizontal = BlockShape(internodes:[Node(1,1),Node(2,1)]);
    static let fourvertical = BlockShape(internodes:[Node(1,1),Node(1,2),Node(1,3),Node(1,4)]);
    static let fourhorizontal = BlockShape(internodes:[Node(2,1),Node(2,1),Node(3,1),Node(4,1)]);
}

/* star */

enum Color{
    case red,green,blue;
}

protocol Modifier{
    var type:modification {get};
    
}

struct ShapeModifier : Modifier{
    let type:modification = .shape;
    
    var shape:BlockShape;
    var rotatable:Bool;
    
    init(shape:BlockShape,rotatable:Bool=false){
        self.shape = shape;
        self.rotatable=rotatable;
    }
}
