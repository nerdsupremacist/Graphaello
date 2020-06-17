---
layout: default
---

# Try it out!

To load data from a GraphQL API you can use the `GraphQL` property wrapper inside your SwiftUI view. 
Graphaello will generate a query and all the networking, and UI code needed to display your view.

In this example we are fetching data from an API that aggregates information about Covid-19. 
We ask for the name of the country of the current user and the number of cases in that country using the `GraphQL` property wrapper and display it to the user:

<div class="side-by-side-code">

```swift
struct MyCountryView: View {
  @GraphQL(Covid.myCountry.name)
  var name: String

  @GraphQL(Covid.myCountry.cases)
  var cases: Int

  var body: some View {
    VStack(alignment: .leading) {
      Text(name).font(.title)

      Text("There's been a total of \(cases) cases in \(name).")
        .font(.body)
        .foregroundColor(.secondary)
    }
  }
}

let view = Covid().myCountryView()
```

Rendered UI:
![](/assets/MyCountryView.png)

</div>

[Get Started](https://github.com/nerdsupremacist/Graphaello)
{: .contentButton }