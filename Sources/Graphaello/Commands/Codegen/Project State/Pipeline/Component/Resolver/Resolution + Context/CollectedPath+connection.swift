//
//  CollectedPath+leadsToConnection.swift
//  
//
//  Created by Mathias Quintero on 12/20/19.
//

import Foundation

extension CollectedPath {

    var connection: GraphQLConnectionFragment? {
        switch self {

        case .valid(let valid):
            return valid.connection

        case .empty:
            return nil

        }
    }

}

extension CollectedPath.Valid {

    var connection: GraphQLConnectionFragment? {
        switch self {

        case .connection(let connection):
            return connection

        case .fragment:
            return nil

        case .object(_, let valid):
            return valid.connection

        case .scalar:
            return nil

        case .typeConditional(_, let path):
            return path.connection

        }
    }

}
