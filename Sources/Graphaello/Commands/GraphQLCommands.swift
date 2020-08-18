import Foundation
import CLIKit

class GraphQLCommands: Commands {
    let description = "Manages the state of the GraphQL Integrations in your project"

    let `init` = InitCommand()
    let codegen = CodegenCommand()
    let add = AddAPICommand()
    let update = UpdateAPICommand()
    let clearCache = ClearCacheCommand()
}
