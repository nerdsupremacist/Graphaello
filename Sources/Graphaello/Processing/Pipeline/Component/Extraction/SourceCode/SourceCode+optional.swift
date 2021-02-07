import Foundation

extension SourceCode {

    func optional<T>(decode: (SourceCode) throws -> T) rethrows -> T? {
        do {
            return try decode(self)
        } catch ParseError.missingKey {
            return nil
        }
    }

}
