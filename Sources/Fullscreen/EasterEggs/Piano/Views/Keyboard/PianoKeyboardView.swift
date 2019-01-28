//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

protocol PianoKeyboardViewDataSource: AnyObject {
    func pianoKeyboardViewNumberOfKeyViews(_ pianoView: PianoKeyboardView) -> Int
}

protocol PianoKeyboardViewDelegate: AnyObject {
    func pianoKeyboardView(_ view: PianoKeyboardView, didSelectKeyViewAt index: Int)
    func pianoKeyboardView(_ view: PianoKeyboardView, didDeselectKeyViewAt index: Int)
}

final class PianoKeyboardView: UIView {
    weak var dataSource: PianoKeyboardViewDataSource?
    weak var delegate: PianoKeyboardViewDelegate?

    private let accidentalKeyIndices = Set([1, 3, 6, 8, 10])
    private var keyViews = [PianoKeyView]()
    private var selectedIndices = Set<Int>()

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    // swiftlint:disable identifier_name
    private func setupLayout() {
        let numberOfNaturalKeys: CGFloat = 7
        let widthWithSpacing = bounds.width / numberOfNaturalKeys
        let spacing = widthWithSpacing * 0.4 / 1.4
        let x = spacing / 2
        let width = widthWithSpacing - spacing
        var naturalFrame = CGRect(x: x, y: width, width: width, height: bounds.height - width)
        var accidentalFrame = CGRect(x: x, y: 0, width: width, height: width)

        for keyView in keyViews {
            if keyView.isAccidental {
                keyView.frame = accidentalFrame
                naturalFrame.origin.x = accidentalFrame.origin.x + (width + spacing) / 2
                accidentalFrame.origin.x += width + spacing
            } else {
                keyView.frame = naturalFrame
                accidentalFrame.origin.x = naturalFrame.maxX + (spacing - width) / 2
                naturalFrame.origin.x += width + spacing
            }

            keyView.layer.cornerRadius = width / 2
            keyView.layer.masksToBounds = true
        }
    }

    // MARK: - Subviews

    func reloadData() {
        removeKeyViews()
        addKeyViews()
        setupLayout()
    }

    private func addKeyViews() {
        guard let numberOfKeyViews = dataSource?.pianoKeyboardViewNumberOfKeyViews(self) else {
            return
        }

        for index in 0..<numberOfKeyViews {
            let keyView = PianoKeyView()
            keyView.isAccidental = accidentalKeyIndices.contains(index)
            keyViews.append(keyView)
            addSubview(keyView)
        }
    }

    private func removeKeyViews() {
        for keyView in keyViews {
            keyView.removeFromSuperview()
        }

        keyViews.removeAll()
    }

    // MARK: - Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let allTouches = event?.allTouches ?? Set<UITouch>()

        for touch in touches {
            if let index = keyViewIndex(for: touch.location(in: self)) {
                selectKeyView(at: index)
                deselectKeyViewsIfNeeded(for: allTouches)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let allTouches = event?.allTouches ?? Set<UITouch>()

        for touch in touches {
            let currentPoint = touch.location(in: self)
            let currentIndex = keyViewIndex(for: currentPoint)
            let previousPoint = touch.previousLocation(in: self)
            let previousIndex = keyViewIndex(for: previousPoint)

            if let currentIndex = currentIndex, currentIndex != previousIndex, bounds.contains(currentPoint) {
                selectKeyView(at: currentIndex)
            }

            deselectKeyViewsIfNeeded(for: allTouches)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            deselectKeyViewsIfNeeded(for: event?.allTouches ?? Set<UITouch>())
        }

        guard let allTouches = event?.allTouches else { return }

        for touch in touches {
            guard let index = keyViewIndex(for: touch.location(in: self)) else { continue }

            var allTouches = allTouches
            allTouches.remove(touch)

            if !keyViewIndices(for: allTouches).contains(index) {
                deselectKeyView(at: index)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        deselectKeyViewsIfNeeded(for: event?.allTouches ?? Set<UITouch>())
    }

    // MARK: - Selection

    private func selectKeyView(at index: Int) {
        guard let keyView = keyViews[safe: index], !keyView.isSelected else {
            return
        }

        keyView.isSelected = true
        selectedIndices.insert(index)
        delegate?.pianoKeyboardView(self, didSelectKeyViewAt: index)
    }

    private func deselectKeyView(at index: Int) {
        guard let keyView = keyViews[safe: index], keyView.isSelected else {
            return
        }

        keyView.isSelected = false
        selectedIndices.remove(index)
        delegate?.pianoKeyboardView(self, didDeselectKeyViewAt: index)
    }

    private func deselectKeyViewsIfNeeded(for touches: Set<UITouch>) {
        let indices = keyViewIndices(for: touches)
        let indicesToDeselect = selectedIndices.subtracting(indices)

        for index in indicesToDeselect {
            deselectKeyView(at: index)
        }
    }

    // MARK: - Helpers

    private func keyViewIndices(for touches: Set<UITouch>) -> Set<Int> {
        return Set(touches.compactMap { keyViewIndex(for: $0.location(in: self)) })
    }

    private func keyViewIndex(for point: CGPoint) -> Int? {
        return keyViews.firstIndex(where: { $0.frame.contains(point) })
    }
}

// MARK: - Extensions

private extension Array {
    subscript(safe index: Index) -> Element? {
        return index < count ? self[index] : nil
    }
}
