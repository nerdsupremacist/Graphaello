import Foundation
import SwiftSyntax

extension Stage {

    // The GraphQL Property Wrappers have been parsed
    enum Parsed: GraphQLStage {
        typealias Information = Path?

        enum Component: Equatable {
            case property(String)
            case fragment
            case call(String, [Field.Argument])
            case operation(Operation)
        }

        struct Path {
            let extracted: Stage.Extracted.Attribute
            let apiName: String
            let target: Target
            let components: [Component]
        }
        
        static var pathKey = Context.Key.parsed
    }

}

extension Context.Key where T == Stage.Parsed.Path? {
    
    static let parsed = Context.Key<Stage.Parsed.Path?>()
    
}
