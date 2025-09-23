import UIKit
import Warp

public final class FullscreenAdViewController: UIViewController {
    private let makeView: (CGFloat) -> UIView
    private var mounted = false

    public init(makeView: @escaping (CGFloat) -> UIView) {
        self.makeView = makeView
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !mounted else { return }
        mounted = true
        let adContainer = makeView(view.bounds.width)
        adContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adContainer)

        NSLayoutConstraint.activate([
            adContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Warp.Spacing.spacing100),
            adContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: Warp.Spacing.spacing400),
            adContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
