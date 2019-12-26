//
//  ApolloCodeGenRequest.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

struct ApolloCodeGenRequest {
    let api: API
    let code: String
}

extension ApolloCodeGenRequest {
    
    func generate(using apollo: ApolloReference) throws -> String {
        let folder = Path.cachesDirectory + "GraphaelloCodegen" + "tmp" + UUID().uuidString
        try folder.createDirectory(withIntermediateDirectories: true, attributes: nil)
        defer {
            do {
                try folder.remove()
            } catch {
                fatalError("Failed to remove folder")
            }
        }
        
        let graphQLPath = folder + "queries.graphql"
        try code.data(using: .utf8)?.write(to: graphQLPath.url)
        
        let swiftPath = folder + "API.swift"
        
        let process = try apollo.process(schema: Path(api.path.string), graphql: graphQLPath, outputFile: swiftPath)
        process.launch()
        process.waitUntilExit()
        
        return String(data: try Data(contentsOf: swiftPath.url), encoding: .utf8)!
    }
    
}
