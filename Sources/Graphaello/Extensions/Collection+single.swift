import Foundation

extension Collection {

    func single() -> Element? {
        guard count == 1 else { return nil }
        return first
    }

}
