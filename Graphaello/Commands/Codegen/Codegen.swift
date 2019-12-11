//
//  Codegen.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Codegen {
    let apis: [API]
    let structs: [GraphQLStruct]
    
    init(apis: [API], structs: [GraphQLStruct]) {
        self.apis = apis
        self.structs = structs.sorted { $0.definition.name <= $1.definition.name }
    }
}

extension Codegen {
    
    private enum MemberOfAPI {
        case fragment(GraphQLFragment)
        case query(GraphQLQuery)
        
        var api: API {
            switch self {
            case .fragment(let fragment):
                return fragment.api
            case .query(let query):
                return query.api
            }
        }
        
        var fragment: GraphQLFragment? {
            guard case .fragment(let fragment) = self else { return nil }
            return fragment
        }
        
        var query: GraphQLQuery? {
            guard case .query(let query) = self else { return nil }
            return query
        }
    }
    
    private func graphQLCodeGenRequests() throws -> [ApolloCodeGenRequest] {
        let members = structs.flatMap { $0.fragments }.map(MemberOfAPI.fragment) +
            structs.compactMap { $0.query }.map(MemberOfAPI.query)
        
        let groupped = Dictionary(grouping: members) { $0.api.name }
        let requests = try groupped.mapValues { members -> ApolloCodeGenRequest in
            let fragments = members.compactMap { $0.fragment }
            let queries = members.compactMap { $0.query }
            let graphQLCode = try code {
                fragments
                queries
            }
            
            return ApolloCodeGenRequest(api: fragments.first?.api ?? queries.first!.api,
                                        code: graphQLCode)
        }
        
        return Array(requests.values)
    }
    
}

extension Codegen {

    func generate() throws -> String {
        let codeGenRequests = try graphQLCodeGenRequests()
        
        print(codeGenRequests.first!.code)
        
        return try code {
            StructureAPI()
            apis
            structs
        }
    }

}
