//
//  File.swift
//  
//
//  Created by Mathias Quintero on 1/15/20.
//

import Foundation

extension SourceCode {

    struct Accessibility: RawRepresentable, Equatable {
        let rawValue: String
    }

}

extension SourceCode.Accessibility {

    static let `internal` = SourceCode.Accessibility(rawValue: "source.lang.swift.accessibility.internal")

    static let `public` = SourceCode.Accessibility(rawValue: "source.lang.swift.accessibility.public")

    static let `private` = SourceCode.Accessibility(rawValue: "source.lang.swift.accessibility.private")

    static let `fileprivate` = SourceCode.Accessibility(rawValue: "source.lang.swift.accessibility.fileprivate")

}
