//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class DescriptionView: UIView {

    // MARK: - Internal properties

    lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: FontType.light.rawValue, size: 18)
        label.textColor = .licorice
        label.text = "Beskrivelse"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textView: TextView = {
        let view = TextView(frame: .zero)
        view.placeholderText = "Beskriv kort hva problemet er"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    weak var delegate: TextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(title)
        addSubview(textView)

        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: .mediumLargeSpacing),
            title.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            textView.leftAnchor.constraint(equalTo: leftAnchor, constant: .mediumLargeSpacing),
            textView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .mediumLargeSpacing),
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.mediumLargeSpacing),

            bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: .mediumLargeSpacing),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DescriptionView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Did begin editing")
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("Did end editing")
    }
}
