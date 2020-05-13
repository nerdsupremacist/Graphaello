//
//  File.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol ApolloCodegenRequestProcessor {
    func process(request: ApolloCodeGenRequest, using apollo: ApolloReference, cache: PersistentCache<AnyHashable>?) throws -> ApolloCodeGenResponse
}
