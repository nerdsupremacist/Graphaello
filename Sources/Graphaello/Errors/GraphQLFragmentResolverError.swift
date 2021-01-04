import Foundation

enum GraphQLFragmentResolverError: Error, CustomStringConvertible {
    case cannotInferFragmentType(Schema.GraphQLType)
    case invalidTypeNameForFragment(String)
    case failedToDecodeImportedFragments([Struct<Stage.Validated>], resolved: [Struct<Stage.Resolved>])
    case cannotResolveFragmentOrQueryWithEmptyPath(Stage.Resolved.Path)
    case cannotIncludeFragmentsInsideAQuery(GraphQLFragment)
    case cannotDowncastQueryToType(Schema.GraphQLType)
    case cannotQueryDataFromTwoAPIsFromTheSameStruct(API, API)

    var description: String {
        switch self {
        case .cannotInferFragmentType(let type):
            return "Usage of GraphQL object type \(type.name) must have a selection of subfields. Please use a value from this object or map it to a Fragment."
        case .invalidTypeNameForFragment(let name):
            return "Failed to parse \(name) as a Fragment"
        case .failedToDecodeImportedFragments(let structs, let resolved):
            let errors = structs.resolutionErrors(resolved: resolved)
            return errors.map(\.description).joined(separator: "\n")
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

private enum FragmentResolutionError {
    case recursion(Property<Stage.Validated>)
    case fragmentNotFound(Property<Stage.Validated>, referencing: StructResolution.ReferencedFragment)

    var description: String {
        switch self {
        case .recursion(let property):
            return "\(property.code.location.locationDescription): error: Property \(property.name) is referencing a Fragment that cannot be used. This is either due to a syntax that is too complex for Graphaello, or a recursive cycle between fragments"

        case .fragmentNotFound(let property, .name(.fullName(let fullname))),
             .fragmentNotFound(let property, .paging(.fullName(let fullname))):
            return "\(property.code.location.locationDescription): error: Property \(property.name) is referencing a Fragment (\(fullname)) that could not be found. This is either due to a syntax that is too complex for Graphaello, or most likely because the Fragment no longer exists"

        case .fragmentNotFound(let property, .name(.typealiasOnStruct(let structName, let typeName))),
             .fragmentNotFound(let property, .paging(.typealiasOnStruct(let structName, let typeName))):
            return "\(property.code.location.locationDescription): error: Property \(property.name) is referencing a Fragment of \(typeName) from \(structName) that could not be found. This is either due to a syntax that is too complex for Graphaello, or most likely because the Fragment no longer exists"
        }
    }
}

extension Sequence where Element == Struct<Stage.Validated> {

    fileprivate func resolutionErrors(resolved: [Struct<Stage.Resolved>]) -> [FragmentResolutionError] {
        let structNames = Set(map { $0.name.lowercased() })
        let fragmentsInSequence = Set(
            flatMap { validated -> [String] in
                let simpleDefinitionName = validated.name.replacingOccurrences(of: #"[\[\]\.\?]"#, with: "", options: .regularExpression)
                return validated.properties.compactMap { property -> String? in
                    return property.graphqlPath.map { (path: Stage.Validated.Path) in
                        return "\(simpleDefinitionName)\(path.target.name)".lowercased()
                    }
                }
            }
        )

        let resolvedFragments = Set(resolved.flatMap(\.fragments).map { $0.name.lowercased() })
        let structsToFragments = Dictionary(resolved.map { ($0.name, Set($0.fragments.map { $0.name.lowercased() })) }) { $1 }

        return flatMap { validated -> [FragmentResolutionError] in
            return validated.properties.compactMap { property in
                guard case .concrete(let type) = property.type, property.graphqlPath?.returnType.isFragment == true else { return nil }
                do {
                    let fragment = try StructResolution.ReferencedFragment(typeName: type)
                    switch fragment {

                    case .name(.fullName(let name)):
                        if fragmentsInSequence.contains(name.lowercased()) {
                            return .recursion(property)
                        }

                        if resolvedFragments.contains(name.lowercased()) {
                            return nil
                        }

                        return .fragmentNotFound(property, referencing: fragment)

                    case .paging(.fullName(let name)):
                        if fragmentsInSequence.contains(name.lowercased()) {
                            return .recursion(property)
                        }

                        if resolvedFragments.contains(name.lowercased()) {
                            return nil
                        }

                        return .fragmentNotFound(property, referencing: fragment)

                    case .name(.typealiasOnStruct(let structName, let targetName)):
                        if structNames.contains(structName.lowercased()) {
                            return .recursion(property)
                        }

                        if let fragmentsForStruct = structsToFragments[structName], fragmentsForStruct.contains(targetName.lowercased()) {
                            return nil
                        }

                        return .fragmentNotFound(property, referencing: fragment)

                    case .paging(.typealiasOnStruct(let structName, let targetName)):
                        if structNames.contains(structName.lowercased()) {
                            return .recursion(property)
                        }

                        if let fragmentsForStruct = structsToFragments[structName], fragmentsForStruct.contains(targetName.lowercased()) {
                            return nil
                        }

                        return .fragmentNotFound(property, referencing: fragment)

                    }
                } catch {
                    return nil
                }
            }
        }
    }

}
