import Foundation

final class SubParser<Input, Output> {
    private let _parse: (Input, SubParser<Input, Output>) throws -> Output
    
    init(parse: @escaping (Input, SubParser<Input, Output>) throws -> Output) {
        _parse = parse
    }
    
    convenience init(parse: @escaping (Input) throws -> Output) {
        self.init { input, _ in try parse(input) }
    }
    
    func parse(from input: Input) throws -> Output {
        return try _parse(input, self)
    }
}
