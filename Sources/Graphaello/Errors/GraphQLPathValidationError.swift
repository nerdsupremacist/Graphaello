import Foundation

enum GraphQLPathValidationError: Error, CustomStringConvertible {
    case apiNotFound(String, apis: [API])
    case typeNotFound(String, api: API)
    case cannotCallUseComponentForScalar(Stage.Parsed.Component, type: Schema.GraphQLType)
    case fieldNotFoundInType(String, type: Schema.GraphQLType)

    var description: String {
        switch self {

        case .apiNotFound(let apiName, let apis):
            let message = "Failed to find API with the name of \(apiName)."
            guard let mostLikely = apis.map({ $0.name }).min(by: { apiName.distance(to: $0) < apiName.distance(to: $1) }), apiName.distance(to: mostLikely) < max(apiName.count / 2, 1) else { return message }
            return "\(message) Did you mean: \(mostLikely)?"

        case .typeNotFound(let type, let api):
            let message = "Failed to find GraphQL Type with the name of \(type) in \(api.name)."
            guard let mostLikely = api.types.map({ $0.name }).min(by: { type.distance(to: $0) < type.distance(to: $1) }), type.distance(to: mostLikely) < max(type.count / 2, 1) else { return message }
            return "\(message) Did you mean: \(mostLikely)?"

        case .cannotCallUseComponentForScalar(_, let type):
            return "Cannot call fields on Scalar Type \(type)"

        case .fieldNotFoundInType(let field, let type):
            let message = "Failed to find field with the name of \(field) in \(type.name)."
            guard let mostLikely = type.fields?.map({ $0.name }).min(by: { field.distance(to: $0) < field.distance(to: $1) }), field.distance(to: mostLikely) < max(field.count / 2, 1) else { return message }
            return "\(message) Did you mean: \(mostLikely)?"

        }
    }
}
