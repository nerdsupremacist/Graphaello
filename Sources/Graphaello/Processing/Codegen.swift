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
    private let state: Project.State<Stage.Resolved>
    
    init(state: Project.State<Stage.Resolved>) {
        self.state = state
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
            state.apis
            state.structs
            Array(state.allConnectionFragments)
            apolloCode
        }
    }

}

extension Codegen {
    
    private var allMembers: [MemberOfAPI] {
        let fromConnections = state.allConnectionFragments.map { MemberOfAPI.fragment($0.fragment) } +
            state.allConnectionQueries.map { MemberOfAPI.query($0.query) }

        return fromConnections +
            state.allFragments.map(MemberOfAPI.fragment) +
            state.allQueries.map(MemberOfAPI.query)
    }
    
}
