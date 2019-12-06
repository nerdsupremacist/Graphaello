//
//  Component.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

indirect enum GraphQLComponent {
    enum Field {
        case direct(String)
        case call(String, call: [String : GraphQLPath.Component.Argument])
    }
    
    case scalar(Field)
    case object(Field, components: [GraphQLComponent])
    case fragment(GraphQLFragment)
}
