import Foundation

enum GraphQLFragmentResolverError: Error, CustomStringConvertible {
    case invalidTypeNameForFragment(String)
    case failedToDecodeAnyOfTheStructsDueToPossibleRecursion([Struct<Stage.Validated>])
    case cannotResolveFragmentOrQueryWithEmptyPath(Stage.Resolved.Path)
    case cannotIncludeFragmentsInsideAQuery(GraphQLFragment)
    case cannotDowncastQueryToType(Schema.GraphQLType)
    case cannotQueryDataFromTwoAPIsFromTheSameStruct(API, API)

    var description: String {
        switch self {
        case .invalidTypeNameForFragment(let name):
            return "Failed to parse \(name) as a Fragment"
        case .failedToDecodeAnyOfTheStructsDueToPossibleRecursion(let structs):
            let recursion = structs.recursion()
            return recursion.map { property in
                return "\(property.code.location.locationDescription): error: Property \(property.name) is referencing a Fragment that cannot be used. This is either due to a complexer syntax, or a recursive cycle between fragments"
            }
            .joined(separator: "\n")

        case .cannotResolveFragmentOrQueryWithEmptyPath:
            return "Query with Empty Paths are invalid"
        case .cannotIncludeFragmentsInsideAQuery(let fragment):
            return "A Query cannot a fragment on the first level: \(fragment.name)"
        case .cannotDowncastQueryToType(let type):
            return "A Query cannot be downcasted to type \(type.name)"
        case .cannotQueryDataFromTwoAPIsFromTheSameStruct(let lhs, let rhs):
            return "A struct cannot query from two separate APIs at once: \(lhs.name) vs. \(rhs.name)"
        }
    }
}

extension Sequence where Element == Struct<Stage.Validated> {

    fileprivate func recursion() -> [Property<Stage.Validated>] {
        let structNames = Set(map { $0.name.lowercased() })
        let fragmentNames = Set(
            flatMap { validated -> [String] in
                let simpleDefinitionName = validated.name.replacingOccurrences(of: #"[\[\]\.\?]"#, with: "", options: .regularExpression)
                return validated.properties.compactMap { property -> String? in
                    return property.graphqlPath.map { (path: Stage.Validated.Path) in
                        return "\(simpleDefinitionName)\(path.target.name)".lowercased()
                    }
                }
            }
        )

        return flatMap { validated -> [Property<Stage.Validated>] in
            return validated.properties.filter { property in
                guard property.graphqlPath?.returnType.isFragment == true else { return false }
                do {
                    let fragment = try StructResolution.ReferencedFragment(typeName: property.type)
                    switch fragment {

                    case .name(.fullName(let name)):
                        return fragmentNames.contains(name.lowercased())

                    case .paging(.fullName(let name)):
                            return fragmentNames.contains(name.lowercased())

                    case .name(.typealiasOnStruct(let structName, _)):
                        return structNames.contains(structName.lowercased())

                    case .paging(.typealiasOnStruct(let structName, _)):
                        return structNames.contains(structName.lowercased())

                    }
                } catch {
                    return true
                }
            }
        }
    }

}
