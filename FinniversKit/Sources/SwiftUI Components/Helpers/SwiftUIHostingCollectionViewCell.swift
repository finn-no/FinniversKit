import SwiftUI

public class SwiftUIHostingCollectionViewCell<Content: View>: UICollectionViewCell {

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

            addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

            if let parent {
                controller.didMove(toParent: parent)
            }

            controller.view.layoutIfNeeded()
        }
    }
}
