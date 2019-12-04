//
//  Kind.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/2/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Kind: RawRepresentable, Equatable {
    let rawValue: String
}

extension Kind {
    static let `associatedtype` = Kind(rawValue: "source.lang.swift.decl.associatedtype")
    static let `class` = Kind(rawValue: "source.lang.swift.decl.class")
    static let `enum` = Kind(rawValue: "source.lang.swift.decl.enum")
    static let enumcase = Kind(rawValue: "source.lang.swift.decl.enumcase")
    static let enumelement = Kind(rawValue: "source.lang.swift.decl.enumelement")
    static let `extension` = Kind(rawValue: "source.lang.swift.decl.extension")
    static let extensionClass = Kind(rawValue: "source.lang.swift.decl.extension.class")
    static let extensionEnum = Kind(rawValue: "source.lang.swift.decl.extension.enum")
    static let extensionProtocol = Kind(rawValue: "source.lang.swift.decl.extension.protocol")
    static let extensionStruct = Kind(rawValue: "source.lang.swift.decl.extension.struct")
    static let functionAccessorAddress = Kind(rawValue: "source.lang.swift.decl.function.accessor.address")
    static let functionAccessorDidset = Kind(rawValue: "source.lang.swift.decl.function.accessor.didset")
    static let functionAccessorGetter = Kind(rawValue: "source.lang.swift.decl.function.accessor.getter")
    static let functionAccessorModify = Kind(rawValue: "source.lang.swift.decl.function.accessor.modify")
    static let functionAccessorMutableaddress = Kind(rawValue: "source.lang.swift.decl.function.accessor.mutableaddress")
    static let functionAccessorRead = Kind(rawValue: "source.lang.swift.decl.function.accessor.read")
    static let functionAccessorSetter = Kind(rawValue: "source.lang.swift.decl.function.accessor.setter")
    static let functionAccessorWillset = Kind(rawValue: "source.lang.swift.decl.function.accessor.willset")
    static let functionConstructor = Kind(rawValue: "source.lang.swift.decl.function.constructor")
    static let functionDestructor = Kind(rawValue: "source.lang.swift.decl.function.destructor")
    static let functionFree = Kind(rawValue: "source.lang.swift.decl.function.free")
    static let functionMethodClass = Kind(rawValue: "source.lang.swift.decl.function.method.class")
    static let functionMethodInstance = Kind(rawValue: "source.lang.swift.decl.function.method.instance")
    static let functionMethodStatic = Kind(rawValue: "source.lang.swift.decl.function.method.static")
    static let functionOperator = Kind(rawValue: "source.lang.swift.decl.function.operator")
    static let functionOperatorInfix = Kind(rawValue: "source.lang.swift.decl.function.operator.infix")
    static let functionOperatorPostfix = Kind(rawValue: "source.lang.swift.decl.function.operator.postfix")
    static let functionOperatorPrefix = Kind(rawValue: "source.lang.swift.decl.function.operator.prefix")
    static let functionSubscript = Kind(rawValue: "source.lang.swift.decl.function.subscript")
    static let genericTypeParam = Kind(rawValue: "source.lang.swift.decl.generic_type_param")
    static let module = Kind(rawValue: "source.lang.swift.decl.module")
    static let opaqueType = Kind(rawValue: "source.lang.swift.decl.opaquetype")
    static let precedenceGroup = Kind(rawValue: "source.lang.swift.decl.precedencegroup")
    static let `protocol` = Kind(rawValue: "source.lang.swift.decl.protocol")
    static let `struct` = Kind(rawValue: "source.lang.swift.decl.struct")
    static let `typealias` = Kind(rawValue: "source.lang.swift.decl.typealias")
    static let varClass = Kind(rawValue: "source.lang.swift.decl.var.class")
    static let varGlobal = Kind(rawValue: "source.lang.swift.decl.var.global")
    static let varInstance = Kind(rawValue: "source.lang.swift.decl.var.instance")
    static let varLocal = Kind(rawValue: "source.lang.swift.decl.var.local")
    static let varParameter = Kind(rawValue: "source.lang.swift.decl.var.parameter")
    static let varStatic = Kind(rawValue: "source.lang.swift.decl.var.static")

    static let functionCall = Kind(rawValue: "source.lang.swift.expr.call")
}
