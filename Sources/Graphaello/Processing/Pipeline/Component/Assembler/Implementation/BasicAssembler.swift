//
//  BasicAssembler.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

struct BasicAssembler: Assembler {
    let assembler: RequestAssembler
    
    func assemble(cleaned: Project.State<Stage.Resolved>) throws -> Project.State<Stage.Assembled> {
        let groupped = Dictionary(grouping: cleaned.allMembers) { $0.api.name }
        let requests = try groupped.mapValues { members -> ApolloCodeGenRequest in
            let fragments = members.compactMap { $0.fragment }
            let queries = members.compactMap { $0.query }
            let api = fragments.first?.api ?? queries.first?.api ?! fatalError("No Queries or Fragments in Group")
            return try assembler.assemble(queries: queries, fragments: fragments, for: api)
        }
        
        return cleaned.with { .requests ~> requests.values.sorted { $0.api.name <= $1.api.name } }
    }
    
}

extension BasicAssembler {
    
    init(assembler: () -> RequestAssembler) {
        self.assembler = assembler()
    }
    
}

extension Project.State where CurrentStage: ResolvedStage {
    
    fileprivate enum MemberOfAPI {
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

    fileprivate var allMembers: [MemberOfAPI] {
        let fromConnections = allConnectionFragments.map { MemberOfAPI.fragment($0.fragment) } +
            allConnectionQueries.map { MemberOfAPI.query($0.query) }

        return fromConnections +
            allFragments.map(MemberOfAPI.fragment) +
            allQueries.map(MemberOfAPI.query)
    }
}
