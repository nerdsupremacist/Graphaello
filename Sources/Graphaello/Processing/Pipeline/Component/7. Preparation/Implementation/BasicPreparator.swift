import Foundation

struct BasicPreparator: Preparator {
    let processor: ApolloCodegenRequestProcessor
    
    func prepare(assembled: Project.State<Stage.Assembled>, using apollo: ApolloReference) throws -> Project.State<Stage.Prepared> {
        return try assembled.with {
            try .responses ~> assembled.requests.map { try processor.process(request: $0, using: apollo, cache: assembled.cache) }
        }
    }
}

extension BasicPreparator {
    
    init(processor: () -> ApolloCodegenRequestProcessor) {
        self.init(processor: processor())
    }
    
}
