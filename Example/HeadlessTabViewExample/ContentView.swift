import HeadlessTabView
import SwiftUI

enum Selection: String, Hashable, CaseIterable {
    case blue
    case green
}

struct ContentView: View {

    @State var selection: Selection = .blue

    var body: some View {
        VStack {
            HeadlessTabView($selection) { selection in
                NavigationView {
                    GeometryReader { proxy in
                        ScrollView(.vertical) {
                            switch selection {
                            case .blue:
                                VStack {
                                    Rectangle().fill(.blue).frame(height: proxy.size.height / 2)
                                    Rectangle().fill(.cyan).frame(height: proxy.size.height / 2)
                                }
                                .padding()
                                .navigationTitle("Blue")

                            case .green:

                                VStack(alignment: .leading) {
                                    Rectangle().fill(.green).frame(height: proxy.size.height / 2)
                                    Rectangle().fill(.mint).frame(height: proxy.size.height / 2)
                                }
                                .padding()
                                .navigationTitle("Green")
                            }
                        }
                    }
                }
            }
            .background(Color.red)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            selection = .blue
                        }
                    } label: {
                        Text("Blue")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    Spacer()
                    Button {
                        selection = .green
                    } label: {
                        Text("Green")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    Spacer()
                }
                .padding()
                .background(.thinMaterial)
            }
        }
    }
}

struct StateSubview: View {
    @Binding var selection: Selection

    let this: Selection

    let next: Selection

    var body: some View {
        VStack {
            Text("View for state '\(this.rawValue)'").font(.largeTitle)
            Button {
                selection = next
            } label: {
                Text("Switch")
            }
        }
    }
}
