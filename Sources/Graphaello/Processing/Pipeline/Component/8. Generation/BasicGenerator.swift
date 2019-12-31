//
//  BasicGenerator.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

struct BasicGenerator: Generator {
    
    func generate(prepared: Project.State<Stage.Prepared>) throws -> String {
        return try code {
            StructureAPI()
            prepared.apis
            prepared.structs
            Array(prepared.allConnectionFragments)
            prepared.responses.map { $0.code }
        }
    }
    
}
