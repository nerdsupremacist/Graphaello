import CLIKit

enum ArgumentError: Error, CustomStringConvertible {
    case pathDoesNotExist(String)
    case noProjectFound(at: Path)
    case fileIsNotAProject(Path)
    case invalidApolloReference(String)
    case apolloIsNotInstalled
    case noBuildRootFolderProvided
    case invalidDerivedDataFolder

    var description: String {
        switch self {
        case .pathDoesNotExist(let path):
            return "error: Given path does not exist: \(path)"
        case .noProjectFound(let path):
            return "error: There is no Xcode Project in the provided folder: \(path.string)"
        case .fileIsNotAProject(let path):
            return "error: The file provided is not an Xcode Project: \(path.string)"
        case .invalidApolloReference(let reference):
            return "error: \"\(reference)\" is not a valid option for a reference to apollo"
        case .apolloIsNotInstalled:
            return "error: Apollo from binary was selected, but Apollo is not installed"
        case .noBuildRootFolderProvided:
            return "error: Apollo from derived data was selected, but no $BUILD_ROOT value could be found. Try running from Xcode"
        case .invalidDerivedDataFolder:
            return "error: The Derived Data folder provided appears to not include the checkouts of Swift Package Manager"
        }
    }

    var localizedDescription: String {
        return description
    }
}
