import UIKit

class LoginView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    func setup() {
        backgroundColor = .brown

        let miniView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 200))
        miniView.backgroundColor = .red
        addSubview(miniView)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
