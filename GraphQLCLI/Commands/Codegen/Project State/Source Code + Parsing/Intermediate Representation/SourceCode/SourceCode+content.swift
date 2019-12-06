//
//  SourceCode+content.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

extension SourceCode {

    var content: String {
        do {
            let start = try offset()
            let length = try self.length()
            return file.content(start: start, length: length)
        } catch {
            return file.contents
        }
    }

    func body() throws -> SourceCode {
        let start = try bodyOffset()
        let length = try bodyLength()
        let body = file.content(start: start, length: length)
        return try SourceCode(content: body)
    }

}

extension File {

    fileprivate func content(start: Int64, length: Int64) -> String {
        let start = contents.index(contents.startIndex, offsetBy: max(0, Int(start - 1)))
        let end = contents.index(start, offsetBy: Int(length))
        return String(contents[start..<end])
    }

}
