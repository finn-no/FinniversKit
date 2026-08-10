//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import UIKit
import Warp

public class FavoriteAdsListEmptyView: UIView {

    // MARK: - Private properties

    private var hostingController: UIHostingController<StateViewContainer>?
    private var image: UIImage?
    private var titleText: String = ""
    private var bodyText: String = ""

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        // Keep the background transparent so the tableHeaderView (title + subtitle)
        // remains visible even when this empty view covers the full table bounds.
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Public methods

    public func configure(withImage image: UIImage, title: String, body: String) {
        self.image = image
        self.titleText = title
        self.bodyText = body
        renderHostingController()
    }

    // MARK: - Private methods

    private func renderHostingController() {
        let container = StateViewContainer(image: image, title: titleText, bodyText: bodyText)

        if let hostingController {
            hostingController.rootView = container
            return
        }

        let controller = UIHostingController(rootView: container)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = .clear
        addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        self.hostingController = controller
    }
}

private struct StateViewContainer: View {
    let image: UIImage?
    let title: String
    let bodyText: String

    var body: some View {
        StateView(
            image: image.map { .illustration(Image(uiImage: $0)) },
            imageWidth: 96,
            imageHeight: 96,
            title: title,
            description: bodyText
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
