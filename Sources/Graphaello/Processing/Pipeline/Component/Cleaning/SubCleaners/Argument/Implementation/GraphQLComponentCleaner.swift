import Foundation

struct GraphQLComponentCleaner: ArgumentCleaner {
    let objectCleaner: AnyArgumentCleaner<GraphQLObject>

    func clean(resolved: GraphQLComponent,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<GraphQLComponent> {

        switch resolved {
        case .scalar:
            return context.result(value: resolved)
        case .object(let object):
            return try objectCleaner
                .clean(resolved: object, using: context).map { object in
                    .object(object)
                }
        }
    }
}
