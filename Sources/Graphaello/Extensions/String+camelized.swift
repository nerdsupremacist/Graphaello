import Foundation

// Copied and adapted from https://gist.github.com/reitzig/67b41e75176ddfd432cb09392a270218
// Modifications made public at: https://gist.github.com/nerdsupremacist/8e620beb2dcf6404f9edcac756ed28dc
private let badChars = CharacterSet.alphanumerics.inverted
private let allowedPrefixBadChars: CharacterSet = ["_"]

extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst().lowercased()
    }

    var camelized: String {
        guard !isEmpty else {
            return ""
        }
        
        guard uppercased() != self else { return lowercased() }

        let (prefix, parts) = nameParts()
        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})

        return ([prefix, first] + rest).joined(separator: "")
    }

    var upperCamelized: String {
        guard !isEmpty else {
            return ""
        }

        let (prefix, parts) = nameParts()
        return prefix + parts.map { String($0).uppercasingFirst }.joined(separator: "")
    }

    var snakeCased: String {
        guard !isEmpty else {
            return ""
        }

        let (prefix, parts) = nameParts()
        return prefix + parts.map { String($0).lowercased() }.joined(separator: "_")
    }
    

    var snakeUpperCased: String {
        return snakeCased.uppercased()
    }
    
    private func nameParts() -> (prefix: String, parts: [String]) {
        let (prefix, rest) = splitPrefix(of: allowedPrefixBadChars)

        let basics = rest.replacingOccurrences(of: "([a-z])([A-Z])",
                                          with: "$1 $2",
                                          options: .regularExpression)

        let complete = basics.replacingOccurrences(of: "([A-Z]+)([A-Z][a-z]|$)",
                                                   with: "$1 $2",
                                                   options: .regularExpression)

        return (
            prefix,
            complete.components(separatedBy: badChars).filter { !$0.isEmpty }
        )
    }

    private func splitPrefix(of characterSet: CharacterSet) -> (prefix: String, new: String) {
        guard !isEmpty else { return (self, self) }
        let splitIndex = firstIndex { !characterSet.contains($0) } ?? endIndex

        return (
            String(self[startIndex..<splitIndex]),
            String(self[splitIndex...])
        )
    }
}

extension CharacterSet {

    fileprivate func contains(_ character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy { contains($0) }
    }

}
