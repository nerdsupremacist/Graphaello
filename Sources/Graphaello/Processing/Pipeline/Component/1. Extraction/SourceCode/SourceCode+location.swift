//
//  File.swift
//  
//
//  Created by Mathias.Quintero on 5/12/20.
//

import Foundation

extension SourceCode {

    func location(of offset: Int) -> Location {
        let offset = index[location] + offset
        let lineAndColumn = index[offset]
        return Location(file: location.file, line: lineAndColumn?.line, column: lineAndColumn?.column)
    }

}

