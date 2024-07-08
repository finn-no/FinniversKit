//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

class SpacingDemoView: UIView, Demoable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    func makeLabel(text: String) -> Label {
        let label = Label(style: .bodyStrong)
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .surfaceSunken
        label.textColor = .text
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
            spacingXXSView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing800),
            spacingXXSView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing25),
            spacingXXSView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing25),

            spacingXSView.topAnchor.constraint(equalTo: spacingXXSView.bottomAnchor, constant: Warp.Spacing.spacing800),
            spacingXSView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing50),
            spacingXSView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing50),

            spacingSView.topAnchor.constraint(equalTo: spacingXSView.bottomAnchor, constant: Warp.Spacing.spacing800),
            spacingSView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            spacingSView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

            spacingMView.topAnchor.constraint(equalTo: spacingSView.bottomAnchor, constant: Warp.Spacing.spacing800),
            spacingMView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            spacingMView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),

            spacingLView.topAnchor.constraint(equalTo: spacingMView.bottomAnchor, constant: Warp.Spacing.spacing800),
            spacingLView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing300),
            spacingLView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing300),

            spacingXLView.topAnchor.constraint(equalTo: spacingLView.bottomAnchor, constant: Warp.Spacing.spacing800),
            spacingXLView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            spacingXLView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),

            spacingXXLView.topAnchor.constraint(equalTo: spacingXLView.bottomAnchor, constant: Warp.Spacing.spacing800),
            spacingXXLView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing800),
            spacingXXLView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing800)
        ])
        backgroundColor = .background
    }
}
