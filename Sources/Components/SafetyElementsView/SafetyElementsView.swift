//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol SafetyElementsViewDelegate: AnyObject {
    func safetyElementsView(_ view: SafetyElementsView, didClickOnLink identifier: String?, url: URL)
}

public class SafetyElementsView: UIView {
    // MARK: - Public properties
    public var useCompactLayout: Bool = true {
        didSet {
            guard useCompactLayout != oldValue else { return }
            reconfigureUsedView()
        }
    }

    public weak var delegate: SafetyElementsViewDelegate?

    // MARK: - Private properties
    private var viewModels: [SafetyElementViewModel] = []

    // MARK: - Initializers
    private lazy var compactView: SafetyElementsCompactView = {
      let view = SafetyElementsCompactView(withAutoLayout: true)

      return view
    }()

    private lazy var regularView: SafetyElementsRegularView = {
      let view = SafetyElementsRegularView(withAutoLayout: true)

      return view
    }()

    public func configure(with viewModels: [SafetyElementViewModel]) {
        self.viewModels = viewModels
        reconfigureUsedView()
    }

    // MARK: - Private methods
    private func reconfigureUsedView() {
        compactView.removeFromSuperview()
        regularView.removeFromSuperview()

        if useCompactLayout {
            addSubview(compactView)
            compactView.configure(with: viewModels, delegate: self)
            compactView.fillInSuperview()
        } else {
            addSubview(regularView)
            regularView.configure(with: viewModels, delegate: self)
            regularView.fillInSuperview()
        }
    }
}

extension SafetyElementsView: SafetyElementContentViewDelegate {
    func safetyElementContentView(_ view: SafetyElementContentView, didClickOnLink identifier: String?, url: URL) {
        delegate?.safetyElementsView(self, didClickOnLink: identifier, url: url)
    }
}
