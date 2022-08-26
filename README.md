# HeadlessTabView

Minimal SwiftUI library providing a simple `TabView` alternative without the compulsory tab bar, or the subtle headaches of using conditional rendering.

## Overview

This project was sprung from the need for a `View` capable of the following:

1. Preserve internal state of conditional views to enable "multitasking" within applications
2. Cleanly detach conditional views from the view hierarchy, and properly appearance life cycle events
3. Allow for a custom (or hidden) method of switching tabs

Surprisingly, no apparent existing fits:

| Solution                        | Persists state | Appearance cycle events | No extras |
| ------------------------------- | -------------- | ----------------------- | --------- |
| `TabView`                       | ✅             | ✅                      | ❌        |
| Conditional rendering           | ❌             | ✅                      | ✅        |
| `ZStack` + `.opacity` modifiers | ✅             | ❌                      | ✅        |
| `HeadlessTabView`               | ✅             | ✅                      | ✅        |

## Requirements

- iOS 13.0+
- tvOS 13.0+

## Usage

```swift
import HeadlessTabView

// Declare a `Hashable & CaseIterable` type
enum Selection: String, Hashable, CaseIterable {
    case first
    case second
}

struct Content: View {

    @State var selection: Selection = .first

    var body: some View {
        HeadlessTabView($selection) { selection in
          // NOTE: This @ViewBuilder block is returned in its
          // entirety, meaning that if each view needs e.g. a `NavigationView`,
          // it's workable to wrap the entire switch statement in one.
          switch(selection) {
              case .first:
                // First view
              case .second:
                // Second view
            }
        }
    }
}

```

## Contribute

Please feel welcome contributing to **HeadlessTabView**, check the `LICENSE` file for more info.

## Credits

David Ask
