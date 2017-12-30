//
//  main.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

let k = Map(width:5,height:5);
var generation = 0;
k.generatePaths(from: Node(0,0), to: Node(5,5), with: { path in
    generation += 1;
    print("Generation : \(generation)")
    return true;
})


