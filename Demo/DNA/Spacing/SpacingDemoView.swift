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
        let verySmallSpacingView = makeLabel(text: "👈        verySmallSpacing        👉")
        addSubview(verySmallSpacingView)

        let smallSpacingView = makeLabel(text: "👈        smallSpacing        👉")
        addSubview(smallSpacingView)

        let mediumSpacingView = makeLabel(text: "👈        mediumSpacing        👉")
        addSubview(mediumSpacingView)

        let largeSpacingView = makeLabel(text: "👈        largeSpacing        👉")
        addSubview(largeSpacingView)

        let veryLargeSpacingView = makeLabel(text: "👈        veryLargeSpacing        👉")
        addSubview(veryLargeSpacingView)

        NSLayoutConstraint.activate([
            verySmallSpacingView.topAnchor.constraint(equalTo: topAnchor, constant: .veryLargeSpacing),
            verySmallSpacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .verySmallSpacing),
            verySmallSpacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.verySmallSpacing),

            smallSpacingView.topAnchor.constraint(equalTo: verySmallSpacingView.bottomAnchor, constant: .veryLargeSpacing),
            smallSpacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),
            smallSpacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),

            mediumSpacingView.topAnchor.constraint(equalTo: smallSpacingView.bottomAnchor, constant: .veryLargeSpacing),
            mediumSpacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            mediumSpacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            largeSpacingView.topAnchor.constraint(equalTo: mediumSpacingView.bottomAnchor, constant: .veryLargeSpacing),
            largeSpacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            largeSpacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            veryLargeSpacingView.topAnchor.constraint(equalTo: largeSpacingView.bottomAnchor, constant: .veryLargeSpacing),
            veryLargeSpacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .veryLargeSpacing),
            veryLargeSpacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.veryLargeSpacing)
        ])
    }
}
