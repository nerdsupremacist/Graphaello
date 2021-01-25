
import Foundation
import SwiftSyntax
import SourceKittenFramework

private let swiftUIViewProtocols: Set<String> = ["View"]

struct UnusedWarningDiagnoser: WarningDiagnoser {
    func diagnose(parsed: Struct<Stage.Parsed>) throws -> [Warning] {
        guard !swiftUIViewProtocols.intersection(parsed.inheritedTypes).isEmpty else {
            return []
        }

        return try parsed.properties.flatMap { try diagnose(property: $0, from: parsed) }
    }

    private func diagnose(property: Property<Stage.Parsed>, from parsed: Struct<Stage.Parsed>) throws -> [Warning] {
        guard property.graphqlPath != nil,
              property.name != "id" else { return [] }

        let verifier = UsageVerifier(property: property)
        let syntax = try parsed.code.syntaxTree()

        verifier.walk(syntax)

        guard !verifier.isUsed else { return [] }
        return [
            Warning(
                location: property.code.location,
                descriptionText: "Unused Property `\(property.name)` belongs to a View and is fetching data from GraphQL. This can be wasteful. Consider using it or removing the property."
            )
        ]
    }
}

class UsageVerifier: SyntaxVisitor {
    let property: Property<Stage.Parsed>

    private(set) var shouldUseSelf = false
    private(set) var isUsed = false

    init(property: Property<Stage.Parsed>) {
        self.property = property
        super.init()
    }

    override func visitPost(_ node: IdentifierExprSyntax) {
        if node.identifier.text == property.name {
            isUsed = true
        }
    }

    override func visitPost(_ node: MemberAccessExprSyntax) {
        if node.name.text == property.name,
           let parent = node.base?.as(IdentifierExprSyntax.self),
           parent.identifier.tokenKind == .selfKeyword {

            isUsed = true
        }
    }
}
