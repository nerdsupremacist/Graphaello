import Foundation

protocol RequestAssembler {
    func assemble(queries: [GraphQLQuery], fragments: [GraphQLFragment], mutations: [GraphQLMutation], for api: API) throws -> ApolloCodeGenRequest
}
