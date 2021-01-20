import Foundation
import PathKit

private let binaryPath: Path = {
  var binaryPath = Path(ProcessInfo.processInfo.arguments[0])
  do {
    while binaryPath.isSymlink {
      binaryPath = try binaryPath.symlinkDestination()
    }
  } catch {
    print("Warning: could not resolve symlink of \(binaryPath) with error \(error)")
  }
  return binaryPath
}()

extension Path {
    
    static let templates = templatePath()
    
}

private func templatePath(file: StaticString = #file) -> Path {
	
	let templatesPath = Path("templates")
	
	var path: Path = {
		#if DEBUG
		return Path(file.description)
		#else
		return binaryPath
		#endif
	}()
	
	while (path + templatesPath).exists == false {
		path = path.parent()
	}
	return path + templatesPath
}
