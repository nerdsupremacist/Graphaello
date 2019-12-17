//
//  main.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 11/29/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import CLIKit

do {
    let command = try CommandLineParser().parse(command: GraphQLCommands())
    try command.run()
} catch let error as CommandLineError {
    Console.print("\(error.localizedDescription)")
} catch {
    let errorString = "\(error)"
    Console.printError("\(.red)❗️ Error Occurred:\(.reset)")
    Console.printError("")
    Console.printError("\(inverse: errorString)")
    exit(-1)
}
