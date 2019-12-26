//
//  Codegen.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

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
        let groupped = Dictionary(grouping: allMembers) { $0.api.name }
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
        
        return requests.values.sorted { $0.api.name <= $1.api.name }
    }
    
}

extension Codegen {

    func generate(using apollo: ApolloReference) throws -> String {
        Console.print(title: "🎨 Writing GraphQL Code", indentation: 1)
        let codeGenRequests = try graphQLCodeGenRequests()

        Console.print(title: "🚀 Delegating some stuff to Apollo codegen", indentation: 1)
        let apolloCode = try codeGenRequests.map { try $0.generate(using: apollo) }

        Console.print(title: "🎁 Bundling it all together", indentation: 1)
        return try code {
            StructureAPI()
            apis
            structs
            Array(allConnectionFragments)
            apolloCode
        }
    }

}

extension Codegen {

    private var allMembers: [MemberOfAPI] {
        let fromConnections = allConnectionFragments.map { MemberOfAPI.fragment($0.fragment) } +
            allConnectionQueries.map { MemberOfAPI.query($0.query) }

        return fromConnections +
            allFragments.map(MemberOfAPI.fragment) +
            allQueries.map(MemberOfAPI.query)
    }

    var allConnectionQueries: OrderedSet<GraphQLConnectionQuery> {
        return structs.flatMap { OrderedSet($0.connectionQueries) }
    }

    var allConnectionFragments: OrderedSet<GraphQLConnectionFragment> {
        return allConnectionQueries.map { $0.fragment }
    }

    var allFragments: [GraphQLFragment] {
        return structs.flatMap { $0.fragments }
    }

    var allQueries: [GraphQLQuery] {
        return structs.compactMap { $0.query }
    }

}
