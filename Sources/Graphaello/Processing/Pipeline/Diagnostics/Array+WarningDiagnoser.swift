
import Foundation

extension Array: WarningDiagnoser where Element: WarningDiagnoser {

    func diagnose(parsed: Struct<Stage.Parsed>) throws -> [Warning] {
        return try flatMap { try $0.diagnose(parsed: parsed) }
    }

}
