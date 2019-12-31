//
//  Project+State.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SourceKittenFramework

extension Project {

    struct State<CurrentStage: StageProtocol> {
        let apis: [API]
        let structs: [Struct<CurrentStage>]
    }
    
}

extension Pipeline {
    
    func extract(from project: Project) throws -> Project.State<Stage.Extracted> {
        let apis = try project.scanAPIs()
        let swiftFiles = try project.files()
            .filter { $0.extension == "swift" }
            .compactMap { File(path: $0.string) }
    
        let extracted = try extract(from: swiftFiles)
        return Project.State(apis: apis, structs: extracted)
    }
    
    func parse(extracted: Project.State<Stage.Extracted>) throws -> Project.State<Stage.Parsed> {
        return Project.State(apis: extracted.apis,
                             structs: try parse(extracted: extracted.structs).filter { $0.hasGraphQLValues })
    }
    
    func validate(parsed: Project.State<Stage.Parsed>) throws -> Project.State<Stage.Validated> {
        return Project.State(apis: parsed.apis,
                             structs: try validate(parsed: parsed.structs, using: parsed.apis))
    }
    
    func resolve(validated: Project.State<Stage.Validated>) throws -> Project.State<Stage.Resolved> {
        return Project.State(apis: validated.apis, structs: try resolve(validated: validated.structs))
    }

    func clean(resolved: Project.State<Stage.Resolved>) throws -> Project.State<Stage.Resolved> {
        return Project.State(apis: resolved.apis, structs: try clean(resolved: resolved.structs))
    }
    
}

extension Project.State where CurrentStage: GraphQLStage {

    var graphQLPaths: [CurrentStage.Path] {
        return structs.flatMap { $0.properties.compactMap { $0.graphqlPath } }
    }

}

extension Project.State where CurrentStage: ResolvedStage {

    var allConnectionQueries: OrderedSet<GraphQLConnectionQuery> {
        return structs.flatMap { OrderedSet($0.connectionQueries) }
    }

    var allConnectionFragments: OrderedSet<GraphQLConnectionFragment> {
        return allConnectionQueries.map { $0.fragment }
    }

    var allFragments: [GraphQLFragment] {
        return structs.flatMap { $0.fragments }
    }

    var allQueries: [GraphQLQuery] {
        return structs.compactMap { $0.query }
    }

}

