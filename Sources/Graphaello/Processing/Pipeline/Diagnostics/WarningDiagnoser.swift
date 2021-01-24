
import Foundation

protocol WarningDiagnoser {
    func diagnose(parsed: Struct<Stage.Parsed>) throws -> [Warning]
}
