import UIKit

public class ActionBarButtonItem: UIBarButtonItem {
    public typealias ActionHandler = (UIBarButtonItem) -> Void

    private var actionHandler: ActionHandler?

    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionHandler: ActionHandler?) {
        self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }

    public convenience init(title: String?, style: UIBarButtonItem.Style, actionHandler: ActionHandler?) {
        self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }

    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, actionHandler: ActionHandler?) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }

    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?(sender)
    }
}
