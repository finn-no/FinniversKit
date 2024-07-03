import SwiftUI

public class SwiftUIHostingTableViewCell<Content: View>: UITableViewCell {

    private var controller: UIHostingController<Content>?

    public func host(_ view: Content, parent: UIViewController? = nil) {

        if let controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let controller = UIHostingController(rootView: view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.backgroundColor = .clear
            self.controller = controller

            parent?.addChild(controller)

            contentView.addSubview(controller.view)

            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

            if let parent {
                controller.didMove(toParent: parent)
            }

            controller.view.layoutIfNeeded()
        }
    }
}
