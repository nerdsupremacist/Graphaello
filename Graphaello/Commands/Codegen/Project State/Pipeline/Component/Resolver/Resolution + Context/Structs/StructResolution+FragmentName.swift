//
//  StructResolution+FragmentName.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension StructResolution {
    
    enum FragmentName {
        case fullName(String)
        case typealiasOnStruct(String, String)
    }
    
}
