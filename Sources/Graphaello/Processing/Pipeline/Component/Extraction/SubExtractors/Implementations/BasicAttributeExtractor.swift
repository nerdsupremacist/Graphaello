import Foundation

struct BasicAttributeExtractor: AttributeExtractor {

    func extract(code: SourceCode) throws -> Stage.Extracted.Attribute {
        return Stage.Extracted.Attribute(code: code, kind: try code.attribute())
    }

}
