//
//  FieldCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct FieldCleaner: SubCleaner {

    func clean(resolved: Field,
               using context: Cleaning.Context) throws -> Cleaning.Result<Field> {

        return context + resolved
    }

}
