import Foundation
import PathKit

class API {
    let name: String
    let query: Schema.GraphQLType
    let mutation: Schema.GraphQLType?
    let types: [Schema.GraphQLType]
    let scalars: [Schema.GraphQLType]
    let path: Path
    let url: URL?
    let targets: [String]

    init(name: String, schema: Schema, path: Path, url: URL?, targets: [String]) {
        self.name = name

        self.query = schema.types.first { $0.name == schema.queryType.name } ?! fatalError("Expected a query type")
        self.mutation = schema.mutationType.map { mutationType in
            schema.types.first { $0.name == mutationType.name } ?! fatalError("Expected the referenced mutation type to exist")
        }

        let alreadyIncluded = Set([schema.queryType.name, schema.mutationType?.name].compactMap { $0 })

        self.types = schema.types
            .filter { $0.includeInReport }
            .filter { !alreadyIncluded.contains($0.name) }
        
        self.scalars = schema.types.filter { $0.isScalar }
        self.path = path
        self.url = url
        self.targets = targets
    }
}

extension API {
    
    var macros: [String] {
        return targets.map { "GRAPHAELLO_\($0.snakeUpperCased)_TARGET" }
    }
    
    var unifiedMacroFlag: String {
        guard !targets.isEmpty else { return "0" }
        return macros.joined(separator: " || ")
    }
    
}

extension API: Hashable {

    static func == (lhs: API, rhs: API) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(query)
        hasher.combine(mutation)
        hasher.combine(types)
        hasher.combine(scalars)
        hasher.combine(url)
        
        // Version. Bump this number when the structure of the generated code for an API is changed
        hasher.combine(3)
    }

}
