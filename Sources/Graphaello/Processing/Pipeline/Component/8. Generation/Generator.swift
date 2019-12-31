//
//  Generator.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol Generator {
    func generate(prepared: Project.State<Stage.Prepared>) throws -> String
}
