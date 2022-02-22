
import Foundation

// TODO: finish this list
private let keywords: Set<String> = [
    "public",
    "private",
    "extension",
    "internal",
    "default",
    "repeat",
    "where",
    "in",
    "enum",
    "self",
    "do",
    "as",
    "is",
]

extension String {

    var keywordProtected: String {
        if keywords.contains(self) {
            return "`\(self)`"
        } else {
            return self
        }
    }

}
