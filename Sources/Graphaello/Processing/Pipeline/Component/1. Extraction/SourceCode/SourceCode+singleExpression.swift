import Foundation

extension SourceCode {

    static func singleExpression(content: String, location: Location) throws -> SourceCode {
        let code = try SourceCode(content: content, location: location)
        let substructure = try code.substructure()
        return try substructure.single() ?! ParseError.expectedSingleSubtructure(in: substructure)
    }

}
