import Foundation
import SwiftSyntax

extension StructResolution.ReferencedFragment {

    init(typeName: String) throws {
        guard let syntax = try SyntaxParser.parse(source: typeName).singleItem() else  {
            throw GraphQLFragmentResolverError.invalidTypeNameForFragment(typeName)
        }
        try self.init(syntax: syntax.erased())
    }

    fileprivate init(syntax: Syntax) throws {
        switch syntax.as(SyntaxEnum.self) {

        case .optionalChainingExpr(let expression):
            try self.init(syntax: expression.expression.erased())

        case .specializeExpr(let expression):
            guard expression.expression.description == "Paging",
                let argument = Array(expression.genericArgumentClause.arguments).single() else {
                
                throw GraphQLFragmentResolverError.invalidTypeNameForFragment(syntax.description)
            }

            self = .paging(with: try StructResolution.FragmentName(syntax: argument.argumentType.erased()))

        default:
            self = .name(try StructResolution.FragmentName(syntax: syntax.erased()))

        }
    }

}
