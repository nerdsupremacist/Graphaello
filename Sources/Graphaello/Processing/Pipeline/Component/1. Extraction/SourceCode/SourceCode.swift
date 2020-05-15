import Foundation
import SourceKittenFramework

struct SourceCode {
    let file: File
    let index: LineColumnIndex
    let location: Location
    let dictionary: [String : SourceKitRepresentable]
}

extension SourceCode {

    init(file: File, parent: SourceCode, dictionary: [String : SourceKitRepresentable]) {
        let offset = (dictionary[SwiftDocKey.offset.rawValue]) as? Int64

        let location: Location

        if file == parent.file, let offset = offset {
            let lineAndColumn = parent.index[Int(offset)]
            location = Location(file: parent.location.file, line: lineAndColumn?.line, column: lineAndColumn?.column)
        } else {
            location = offset.map { parent.location(of: Int($0)) } ?? parent.location
        }

        self.init(file: file, index: parent.index, location: location, dictionary: dictionary)
    }

}

extension SourceCode {

    init(file: File, index: LineColumnIndex, location: Location) throws {
        self.init(file: file,
                  index: index,
                  location: location,
                  dictionary: try Structure(file: file).dictionary)
    }

    init(content: String, index: LineColumnIndex, location: Location) throws {
        try self.init(file: File(contents: content), index: index, location: location)
    }

    init(content: String, location: Location) throws {
        try self.init(file: File(contents: content), index: LineColumnIndex(string: content), location: location)
    }

}

extension SourceCode: CustomStringConvertible {
    
    var description: String {
        return content
    }
    
}

