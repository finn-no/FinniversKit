//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0.0, *)
struct BasicListCellWrapper: UIViewControllerRepresentable {
    let cell: BasicListCell
    let onSelect: (UIView?) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        var cell = self.cell
        cell.action = { self.onSelect(context.coordinator.view) }
        return UIHostingController(rootView: cell)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.view = uiViewController.view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject {
        weak var view: UIView?
    }
}
