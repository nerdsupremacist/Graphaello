//
//  Project+scanAPIs.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 29.11.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import XcodeProj
import PathKit

private let graphqlFileRegex = try! NSRegularExpression(pattern: #"([A-Z][a-zA-Z]*)\.graphql\.json"#)
private let decoder = JSONDecoder()

private struct WrappedSchema: Codable {
    enum CodingKeys: String, CodingKey {
        case schema = "__schema"
    }
    
    let schema: Schema
}

extension XcodeProj {
    
    func scanAPIs(sourcesPath: String) throws -> [API] {
        return try pbxproj
            .buildFiles
            .compactMap { try $0.file?.fullPath(sourceRoot: .init(sourcesPath)) }
            .filter { $0.extension == "json" }
            .compactMap { file in file.apiName.map { (file, $0) } }
            .map { file in
                let (file, apiName) = file
                let data = try Data(contentsOf: file.url)
                let wrapped = try decoder.decode(WrappedSchema.self, from: data)
                return API(name: apiName, schema: wrapped.schema)
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
