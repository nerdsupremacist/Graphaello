//
//  GraphQLPath+Target.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension GraphQLPath {

    enum Target {
        case query
        case object(String)
    }

}
