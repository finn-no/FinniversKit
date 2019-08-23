//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FullscreenGalleryOverlayViewDataSource: AnyObject {
    func fullscreenGalleryOverlayView(_: FullscreenGalleryOverlayView, loadImageWithWidth width: CGFloat, imageIndex index: Int, dataCallback: @escaping (Int, UIImage?) -> Void)
}

protocol FullscreenGalleryOverlayViewDelegate: AnyObject {
    func fullscreenGalleryOverlayView(_: FullscreenGalleryOverlayView, selectedImageAtIndex index: Int)
    func fullscreenGalleryOverlayViewDismissButtonTapped(_: FullscreenGalleryOverlayView)
}

class FullscreenGalleryOverlayView: UIView {

    // MARK: - Public properties

    weak var dataSource: FullscreenGalleryOverlayViewDataSource?
    weak var delegate: FullscreenGalleryOverlayViewDelegate?
    private(set) var previewViewVisible: Bool

    var viewModel: FullscreenGalleryViewModel? {
        didSet {
            previewView.viewModel = viewModel
        }
    }

    var previewViewFrame: CGRect {
        return previewView.frame
    }

    var supportiveElementAlpha: CGFloat = 1.0 {
        didSet {
            captionLabel.alpha = supportiveElementAlpha
            dismissButton.alpha = supportiveElementAlpha
        }
    }

    // MARK: - Private properties

    private static let dismissButtonTappableSize: CGFloat = 55.0
    private static let captionFadeDuration = 0.2

    // MARK: - UI properties

    private let previewViewInitiallyVisible: Bool

    private lazy var captionLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .milk
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.shadowColor = .black
        return label
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear

        let dismissImage = UIImage(named: .miscCross)
        button.setImage(dismissImage, for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit

        return button
    }()

    private lazy var previewView: GalleryPreviewView = {
        let previewView = GalleryPreviewView(withAutoLayout: true)
        previewView.delegate = self
        previewView.dataSource = self
        return previewView
    }()

    private lazy var previewViewVisibleConstraint = previewView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)

    // The constant exists to prevent the preview-view from jumping back into the visible area
    // during the dismissal animation.
    private lazy var previewViewHiddenConstraint = previewView.topAnchor.constraint(equalTo: bottomAnchor, constant: .mediumLargeSpacing)

    // MARK: - Init

    override init(frame: CGRect) {
        fatalError("not implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    init(withPreviewViewVisible previewViewVisible: Bool) {
        self.previewViewInitiallyVisible = previewViewVisible
        self.previewViewVisible = previewViewVisible
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(captionLabel)
        addSubview(dismissButton)
        addSubview(previewView)

        let initialPreviewViewVisibilityConstraint = previewViewVisible
            ? previewViewVisibleConstraint
            : previewViewHiddenConstraint

        NSLayoutConstraint.activate([
            captionLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            captionLabel.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, constant: -(2 * CGFloat.mediumLargeSpacing)),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -.mediumSpacing),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: previewView.topAnchor, constant: -.mediumSpacing),

            dismissButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            dismissButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing),
            dismissButton.widthAnchor.constraint(equalToConstant: FullscreenGalleryOverlayView.dismissButtonTappableSize),
            dismissButton.heightAnchor.constraint(equalToConstant: FullscreenGalleryOverlayView.dismissButtonTappableSize),

            previewView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor),
            previewView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            previewView.centerXAnchor.constraint(equalTo: centerXAnchor),
            initialPreviewViewVisibilityConstraint
        ])
    }

    // MARK: - Public methods

    func scrollToImage(atIndex index: Int, animated: Bool) {
        previewView.scrollToItem(atIndex: index, animated: animated)
        setCaptionLabel(index: index)
    }

    func setThumbnailPreviewsVisible(_ visible: Bool) {
        guard visible != previewViewVisible else {
            return
        }

        if visible {
            NSLayoutConstraint.deactivate([previewViewHiddenConstraint])
            NSLayoutConstraint.activate([previewViewVisibleConstraint])
        } else {
            NSLayoutConstraint.deactivate([previewViewVisibleConstraint])
            NSLayoutConstraint.activate([previewViewHiddenConstraint])
        }

        previewViewVisible = visible
        layoutIfNeeded()
    }

    func superviewWillTransition(to size: CGSize) {
        previewView.superviewWillTransition(to: size)
    }

    // MARK: - View interactions

    @objc private func dismissButtonTapped() {
        delegate?.fullscreenGalleryOverlayViewDismissButtonTapped(self)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self {
            return nil
        }

        return result
    }

    // MARK: - Private methods

    private func setCaptionLabel(index: Int) {
        let caption = viewModel?.imageCaptions[safe: index]

        UIView.transition(with: captionLabel, duration: FullscreenGalleryOverlayView.captionFadeDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.captionLabel.text = caption
        })
    }
}

// MARK: - FullscreenGalleryTransitionAware
extension FullscreenGalleryOverlayView: FullscreenGalleryTransitionAware {
    public func prepareForTransition(presenting: Bool) {
        if presenting {
            captionLabel.alpha = 0.0
            dismissButton.alpha = 0.0

            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(false)
            }
        }
    }

    public func performTransitionAnimation(presenting: Bool) {
        if presenting {
            captionLabel.alpha = 1.0
            dismissButton.alpha = 1.0

            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(true)
            }
        } else {
            setThumbnailPreviewsVisible(false)
        }
    }
}

// MARK: - GalleryPreviewViewDataSource
extension FullscreenGalleryOverlayView: GalleryPreviewViewDataSource {
    func galleryPreviewView(_: GalleryPreviewView, loadImageWithWidth width: CGFloat, imageIndex index: Int, dataCallback: @escaping (Int, UIImage?) -> Void) {
        guard let dataSource = dataSource else {
            dataCallback(index, nil)
            return
        }

        dataSource.fullscreenGalleryOverlayView(self, loadImageWithWidth: width, imageIndex: index, dataCallback: dataCallback)
    }
}

// MARK: - GalleryPreviewViewDelegate
extension FullscreenGalleryOverlayView: GalleryPreviewViewDelegate {
    func galleryPreviewView(_ previewView: GalleryPreviewView, selectedImageAtIndex index: Int) {
        delegate?.fullscreenGalleryOverlayView(self, selectedImageAtIndex: index)
        previewView.scrollToItem(atIndex: index, animated: true)
    }
}
