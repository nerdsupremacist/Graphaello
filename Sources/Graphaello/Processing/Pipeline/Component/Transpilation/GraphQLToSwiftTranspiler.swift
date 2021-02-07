import Foundation
import SwiftSyntax
import GraphQLSyntax

protocol GraphQLToSwiftTranspiler {
    func expression(from value: GraphQL.Value?,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntaxProtocol?

    func expression(from value: GraphQL.Value,
                    for type: Schema.GraphQLType.Field.TypeReference,
                    using api: API) throws -> ExprSyntaxProtocol
}
