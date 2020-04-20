//
//  BasicGenerator.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

struct BasicGenerator: Generator {
    
    func generate(prepared: Project.State<Stage.Prepared>) throws -> String {
        return try code(context: ["usedTypes" : prepared.usedTypes]) {
            StructureAPI()
            prepared.apis
            prepared.structs
            Array(prepared.allConnectionFragments)
            prepared.responses.map { $0.code }
        }
    }
    
}

extension Project.State where CurrentStage == Stage.Prepared {

    var usedTypes: Set<Schema.GraphQLType> {
        return structs.reduce([]) { $0.union($1.usedTypes) }
    }

}

extension Struct where CurrentStage == Stage.Prepared {

    var usedTypes: Set<Schema.GraphQLType> {
        return properties.reduce([]) { $0.union($1.usedTypes) }
    }

}

extension Property where CurrentStage == Stage.Prepared {

    var usedTypes: Set<Schema.GraphQLType> {
        guard let path = graphqlPath else { return [] }
        return [path.components.last!.validated.underlyingType]
    }

}
