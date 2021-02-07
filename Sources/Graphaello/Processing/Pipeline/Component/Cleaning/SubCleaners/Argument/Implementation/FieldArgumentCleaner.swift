import Foundation

struct FieldArgumentCleaner: ArgumentCleaner {

    func clean(resolved: GraphQLField,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLField> {

        return (context + resolved.field).map { GraphQLField(field: $0, alias: resolved.alias) }
    }

}
