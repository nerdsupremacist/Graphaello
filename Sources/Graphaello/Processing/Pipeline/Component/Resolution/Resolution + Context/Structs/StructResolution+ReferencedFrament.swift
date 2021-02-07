import Foundation

extension StructResolution {

    enum ReferencedFragment {
        case name(StructResolution.FragmentName)
        case paging(with: StructResolution.FragmentName)
    }

}
