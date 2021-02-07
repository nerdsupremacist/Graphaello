import Foundation

protocol Generator {
    func generate(prepared: Project.State<Stage.Prepared>, useFormatting: Bool) throws -> String
}
