import SwiftUI

public struct HeadlessTabView<Tab, Content>: View
where Tab: Hashable & CaseIterable, Content: View {

    @Binding var selection: Tab

    private let content: (Tab) -> Content

    public init(_ selection: Binding<Tab>, @ViewBuilder content: @escaping (Tab) -> Content)
    {
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            Inner($selection, proxy: proxy, content: content).edgesIgnoringSafeArea(.all)
        }
    }
}

extension HeadlessTabView {
    fileprivate struct Inner {
        @Binding var selection: Tab

        private let content: (Tab) -> Content

        var proxy: GeometryProxy

        public init(
            _ selection: Binding<Tab>,
            proxy: GeometryProxy,
            content: @escaping (Tab) -> Content
        ) {
            self._selection = selection
            self.content = content
            self.proxy = proxy
        }
    }
}

extension HeadlessTabView.Inner: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> HeadlessTabView.Controller {
        HeadlessTabView.Controller(nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ uiViewController: HeadlessTabView.Controller, context: Context) {

        guard context.coordinator.currentSelection != selection else {
            return
        }

        defer {
            context.coordinator.currentSelection = selection
        }

        let viewController: UIViewController

        if let existing = context.coordinator.storedViewControllers[selection] {
            viewController = existing
        }
        else {
            viewController = UIHostingController(
                rootView: content(selection).id(selection)
            )

            context.coordinator.storedViewControllers[selection] = viewController
        }

        uiViewController.passedEdgeInsets = UIEdgeInsets(
            top: proxy.safeAreaInsets.top,
            left: proxy.safeAreaInsets.leading,
            bottom: proxy.safeAreaInsets.bottom,
            right: proxy.safeAreaInsets.trailing
        )
        uiViewController.selectedChild = viewController
    }

    func makeCoordinator() -> HeadlessTabView.Coordinator {
        HeadlessTabView.Coordinator()
    }
}

extension HeadlessTabView {
    fileprivate final class Controller: UIViewController {

        var passedEdgeInsets: UIEdgeInsets?

        override func loadView() {
            view = UIView()
            view.backgroundColor = .clear
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            guard let parentSafeAreaInsets = parent?.view.safeAreaInsets,
                let passedEdgeInsets = passedEdgeInsets
            else {
                additionalSafeAreaInsets = .zero
                return
            }

            additionalSafeAreaInsets = UIEdgeInsets(
                top: passedEdgeInsets.top - parentSafeAreaInsets.top,
                left: passedEdgeInsets.left - parentSafeAreaInsets.left,
                bottom: passedEdgeInsets.bottom - parentSafeAreaInsets.bottom,
                right: passedEdgeInsets.right - parentSafeAreaInsets.right
            )
        }

        var selectedChild: UIViewController? {
            willSet {

                guard isViewLoaded && view.superview != nil else {
                    return
                }

                willRemove(
                    children: children.filter({ child in
                        child != selectedChild
                    })
                )

                guard let newValue = newValue else {
                    return
                }

                willAdd(child: newValue)
            }
            didSet {
                guard isViewLoaded && view.superview != nil else {
                    return
                }

                didRemove(
                    children: children.filter({ child in
                        child != selectedChild
                    })
                )

                guard let selectedChild = selectedChild else {
                    return
                }

                didAdd(child: selectedChild)
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            guard let selectedChild = selectedChild else {
                return
            }

            willAdd(child: selectedChild)
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            guard let selectedChild = selectedChild else {
                return
            }

            didAdd(child: selectedChild)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            willRemove(children: children)
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)

            didRemove(children: children)
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
        }

        // MARK: - Convenience

        private func willAdd(child: UIViewController) {

            addChild(child)

            child.view.translatesAutoresizingMaskIntoConstraints = false
            child.view.backgroundColor = .clear

            view.addSubview(child.view)

            NSLayoutConstraint.activate([
                child.view.topAnchor.constraint(equalTo: view.topAnchor),
                child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }

        private func didAdd(child: UIViewController) {
            child.didMove(toParent: self)
        }

        private func willRemove(children: [UIViewController]) {
            for child in children {
                child.willMove(toParent: nil)
            }
        }

        private func didRemove(children: [UIViewController]) {
            for child in children {
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
}

extension HeadlessTabView {
    fileprivate class Coordinator {
        var storedViewControllers: [Tab: UIViewController] = [:]
        var currentSelection: Tab?
    }
}
