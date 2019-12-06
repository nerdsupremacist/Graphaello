//
//  SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil
import SwiftFormat

@_functionBuilder
struct SwiftCodeBuilder {
    
    static func buildBlock(_ transformable: SwiftCodeTransformable) -> SwiftCodeTransformable {
        return transformable
    }
    
    static func buildBlock(_ transformables: SwiftCodeTransformable...) -> SwiftCodeTransformable {
        return transformables.map { AnySwiftCodeTransformable(transformable: $0) }
    }
    
}

struct AnySwiftCodeTransformable: SwiftCodeTransformable {
    
    let _code: (Context, [Any?]) throws -> String
    
    init(transformable: SwiftCodeTransformable) {
        _code = transformable.code
    }
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        return try _code(context, arguments)
    }
}

func swiftCode(@SwiftCodeBuilder builder: () -> SwiftCodeTransformable) throws -> String {
    let transformable = builder()
    return try format(try transformable.code(using: .custom))
}

protocol SwiftCodeTransformable {
    func code(using context: Context, arguments: [Any?]) throws -> String
}

extension SwiftCodeTransformable {
    
    func code(using environment: Environment) throws -> String {
        return try environment.renderTemplate(name: "SwiftCodeTransformable.swift.stencil", context: ["value" : self])
    }
    
}

extension SwiftCodeTransformable {
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        return try context.render(template: "\(name).swift.stencil", context: [name.lowercased() : self])
    }
    
}

protocol ExtraValuesSwiftCodeTransformable: SwiftCodeTransformable {
    func arguments(from context: Context, arguments: [Any?]) throws -> [String : Any]
}

extension ExtraValuesSwiftCodeTransformable {

    func code(using context: Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        let dictionary = try self.arguments(from: context, arguments: arguments).merging([name.lowercased() : self]) { $1 }
        return try context.render(template: "\(name).swift.stencil", context: dictionary)
    }

}

extension Array: SwiftCodeTransformable where Element: SwiftCodeTransformable {
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        return try context.render(template: "Array.swift.stencil", context: ["values" : self])
    }
    
}

extension Array {
    
    func code(using context: Context, arguments: [Any?]) throws -> [String] {
        return try compactMap { element in
            switch element {
            case let element as SwiftCodeTransformable:
                return try element.code(using: context, arguments: arguments)
            case let element as CustomStringConvertible:
                return element.description
            default:
                return nil
            }
        }
    }
    
}

extension Optional: SwiftCodeTransformable where Wrapped: SwiftCodeTransformable {
    func code(using context: Context, arguments: [Any?]) throws -> String {
        return try self?.code(using: context, arguments: arguments) ?? ""
    }
}

extension Context {
    
    func render(template: String, context dictionary: [String : Any]) throws -> String {
        return try push(dictionary: dictionary) {
            let template = try environment.loadTemplate(name: template)
            return try template.render(flatten())
        }
    }
    
}
