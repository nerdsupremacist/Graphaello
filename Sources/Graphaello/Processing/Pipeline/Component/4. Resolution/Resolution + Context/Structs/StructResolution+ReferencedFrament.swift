//
//  StructResolution+ReferencedFrament.swift
//  
//
//  Created by Mathias Quintero on 12/20/19.
//

import Foundation

extension StructResolution {

    enum ReferencedFragment {
        case name(StructResolution.FragmentName)
        case paging(with: StructResolution.FragmentName)
        case mutation(wrapperName: String, StructResolution.FragmentName)
    }

}
