//
//  main.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

let command = try CommandLineParser().parse(command: GraphQLCommands())
try command.run()
