//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
extension View {
    public func appearance<T: UIView>(customize: @escaping (T) -> Void) -> some View {
        Appearance(content: self, customize: customize)
    }
}

@available(iOS 13.0.0, *)
extension List {
    public func listSeparatorStyleNone() -> some View {
        appearance { (view: UITableView) in
            view.separatorStyle = .none
        }
    }
}

// MARK: - Private types

@available(iOS 13.0.0, *)
private struct Appearance<Content: View, UIViewType: UIView>: UIViewControllerRepresentable {
    private var content: Content
    private var customize: (UIViewType) -> Void

    init(content: Content, customize: @escaping (UIViewType) -> Void) {
        self.content = content
        self.customize = customize
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return UIHostingController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        customize(UIViewType.appearance(whenContainedInInstancesOf: [UIHostingController<Content>.self]))
    }
}
