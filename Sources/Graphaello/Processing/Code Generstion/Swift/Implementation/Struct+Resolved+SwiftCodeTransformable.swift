//
//  Struct<Stage.Resolved>+SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Struct: CodeTransformable where CurrentStage == Stage.Resolved { }

extension Struct: SwiftCodeTransformable where CurrentStage == Stage.Resolved { }

extension Struct: ExtraValuesSwiftCodeTransformable where CurrentStage == Stage.Resolved {
    
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "functionName" : name.camelized,
            "initializerArguments" : initializerArguments,
            "initializerValueAssignments" : initializerValueAssignments,
            "queryRendererArguments": queryRendererArguments,
            "queryArgumentAssignments": queryArgumentAssignments,
            "initializerArgumentAssignmentFromQueryData": initializerArgumentAssignmentFromQueryData,
            "missingFragmentsStructs": Array(missingFragmentsStructs),
            "missingReferencedFragments": Array(missingReferencedFragments),
        ]
    }
    
}
