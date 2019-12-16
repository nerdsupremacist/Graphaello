//
//  Environment+custom.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil
import PathKit

// TODO: finish this list
private let keywords: Set<String> = ["public", "private", "extension"]

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

        ext.registerFilter("keywordProtected") { value in
            guard let value = value as? String else { return nil }
            if keywords.contains(value) {
                return "`\(value)`"
            } else {
                return value
            }
        }

        return Environment(loader: loader, extensions: [ext])
    }()

}
