//
//  GraphQLCommands.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

class GraphQLCommands: Commands {
    let description = "Manages the state of the GraphQL Integrations in your project"

    let `init` = InitCommand()
    let codegen = CodegenCommand()
    let add = AddAPICommand()
}
