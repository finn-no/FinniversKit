//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol SafetyElementsViewDelegate: AnyObject {
    func safetyElementsView(_ view: SafetyElementsView, didClickOnLink identifier: String?, url: URL)
    func safetyElementsView(_ view: SafetyElementsView, didSelectElementAt index: Int)
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
    private var selectedElementIndex: Int = 0

    // MARK: - Initializers
    private lazy var compactView = CompactView(withAutoLayout: true)
    private lazy var regularView = RegularView(withAutoLayout: true)

    public func configure(with viewModels: [SafetyElementViewModel], selectedElementIndex: Int = 0) {
        self.viewModels = viewModels
        self.selectedElementIndex = selectedElementIndex
        reconfigureUsedView()
    }

    // MARK: - Private methods
    private func reconfigureUsedView() {
        compactView.removeFromSuperview()
        regularView.removeFromSuperview()

        if useCompactLayout {
            addSubview(compactView)
            compactView.configure(with: viewModels, contentDelegate: self)
            compactView.fillInSuperview()
        } else {
            addSubview(regularView)
            regularView.configure(
                with: viewModels,
                selectedElementIndex: selectedElementIndex,
                contentDelegate: self
            )
            regularView.fillInSuperview()
        }
    }
}

extension SafetyElementsView: SafetyElementContentViewDelegate {
    func safetyElementContentView(_ view: ElementContentView, didClickOnLink identifier: String?, url: URL) {
        delegate?.safetyElementsView(self, didClickOnLink: identifier, url: url)
    }
}

extension SafetyElementsView: SafetyElementsRegularViewDelegate {
    func safetyElementsRegularView(_ view: RegularView, didSelectElementAt index: Int) {
        delegate?.safetyElementsView(self, didSelectElementAt: index)
    }
}
