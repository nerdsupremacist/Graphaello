import Foundation
import SourceKittenFramework

extension SourceCode {

    var content: String {
        do {
            let start = try offset()
            let length = try self.length()
            return file.content(start: start, length: length).trimmingCharacters(in: .whitespaces)
        } catch {
            return file.contents
        }
    }

    func body() throws -> SourceCode {
        let start = try bodyOffset()
        let length = try bodyLength()
        let body = file.content(start: start, length: length)

        return try SourceCode(content: body, parent: self, location: location(of: Int(start)))
    }

}

extension File {

    fileprivate func content(start: Int64, length: Int64) -> String {
        let length = Int(length)
        let start = contents.index(contents.startIndex, offsetBy: max(0, Int(start - 1)))
        let end = contents.distance(from: start, to: contents.endIndex) < length ? contents.endIndex : contents.index(start, offsetBy: length)
        return String(contents[start..<end])
    }

}
