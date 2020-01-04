//
//  ApolloProcessInstantiator.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation
import CLIKit

protocol ApolloProcessInstantiator {
    func process(for apollo: ApolloReference, api: API, graphql: Path, outputFile: Path) throws -> Process
}
