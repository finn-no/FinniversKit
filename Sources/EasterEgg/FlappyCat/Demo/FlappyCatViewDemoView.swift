//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import SpriteKit

public class FlappyCatViewDemoView: UIView {
    lazy var flappyCatView: FlappyCatView = {
        let view = FlappyCatView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(flappyCatView)
        flappyCatView.fillInSuperview()
    }

    class func viewController(_ view: UIView) -> UIViewController {
        var responder: UIResponder? = view
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
}

extension FlappyCatViewDemoView: FlappyCatViewDelegate {
    public func flappyCatViewDidPressBackButton(_ flappyCatView: FlappyCatView) {
        if let viewController = FlappyCatViewDemoView.viewController(self) as? DemoViewController<FlappyCatViewDemoView> {
            viewController.didDoubleTap()
        }
    }
}
