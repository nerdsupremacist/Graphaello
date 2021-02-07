import Foundation

struct AdditionalReferencedAPI<CurrentStage: ResolvedStage>: Hashable {
    let api: API
    let property: Property<CurrentStage>?
    
    static func == (lhs: AdditionalReferencedAPI<CurrentStage>, rhs: AdditionalReferencedAPI<CurrentStage>) -> Bool {
        return lhs.api == rhs.api
    }
    
    func hash(into hasher: inout Hasher) {
        api.hash(into: &hasher)
    }
}
