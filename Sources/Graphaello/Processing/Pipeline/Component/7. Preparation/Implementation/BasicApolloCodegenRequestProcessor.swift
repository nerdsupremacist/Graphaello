//
//  BasicApolloCodegenRequestProcessor.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation
import CLIKit

struct BasicApolloCodegenRequestProcessor: ApolloCodegenRequestProcessor {
    let instantiator: ApolloProcessInstantiator
    
    func process(request: ApolloCodeGenRequest, using apollo: ApolloReference) throws -> ApolloCodeGenResponse {
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
        try request.code.data(using: .utf8)?.write(to: graphQLPath.url)
        
        let swiftPath = folder + "API.swift"
        let process = try instantiator.process(for: apollo,
                                               api: request.api,
                                               graphql: graphQLPath,
                                               outputFile: swiftPath)
        
        process.launch()
        process.waitUntilExit()
        
        return ApolloCodeGenResponse(request: request,
                                     code: String(data: try Data(contentsOf: swiftPath.url), encoding: .utf8)!)
    }
}

extension BasicApolloCodegenRequestProcessor {
    
    init(instantiator: () -> ApolloProcessInstantiator) {
        self.init(instantiator: instantiator())
    }
    
}
