//
//  ObjectFieldCall.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct ObjectFieldCall: GraphQLCodeTransformable {
    let field: Field
    let component: GraphQLComponent
}

extension GraphQLObject {
    
    var objectFieldCalls: [ObjectFieldCall] {
        return components
            .sorted { $0.key.name < $1.key.name }
            .map { ObjectFieldCall(field: $0.key, component: $0.value) }
    }
    
}

extension GraphQLQuery {
    
    var objectFieldCalls: [ObjectFieldCall] {
        return components
            .sorted { $0.key.name < $1.key.name }
            .map { ObjectFieldCall(field: $0.key, component: $0.value) }
    }
    
}
