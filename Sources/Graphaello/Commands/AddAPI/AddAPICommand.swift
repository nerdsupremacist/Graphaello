import Foundation
import CLIKit

private let query = """
query IntrospectionQuery {
  __schema {
    queryType {
      name
    }
    mutationType {
      name
    }
    types {
      ...FullType
    }
  }
}

fragment FullType on __Type {
  kind
  name
  description
  fields(includeDeprecated: true) {
    name
    description
    args {
      ...InputValue
    }
    type {
      ...TypeRef
    }
    isDeprecated
    deprecationReason
  }
  inputFields {
    ...InputValue
  }
  interfaces {
    ...TypeRef
  }
  enumValues(includeDeprecated: true) {
    name
    description
    isDeprecated
    deprecationReason
  }
  possibleTypes {
    ...TypeRef
  }
}

fragment InputValue on __InputValue {
  name
  description
  type {
    ...TypeRef
  }
  defaultValue
}

fragment TypeRef on __Type {
  kind
  name
  ofType {
    kind
    name
    ofType {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
              }
            }
          }
        }
      }
    }
  }
}
"""

class AddAPICommand : Command {
    @CommandOption(default: .first(Path.currentDirectory),
                   description: "Path to Xcode Project using GraphQL.")
    var project: ProjectPath

    @CommandOption(default: Optional<String>.none, description: "Name for the API.")
    var apiName: String?

    @CommandFlag(description: "Skip the code generation step.")
    var skipGencode: Bool

    @CommandRequiredInput(description: "URL to the GraphQL API.")
    var url: URL

    @CommandFlag(description: "Should not cache generated code.")
    var skipCache: Bool

    @CommandOption(default: 100, description: "Maximum number of items that should be cached.")
    var cacheSize: Int

    var description: String {
        return "Adds/Updates an API Schema to your project"
    }

    func run() throws {
        let apiName = self.apiName ?? url.host?.upperCamelized ?? "API"
        Console.print(title: "🚀 Loading Schema for \(apiName)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["query" : query])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let dispatchGroup = DispatchGroup()

        var responseData: Data?
        var responseError: Error?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            responseData = data
            responseError = error
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        task.resume()

        dispatchGroup.wait()

        if let responseError = responseError {
            throw responseError
        }

        Console.print(title: "🔬 Deserializing Data")

        guard let data = responseData else { return }
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String : Any], var object = json["data"] as? [String : Any] else { return }
        object["url"] = url.absoluteString
        let content = try JSONSerialization.data(withJSONObject: object)

        Console.print(title: "💉 Adding Schema to Project")
        try project.open().writeFile(name: "\(apiName).graphql.json", data: content, kind: .resource)

        Console.print("")

        if !skipGencode {
            let codegen = CodegenCommand()
            codegen.project = self.project
            codegen.apollo = .binary
            codegen.skipCache = skipCache
            codegen.cacheSize = cacheSize
            try codegen.run()
        } else {
            Console.print("✅ Done")
        }
    }
}

extension Optional: CommandArgumentValue where Wrapped: CommandArgumentValue {

    public init(argumentValue: String) throws {
        self = try Wrapped(argumentValue: argumentValue)
    }

}
