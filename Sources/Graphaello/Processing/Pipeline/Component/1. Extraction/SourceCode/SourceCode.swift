import Foundation
import SourceKittenFramework
import PathKit

struct SourceCode {
    let file: File
    let index: LineColumnIndex
    let location: Location
    let targets: [String]
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

        self.init(file: file, index: parent.index, location: location, targets: parent.targets, dictionary: dictionary)
    }

}

extension SourceCode {

    init(file: FileWithTargets, index: LineColumnIndex, location: Location) throws {
        self.init(file: file.file,
                  index: index,
                  location: location,
                  targets: file.targets,
                  dictionary: try Structure(file: file.file).dictionary)
    }

    init(content: String, parent: SourceCode, location: Location) throws {
        try self.init(file: FileWithTargets(file: File(contents: content), targets: parent.targets),
                      index: LineColumnIndex(string: content),
                      location: location)
    }

}

extension SourceCode: CustomStringConvertible {
    
    var description: String {
        return content
    }
    
}

