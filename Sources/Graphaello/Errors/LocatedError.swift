import Foundation

struct LocatedError : Error, CustomStringConvertible {
    let location: Location
    let error: Error

    var description: String {
        return "\(location.locationDescription): error: \(error)"
    }
}

func locateErrors<T>(with location: Location, value: () throws -> T) throws -> T {
    do {
        return try value()
    } catch let error as LocatedError {
        throw error
    } catch {
        throw LocatedError(location: location, error: error)
    }
}
