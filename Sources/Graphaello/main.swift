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
