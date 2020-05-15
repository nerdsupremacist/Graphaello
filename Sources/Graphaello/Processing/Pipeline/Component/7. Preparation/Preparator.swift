import Foundation

protocol Preparator {
    func prepare(assembled: Project.State<Stage.Assembled>,
                 using apollo: ApolloReference) throws -> Project.State<Stage.Prepared>
}
