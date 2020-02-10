//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public class SafetyElementsView: UIView {
    // MARK: - Public properties
    public var useCompactLayout: Bool = true {
        didSet {
            guard useCompactLayout != oldValue else { return }
            reconfigureUsedView()
        }
    }

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
            compactView.configure(with: viewModels)
            compactView.fillInSuperview()
        } else {
            addSubview(regularView)
            regularView.configure(with: viewModels)
            regularView.fillInSuperview()
        }
    }
}
