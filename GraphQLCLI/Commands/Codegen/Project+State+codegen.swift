//
//  ProjectState+codegen.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Project.State {
    
    func codegen() throws -> Codegen {
        return Codegen(apis: apis,
                       structs: try structs.graphQLStructs(apis: apis))
    }
    
}
