import Foundation

extension SourceCode {

    struct Kind: RawRepresentable, Equatable {
        let rawValue: String
    }

}

extension SourceCode.Kind {
    static let `associatedtype` = SourceCode.Kind(rawValue: "source.lang.swift.decl.associatedtype")
    static let `class` = SourceCode.Kind(rawValue: "source.lang.swift.decl.class")
    static let `enum` = SourceCode.Kind(rawValue: "source.lang.swift.decl.enum")
    static let enumcase = SourceCode.Kind(rawValue: "source.lang.swift.decl.enumcase")
    static let enumelement = SourceCode.Kind(rawValue: "source.lang.swift.decl.enumelement")
    static let `extension` = SourceCode.Kind(rawValue: "source.lang.swift.decl.extension")
    static let extensionClass = SourceCode.Kind(rawValue: "source.lang.swift.decl.extension.class")
    static let extensionEnum = SourceCode.Kind(rawValue: "source.lang.swift.decl.extension.enum")
    static let extensionProtocol = SourceCode.Kind(rawValue: "source.lang.swift.decl.extension.protocol")
    static let extensionStruct = SourceCode.Kind(rawValue: "source.lang.swift.decl.extension.struct")
    static let functionAccessorAddress = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.address")
    static let functionAccessorDidset = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.didset")
    static let functionAccessorGetter = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.getter")
    static let functionAccessorModify = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.modify")
    static let functionAccessorMutableaddress = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.mutableaddress")
    static let functionAccessorRead = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.read")
    static let functionAccessorSetter = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.setter")
    static let functionAccessorWillset = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.accessor.willset")
    static let functionConstructor = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.constructor")
    static let functionDestructor = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.destructor")
    static let functionFree = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.free")
    static let functionMethodClass = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.method.class")
    static let functionMethodInstance = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.method.instance")
    static let functionMethodStatic = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.method.static")
    static let functionOperator = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.operator")
    static let functionOperatorInfix = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.operator.infix")
    static let functionOperatorPostfix = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.operator.postfix")
    static let functionOperatorPrefix = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.operator.prefix")
    static let functionSubscript = SourceCode.Kind(rawValue: "source.lang.swift.decl.function.subscript")
    static let genericTypeParam = SourceCode.Kind(rawValue: "source.lang.swift.decl.generic_type_param")
    static let module = SourceCode.Kind(rawValue: "source.lang.swift.decl.module")
    static let opaqueType = SourceCode.Kind(rawValue: "source.lang.swift.decl.opaquetype")
    static let precedenceGroup = SourceCode.Kind(rawValue: "source.lang.swift.decl.precedencegroup")
    static let `protocol` = SourceCode.Kind(rawValue: "source.lang.swift.decl.protocol")
    static let `struct` = SourceCode.Kind(rawValue: "source.lang.swift.decl.struct")
    static let `typealias` = SourceCode.Kind(rawValue: "source.lang.swift.decl.typealias")
    static let varClass = SourceCode.Kind(rawValue: "source.lang.swift.decl.var.class")
    static let varGlobal = SourceCode.Kind(rawValue: "source.lang.swift.decl.var.global")
    static let varInstance = SourceCode.Kind(rawValue: "source.lang.swift.decl.var.instance")
    static let varLocal = SourceCode.Kind(rawValue: "source.lang.swift.decl.var.local")
    static let varParameter = SourceCode.Kind(rawValue: "source.lang.swift.decl.var.parameter")
    static let varStatic = SourceCode.Kind(rawValue: "source.lang.swift.decl.var.static")

    static let functionCall = SourceCode.Kind(rawValue: "source.lang.swift.expr.call")
}
