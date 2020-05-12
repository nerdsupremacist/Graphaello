
import Foundation

struct Location {
    let file: URL
    let line: Int?
    let column: Int?
}

extension Location {

    var locationDescription: String {
        let components: [String?] = [file.path, line.map { String($0 + 1) }, column.map { String($0 + 1) }]
        return components.compactMap { $0 }.joined(separator: ":")
    }

}
