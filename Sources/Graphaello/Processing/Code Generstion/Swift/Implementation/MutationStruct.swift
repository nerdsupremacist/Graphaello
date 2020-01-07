//
//  MutationStruct.swift
//  
//
//  Created by Mathias Quintero on 1/7/20.
//

import Foundation

struct MutationStruct: SwiftCodeTransformable {
    let mutation: GraphQLMutation
}

extension Struct where CurrentStage: ResolvedStage {

    var mutationStructs: [MutationStruct] {
        return mutations.map { MutationStruct(mutation: $0) }
    }

}
