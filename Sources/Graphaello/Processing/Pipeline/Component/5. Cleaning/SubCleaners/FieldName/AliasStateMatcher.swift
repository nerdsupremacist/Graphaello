//
//  AliasStateMatcher.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

protocol AliasStateMatcher {
    func match(query: GraphQLQuery, to aliased: GraphQLQuery) -> GraphQLQuery
}
