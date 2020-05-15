import Foundation

struct BasicPropertyAliasingPropagator: PropertyAliasingPropagator {
    let propagator: ComponentAliasingPropagator
    
    func propagate(property: Property<Stage.Resolved>,
                   from resolved: Struct<Stage.Resolved>) throws -> Property<Stage.Cleaned> {
        
        return try property.map { path in
            let components: [Stage.Cleaned.Component]?
            switch path.validated.parsed.target {
                
            case .query:
                components = try resolved
                    .query
                    .map { try propagator.propagate(components: path.validated.components, from: $0) }

            case .mutation:
                components = nil
                
            case .object(let type):
                components = try resolved
                    .fragments
                    .first { $0.target.name == type }
                    .map { try propagator.propagate(components: path.validated.components, from: $0.object) }
                
            }
            
            return Stage.Cleaned.Path(resolved: path,
                                      components: components ??
                                        path.validated.components.map { Stage.Cleaned.Component(validated: $0, alias: nil) })
        }
    }
    
}

extension BasicPropertyAliasingPropagator {
    
    init(propagator: () -> ComponentAliasingPropagator) {
        self.init(propagator: propagator())
    }
    
}
