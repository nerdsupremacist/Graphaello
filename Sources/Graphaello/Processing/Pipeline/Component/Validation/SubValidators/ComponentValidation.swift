import Foundation

enum ComponentValidation {
    enum ResultType {
        case object(Schema.GraphQLType)
        case scalar(Schema.GraphQLType)

        var graphQLType: Schema.GraphQLType {
            switch self {
            case .object(let type):
                return type
            case .scalar(let type):
                return type
            }
        }
    }

    struct Result {
        let component: Stage.Validated.Component
        let type: ResultType
    }


    struct Context {
        let api: API
        let components: [Stage.Validated.Component]
        let type: ResultType
        
        private init(api: API, components: [Stage.Validated.Component], type: ResultType) {
            self.api = api
            self.components = components
            self.type = type
        }
    }
}

extension ComponentValidation.Context {
    
    static func `for`(type: Schema.GraphQLType, in api: API) -> ComponentValidation.Context {
        return ComponentValidation.Context(api: api, components: [], type: .object(type))
    }
    
    static func + (lhs: ComponentValidation.Context, rhs: @autoclosure () throws -> ComponentValidation.Result) rethrows -> ComponentValidation.Context {
        let rhs = try rhs()
        return ComponentValidation.Context(api: lhs.api, components: lhs.components + [rhs.component], type: rhs.type)
    }
    
}

extension ComponentValidation.Context {

    func fragmentComponent() -> Stage.Validated.Component {
        return .init(reference: .fragment,
                     underlyingType: type.graphQLType,
                     parsed: .fragment)
    }
    
}

extension API {

    subscript(name: String) -> ComponentValidation.ResultType? {
        if let type = types[name] {
            return .object(type)
        }

        if let type = scalars[name] {
            return .scalar(type)
        }

        return nil
    }

}
