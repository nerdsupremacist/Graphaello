import Foundation

struct FragmentReference: GraphQLCodeTransformable {
    let hasArguments: Bool
    let fragment: GraphQLFragment
}

extension GraphQLObject {
    
    var referencedFragments: [FragmentReference] {
        return fragments
            .sorted { $0.name < $1.name }
            .map { FragmentReference(hasArguments: !$0.arguments.isEmpty,
                                     fragment: $0) }
    }
    
}
