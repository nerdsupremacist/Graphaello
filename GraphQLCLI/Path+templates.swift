//
//  Path+tempaltes.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 29.11.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

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
    
    static let templates: Path = { binaryPath.parent() + "templates" }()
    
}
