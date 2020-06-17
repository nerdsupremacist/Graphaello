---
layout: default
---

# Try it out!

To load data from a GraphQL API you can use the `GraphQL` property wrapper inside your SwiftUI view. 
Graphaello will generate a query and all the networking, and UI code needed to display your view.


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

Resulting Screen:
![](/assets/MyCountryView.png)

</div>

[Get Started](https://github.com/nerdsupremacist/Graphaello)
{: .contentButton }