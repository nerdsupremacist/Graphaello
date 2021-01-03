import Foundation

private let specialAttributes: Set<String> = ["Binding"]

struct BasicPropertyExtractor: PropertyExtractor {
    let attributeExtractor: AttributeExtractor

    func extract(code: SourceCode) throws -> Property<Stage.Extracted>? {
        let type = try code.optional(decode: { try $0.typeName() })
        let attributes = try code
            .optional { try $0.attributes() }?
            .map { try attributeExtractor.extract(code: $0) } ?? []

        let finalType = type.map { type in
            attributes
                .filter { $0.kind == ._custom }
                .map { String($0.code.content.dropFirst()) }
                .first { specialAttributes.contains($0) }
                .map { "\($0)<\(type)>" } ?? type
        }

        return Property(code: code,
                        name: try code.name(),
                        type: finalType.map { .concrete($0) } ?? .inferred,
                        usr: try code.usr()) {
            
            .attributes ~> attributes
        }
    }
}
