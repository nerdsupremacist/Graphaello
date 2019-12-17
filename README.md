# Graphaello

Graphaello is a command line tool to use GraphQL from SwiftUI. The easy way.

## Instalation

To install Graphaello, we use homebrew:

```
brew tap mmq/formulae https://bitbucket.ase.in.tum.de/scm/mmq/formulae.git
brew install graphaello
```

## Usage

To use Graphaello run the command:

```
graphaello codegen [--project {PATH_TO_YOUR_XCODE_PROJECT}]
```

Graphaello will scan your project for GraphQL Schema files in the format `{Name}.graphql.json` and create all the extension you need to access this schema from Swift. It will then scan your project for any `struct`s that are using information from GraphQL via the `@GraphQL` property wrapper, and autogenerate any fragments and queries.

Example:

```swift
struct CountryCell: View {
    @GraphQL(Countries.Country.name)
    var name: String

    @GraphQL(Countries.Country.name)
    var emoji: String
    
    var body: some View {
        VStack {
            Text($0)
            Text($0)
        }
    }
}

struct CountryList: View {
    @GraphQL(Countries.countries)
    var countries: [CountryCell.Country]
    
    var body: some View {
        List(countries, id: \.name) { CountryCell(country: $0) }
    }
}

let api = Countries(client: ...)
api.countryList() // return a view with the country list
```

## Suggested Workflow

To use the suggested workflow for Graphaello, simply run `graphaello init` in your repository and graphaello will insert itself into your project:

1. It will add Apollo as a Swift Package Dependency
2. It will add a codegen build phase to your project
