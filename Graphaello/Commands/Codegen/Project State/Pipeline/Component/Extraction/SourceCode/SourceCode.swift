//
//  SourceCode.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

struct SourceCode {
    let file: File
    let dictionary: [String : SourceKitRepresentable]
}

extension SourceCode {

    init(file: File) throws {
        self.init(file: file,
                  dictionary: try Structure(file: file).dictionary)
    }

    init(content: String) throws {
        try self.init(file: File(contents: content))
    }

}

extension SourceCode: CustomStringConvertible {
    
    var description: String {
        return content
    }
    
}
