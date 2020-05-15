import Foundation

struct BasicAssembler: Assembler {
    let assembler: RequestAssembler
    
    func assemble(cleaned: Project.State<Stage.Cleaned>) throws -> Project.State<Stage.Assembled> {
        let groupped = Dictionary(grouping: cleaned.allMembers) { $0.api.name }
        let requests = try groupped.mapValues { members -> ApolloCodeGenRequest in
            let fragments = members.compactMap { $0.fragment }
            let queries = members.compactMap { $0.query }
            let mutations = members.compactMap { $0.mutation }
            let api = members.first?.api ?! fatalError("No Queries, Fragments or Mutations in Group")

            return try assembler.assemble(queries: queries,
                                          fragments: fragments,
                                          mutations: mutations,
                                          for: api)
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
        case mutation(GraphQLMutation)
        
        var api: API {
            switch self {
            case .fragment(let fragment):
                return fragment.api
            case .query(let query):
                return query.api
            case .mutation(let mutation):
                return mutation.api
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

        var mutation: GraphQLMutation? {
            guard case .mutation(let mutation) = self else { return nil }
            return mutation
        }
    }

    fileprivate var allMembers: [MemberOfAPI] {
        let fromConnections = allConnectionFragments.map { MemberOfAPI.fragment($0.fragment) } +
            allConnectionQueries.map { MemberOfAPI.query($0.query) }

        return fromConnections +
            allFragments.map(MemberOfAPI.fragment) +
            allQueries.map(MemberOfAPI.query) +
            allMutations.map(MemberOfAPI.mutation)
    }
}
