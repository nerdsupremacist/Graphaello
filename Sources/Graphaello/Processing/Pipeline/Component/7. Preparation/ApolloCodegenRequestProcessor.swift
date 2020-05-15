import Foundation

protocol ApolloCodegenRequestProcessor {
    func process(request: ApolloCodeGenRequest, using apollo: ApolloReference, cache: PersistentCache<AnyHashable>?) throws -> ApolloCodeGenResponse
}
