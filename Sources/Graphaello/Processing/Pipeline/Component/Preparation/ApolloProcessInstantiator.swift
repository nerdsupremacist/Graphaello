import Foundation
import CLIKit

protocol ApolloProcessInstantiator {
    func process(for apollo: ApolloReference, api: API, graphql: Path, outputFile: Path) throws -> Process
}
