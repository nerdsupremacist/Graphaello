import Foundation

struct BasicRequestAssembler: RequestAssembler {
    
    func assemble(queries: [GraphQLQuery],
                  fragments: [GraphQLFragment],
                  mutations: [GraphQLMutation],
                  for api: API) throws -> ApolloCodeGenRequest {
        
        let graphQLCode = try code {
            fragments
            queries
            mutations
        }
        
        return ApolloCodeGenRequest(api: fragments.first?.api ?? queries.first!.api,
                                    code: graphQLCode)
    }
    
}
