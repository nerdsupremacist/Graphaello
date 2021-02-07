import Foundation

protocol OperationTypeValidator {
    func validate(operation: Operation,
                  using context: ComponentValidation.Context) throws -> Schema.GraphQLType.Field.TypeReference
}
