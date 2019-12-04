//
//  Environment+custom.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil
import PathKit

extension Environment {

    static let custom: Environment = {
        let loader = FileSystemLoader(paths: [Path.templates])

        let ext = Extension()

        ext.registerFilter("isFragment") { value in
            guard let value = value as? Schema.GraphQLType.Field.TypeReference else { return nil }
            return value.isFragment
        }

        ext.registerFilter("swiftType") { value, arguments in
            guard let value = value as? Schema.GraphQLType.Field.TypeReference else { return nil }
            return value.swiftType(api: (arguments.first as? API)?.name)
        }

        ext.registerFilter("pathClass") { value in
            guard let value = value as? Schema.GraphQLType.Field.TypeReference else { return nil }
            return value.isFragment ? "GraphQLFragmentPath" : "GraphQLPath"
        }

        ext.registerFilter("hasArguments") { value in
            guard let value = value as? Schema.GraphQLType.Field else { return nil }
            return !value.arguments.isEmpty
        }

        ext.registerFilter("optionalType") { value in
            guard let value = value as? Schema.GraphQLType.Field.TypeReference else { return nil }
            return value.optional
        }

        return Environment(loader: loader, extensions: [ext])
    }()

}
