import Foundation
import Stencil

extension Stencil.Context {
    
    func render(template: String, context dictionary: [String : Any]) throws -> String {
        return try push(dictionary: dictionary) {
            let template = try environment.loadTemplate(name: template)
            return try template.render(flatten())
        }
    }
    
}
