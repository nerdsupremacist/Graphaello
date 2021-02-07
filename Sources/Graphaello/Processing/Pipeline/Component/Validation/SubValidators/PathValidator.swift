import Foundation

protocol PathValidator {
    func validate(path: Stage.Parsed.Path, using apis: [API]) throws -> Stage.Validated.Path
}
