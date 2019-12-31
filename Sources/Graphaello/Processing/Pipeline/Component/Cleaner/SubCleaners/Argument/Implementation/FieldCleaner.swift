//
//  FieldCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct FieldCleaner: ArgumentCleaner {

    func clean(resolved: Field,
               using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<Field> {

        return context + resolved
    }

}
