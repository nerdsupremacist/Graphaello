import Foundation
import Syntax

protocol InstantiableParser: Syntax.Parser {
    init()
}

@propertyWrapper
struct OptionalParsed<Parser : InstantiableParser>: Codable, Hashable where Parser.Output: Hashable {
    private let stringRepresentation: String?
    var wrappedValue: Parser.Output?

    private init(stringRepresentation: String?) throws {
        self.stringRepresentation = stringRepresentation
        self.wrappedValue = try stringRepresentation.map { try Parser().parse($0) }
    }

    init(from decoder: Decoder) throws {
        try self.init(stringRepresentation: Optional<String>(from: decoder))
    }

    func encode(to encoder: Encoder) throws {
        try stringRepresentation.encode(to: encoder)
    }
}
