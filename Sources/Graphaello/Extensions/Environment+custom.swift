import Foundation
import Stencil
import PathKit

extension Environment {

    static let custom: Environment = {
        let loader = FileSystemLoader(paths: [Path.templates])

        let ext = Extension()
        
        ext.registerFilter("code") { value, arguments, context in
            switch value {
            case .some(let value as CodeTransformable):
                return try value.code(using: context, arguments: arguments)
                
            case .some(let value as [Any]):
                return try value.code(using: context, arguments: arguments).joined(separator: "\n")
                
            default:
                return nil
            
            }
        }
        
        ext.registerFilter("codeArray") { value, arguments, context in
            switch value {
                
            case .some(let value as [Any]):
                return try value.code(using: context, arguments: arguments)
                
            default:
                return nil
            
            }
        }

        ext.registerFilter("camelized") { value in
            guard let value = value as? String else { return nil }
            return value.camelized
        }

        ext.registerFilter("upperCamelized") { value in
            guard let value = value as? String else { return nil }
            return value.upperCamelized
        }

        ext.registerFilter("keywordProtected") { value in
            guard let value = value as? String else { return nil }
            return value.keywordProtected
        }

        return Environment(loader: loader, extensions: [ext])
    }()

}
