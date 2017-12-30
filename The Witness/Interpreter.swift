//
//  Interpreter.swift
//  The Witness
//
//  Created by Liam Pierce on 12/24/17.
//  Copyright © 2017 Virtual Earth. All rights reserved.
//

import Foundation

class Interpreter{
    static func readInt()->Int{
        let read = readLine();
        if read != nil && Int(read!) != nil{
            return Int(read!)!;
        }
        return Interpreter.readInt();
    }
    
    static func readNode()->Node?{
        let input = readLine();
        
        guard let coor = input, input! != "" else{
            return nil;
        }
        
        let split = coor.trimmingCharacters(in: CharacterSet(charactersIn:"0123456789,").inverted).split(separator:",");
        
        guard split.count == 2 else{
            return Interpreter.readNode();
        }
        
        let x = Int(split[0]);
        let y = Int(split[1]);
        
        guard x != nil && y != nil else{
            return Interpreter.readNode();
        }
        
        return Node(x!,y!);
    }
}
