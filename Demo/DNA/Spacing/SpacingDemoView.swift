//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SpacingDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    func makeLabel(text: String) -> Label {
        let label = Label(style: .bodyStrong)
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .licorice
        label.textColor = .milk
        label.textAlignment = .center
        return label
    }

    private func setup() {
        let spacingXXSView = makeLabel(text: "👈        spacingXXS        👉")
        addSubview(spacingXXSView)

        let spacingXSView = makeLabel(text: "👈        spacingXS        👉")
        addSubview(spacingXSView)

        let spacingSView = makeLabel(text: "👈        spacingS        👉")
        addSubview(spacingSView)

        let spacingMView = makeLabel(text: "👈        spacingM        👉")
        addSubview(spacingMView)

        let spacingLView = makeLabel(text: "👈        spacingL        👉")
        addSubview(spacingLView)

        let spacingXLView = makeLabel(text: "👈        spacingXL        👉")
        addSubview(spacingXLView)

        let spacingXXLView = makeLabel(text: "👈        spacingXXL        👉")
        addSubview(spacingXXLView)

        NSLayoutConstraint.activate([
            spacingXXSView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXXL),
            spacingXXSView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXXS),
            spacingXXSView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXXS),

            spacingXSView.topAnchor.constraint(equalTo: spacingXXSView.bottomAnchor, constant: .spacingXXL),
            spacingXSView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXS),
            spacingXSView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXS),

            spacingSView.topAnchor.constraint(equalTo: spacingXSView.bottomAnchor, constant: .spacingXXL),
            spacingSView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            spacingSView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),

            spacingMView.topAnchor.constraint(equalTo: spacingSView.bottomAnchor, constant: .spacingXXL),
            spacingMView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            spacingMView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            spacingLView.topAnchor.constraint(equalTo: spacingMView.bottomAnchor, constant: .spacingXXL),
            spacingLView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingL),
            spacingLView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingL),

            spacingXLView.topAnchor.constraint(equalTo: spacingLView.bottomAnchor, constant: .spacingXXL),
            spacingXLView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            spacingXLView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            spacingXXLView.topAnchor.constraint(equalTo: spacingXLView.bottomAnchor, constant: .spacingXXL),
            spacingXXLView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXXL),
            spacingXXLView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXXL)
        ])
    }
}
