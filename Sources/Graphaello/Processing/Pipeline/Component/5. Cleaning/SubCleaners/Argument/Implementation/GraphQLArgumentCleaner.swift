import Foundation

struct GraphQLArgumentCleaner: ArgumentCleaner {
    func clean(resolved: GraphQLArgument,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLArgument> {

        return context + resolved
    }
}
