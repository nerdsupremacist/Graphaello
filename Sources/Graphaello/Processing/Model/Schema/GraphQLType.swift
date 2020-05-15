import Foundation

extension Schema {

    struct GraphQLType: Codable, Hashable {
        let name: String
        let kind: Kind
        let fields: [Field]?
        let possibleTypes: [TypeReference]?
        let interfaces: [TypeReference]?
        let enumValues: [TypeReference]?
        let inputFields: [InputField]?
    }

}

extension Schema.GraphQLType {

    var isScalar: Bool {
        return kind == .scalar
    }

    var includeInReport: Bool {
        return kind != .scalar && !name.starts(with: "__")
    }

}

extension Optional where Wrapped: Collection {

    fileprivate var isEmpty: Bool {
        return self?.isEmpty ?? true
    }

}
