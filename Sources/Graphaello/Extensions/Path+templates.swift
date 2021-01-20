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
	
    #if DEBUG
	var path = Path(file.description)
	while (path + templatesPath).exists == false {
		path = path.parent()
	}
    return path + templatesPath
    #else
	let graphaelloPath = Path("graphaello") + templatesPath
	var path = binaryPath
	var pathExists = false
	
	while pathExists == false {
		if (path + graphaelloPath).exists {
			path = path + graphaelloPath
			pathExists = true
		} else if (path + templatesPath).exists {
			path = path + templatesPath
			pathExists = true
		} else {
			path = path.parent()
		}
	}
    return path
    #endif
}
