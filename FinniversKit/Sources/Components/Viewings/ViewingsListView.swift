import UIKit

public protocol ViewingsListViewDelegate: AnyObject {
    func viewingsListViewDidSelectAddToCalendarButton(_ view: ViewingsListView, forIndex index: Int)
}

public class ViewingsListView: UIView {
    public weak var delegate: ViewingsListViewDelegate?

    // MARK: - Private properties

    private let titleStyle: Label.Style
    private var viewModel: ViewingsListViewModel?
    private lazy var titleLabel: Label = Label(style: titleStyle, withAutoLayout: true)
    private lazy var viewingsStackView = UIStackView(axis: .vertical, withAutoLayout: true)

    private lazy var noteLabel: Label = {
        let label = Label(withAutoLayout: true)
        label.isHidden = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - Init

    public init(titleStyle: Label.Style = .title3, withAutoLayout: Bool = false) {
        self.titleStyle = titleStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(noteLabel)
        addSubview(viewingsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewingsStackView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor),
            viewingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewingsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewingsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ViewingsListViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        if let note = viewModel.note {
            noteLabel.attributedText = attributedNoteString(with: note)
            noteLabel.isHidden = false
        } else {
            noteLabel.isHidden = true
        }

        viewingsStackView.removeArrangedSubviews()

        viewModel.viewings.enumerated().forEach { index, viewing in
            let topMargin: CGFloat = viewModel.note != nil && index == 0 ? .spacingS : 0
            let view = ViewingItemView(withAutoLayout: true)
            view.configure(
                with: viewing,
                addToCalendarButtonTitle: viewModel.addToCalendarButtonTitle,
                showSeparator: true,
                topEdgeInset: topMargin
            )

            view.delegate = self

            viewingsStackView.addArrangedSubview(view)
        }
    }

    // MARK: - Private methods

    private func attributedNoteString(with text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = .spacingXXS

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.body
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - ViewingViewDelegate

extension ViewingsListView: ViewingItemViewDelegate {
    func viewingItemViewDidSelectAddToCalendarButton(_ view: ViewingItemView) {
        guard let index = viewingsStackView.arrangedSubviews.firstIndex(of: view) else {
            return
        }

        delegate?.viewingsListViewDidSelectAddToCalendarButton(self, forIndex: index)
    }
}
