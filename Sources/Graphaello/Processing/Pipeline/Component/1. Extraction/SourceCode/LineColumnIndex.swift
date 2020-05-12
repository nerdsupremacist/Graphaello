//
//  File.swift
//  
//
//  Created by Mathias.Quintero on 5/12/20.
//

import Foundation

struct LineColumnIndex {
    private let charactersPerLine: [Range<Int>]
    private let lines: [String]

    init(string: String) {
        lines = string.components(separatedBy: "\n")
        charactersPerLine = lines.collect(0..<0) { $0.upperBound..<($0.upperBound + $1.count + 1) }
    }

    subscript(line: Int, column: Int) -> Int {
        return charactersPerLine[line].lowerBound + column
    }

    subscript(offset: Int) -> (line: Int, column: Int)? {
        guard let (lineIndex, line) = charactersPerLine.enumerated().first(where: { $0.element.contains(offset) }) else {
            return nil
        }
        return (line: lineIndex, column: offset - line.lowerBound)
    }
}

extension LineColumnIndex {

    subscript(location: Location) -> Int {
        return self[location.line ?? 0, location.column ?? 0]
    }

}

extension Sequence {

    func collect<Value>(_ initialValue: Value, transform: (Value, Element) throws -> Value) rethrows -> [Value] {
        var collected = [Value]()
        for element in self {
            collected.append(try transform(collected.last ?? initialValue, element))
        }
        return collected
    }

}
