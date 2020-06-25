import Foundation
import PathKit

private let graphqlFileRegex = try! NSRegularExpression(pattern: #"([A-Z][a-zA-Z]*)\.graphql\.json"#)
private let decoder = JSONDecoder()

private struct WrappedSchema: Codable {
    enum CodingKeys: String, CodingKey {
        case url
        case schema = "__schema"
    }

    let url: URL?
    let schema: Schema
}

extension Project {
    
    func scanAPIs() throws -> [API] {
        return try files()
            .filter { $0.value.extension == "json" }
            .compactMap { file in file.value.apiName.map { (file, $0) } }
            .map { file in
                let (file, apiName) = file
                let data = try Data(contentsOf: file.value.url)
                let wrapped = try decoder.decode(WrappedSchema.self, from: data)
                return API(name: apiName, schema: wrapped.schema, path: file.value, url: wrapped.url, targets: file.targets)
            }
    }
    
}

extension Path {
    
    fileprivate var apiName: String? {
        let range = NSRange(lastComponent.startIndex..<lastComponent.endIndex, in: lastComponent)
        let match = graphqlFileRegex.matches(in: lastComponent, options: .anchored, range: range)
        guard match.count == 1 else { return nil }
        let groupRange = match.first?.range(at: 1)
        let safeRange = groupRange.flatMap { Range($0, in: lastComponent) }
        return safeRange.map { String(lastComponent[$0]) }
    }
    
}
