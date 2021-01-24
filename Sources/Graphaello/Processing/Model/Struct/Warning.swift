
import Foundation

struct Warning: CustomStringConvertible {
    let location: Location
    let descriptionText: String

    var description: String {
        return "\(location.locationDescription): warning: \(descriptionText)"
    }
}
