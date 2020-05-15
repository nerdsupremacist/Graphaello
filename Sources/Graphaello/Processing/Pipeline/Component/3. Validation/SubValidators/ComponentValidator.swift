import Foundation

protocol ComponentValidator {
    func validate(component: Stage.Parsed.Component,
                  using context: ComponentValidation.Context) throws -> ComponentValidation.Result
}
