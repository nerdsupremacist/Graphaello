import Foundation

struct FragmentReference: GraphQLCodeTransformable {
    let hasArguments: Bool
    let fragment: GraphQLFragment
}

extension GraphQLObject {
    
    var referencedFragments: [FragmentReference] {
        return flattenArgumentFragments
            .sorted { $0.name < $1.name }
            .map { FragmentReference(hasArguments: !$0.arguments.isEmpty,
                                     fragment: $0) }
    }
    
}

extension GraphQLObject {

    fileprivate var flattenArgumentFragments: [GraphQLFragment] {
        return fragments.flatMap { fragment -> [GraphQLFragment] in
            if fragment.arguments.isEmpty {
                return [fragment]
            } else {
                return [fragment] + fragment.object.flattenArgumentFragments
            }
        }
    }

}
