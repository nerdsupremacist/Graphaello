import Foundation

struct BasicParser: Parser {
    let parser: SubParser<Stage.Extracted.Attribute, Stage.Parsed.Path?>

    func parse(extracted: Struct<Stage.Extracted>) throws -> Struct<Stage.Parsed> {
        return try extracted.map { property in
            return try property.with {
                try .parsed ~> property.attributes
                    .compactMap { attribute in
                        try locateErrors(with: attribute.code.location) {
                            try parser.parse(from: attribute)
                        }
                    }
                    .first
            }
                
        }
    }
}

extension BasicParser {
    
    init(parser: () -> SubParser<Stage.Extracted.Attribute, Stage.Parsed.Path?>) {
        self.parser = parser()
    }
    
}
