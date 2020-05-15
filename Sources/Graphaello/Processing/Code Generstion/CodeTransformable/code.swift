import Foundation

func code(context: [String : Any] = [:], @CodeBuilder builder: () -> CodeTransformable) throws -> String {
    let transformable = builder()
    return try transformable.code(using: .custom, context: context)
}
