//
//  main.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

var puzzle = Puzzle(width:5,height:5,starts:[Node(0,0)],endings:[Node(5,5)]);

puzzle.modify(position:Node(3,3),shape: BlockShape.dot, rotatable: false);
puzzle.modify(position:Node(1,3),shape: BlockShape.twohorizontal, rotatable: false);
puzzle.modify(position:Node(5,5),shape: BlockShape.fourvertical, rotatable: false);
//puzzle.solve();

let puzzle1 = Path(nodes: [Node(0,0),Node(0,1),Node(0,2),Node(1,2),Node(1,3),Node(1,4),Node(2,4),Node(2,3),Node(2,2),Node(2,1),Node(2,0)])
let puzzle2 = Path(nodes: [Node(0,0),Node(0,1),Node(0,2),Node(1,2),Node(1,3),Node(1,4),Node(1,5),Node(2,5),Node(2,4),Node(2,3),Node(2,2),Node(2,1),Node(2,0)])

let multipathtest = Path(nodes: [(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(1,5),(1,4),(1,3),(1,2),(1,1),(1,0),(2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(3,5),(3,4),(3,3),(3,2),(3,1),(3,0),(4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(5,5)]);

let multipathsegmenttest = Path(nodes: [(0,0),(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(2,5),(2,4),(2,3),(2,2),(2,1),(2,0),(3,0),(3,1),(3,2),(4,2),(4,1),(4,0),(5,0),(5,1),(5,2),(5,3),(5,4),(5,5)])
print(multipathsegmenttest.breakShapes(from: puzzle));
