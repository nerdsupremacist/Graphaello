import Foundation

extension SubParser {
    
    static func baseMemberAccess() -> SubParser<BaseMemberAccess, Stage.Parsed.Path> {
        return .init { access in
            if access.accessedField == "Mutation" {
                return Stage.Parsed.Path(extracted: access.extracted,
                                         apiName: access.base,
                                         target: .mutation,
                                         components: [])
            } else if access.accessedField.first?.isUppercase ?? false {
                return Stage.Parsed.Path(extracted: access.extracted,
                                         apiName: access.base,
                                         target: .object(access.accessedField),
                                         components: [])
            } else {
                return Stage.Parsed.Path(extracted: access.extracted,
                                         apiName: access.base,
                                         target: .query,
                                         components: [.property(access.accessedField)])
            }
        }
    }
    
}
