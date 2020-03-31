//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class CoronaHelpDemoView: UIView {
    private lazy var backgroundView = UIView()
    private lazy var coronaHelpView = CoronaHelpView(withAutoLayout: true)
    private var sizeConstraints: [NSLayoutConstraint] = []
    let viewModel = CoronaHelpViewModel.sample

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundView.backgroundColor = .bgSecondary
        coronaHelpView.configure(with: viewModel)

        addSubview(backgroundView)
        addSubview(coronaHelpView)

        backgroundView.fillInSuperview()
        coronaHelpView.centerInSuperview()
        setupOnHorizontalSizeClass()
    }

    private func setupOnHorizontalSizeClass() {
        NSLayoutConstraint.deactivate(sizeConstraints)
        coronaHelpView.resetDropShadow()

        switch traitCollection.horizontalSizeClass {
        case .regular:
            sizeConstraints = [
                coronaHelpView.heightAnchor.constraint(equalToConstant: 480),
                coronaHelpView.widthAnchor.constraint(lessThanOrEqualToConstant: 340),
            ]
            coronaHelpView.dropShadow(
                color: .black,
                opacity: 0.5,
                offset: CGSize(width: 5, height: 5),
                radius: 30
            )
        default:
            sizeConstraints = [
                coronaHelpView.heightAnchor.constraint(equalToConstant: 480),
                coronaHelpView.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: .spacingM
                ),
                coronaHelpView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -.spacingM
                ),
            ]
        }

        NSLayoutConstraint.activate(sizeConstraints)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            setupOnHorizontalSizeClass()
        }
    }
}

extension CoronaHelpViewModel {
    static let sample = CoronaHelpViewModel(
        header: UIImage(named: "coronaHelpPopup"),
        title: "Takk til alle hverdagsheltene!",
        description: """
            Vi heier på alle dere der ute som støtter og hjelper andre. Dere som holder hjulene i gang!

            En ekstra stor takk til alle dere som tilbyr hjelp til andre gjennom koronahjelpen på FINN. Vi er rørt og imponert over responsen.
        """,
        readMore: Link(
            title: "Les mer om koronahjelpen",
            url: nil
        ),
        callToAction: Link(
            title: "Se alle annonsene",
            url: nil
        )
    )
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct CoronaHelpDemoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DemoWrapperView(view: CoronaHelpDemoView())
                .previewDisplayName("iPhone 11 Pro")

            DemoWrapperView(view: CoronaHelpDemoView())
                .previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
                .environment(\.colorScheme, ColorScheme.dark)
                .previewDisplayName("iPhone 8 (Dark)")

            DemoWrapperView(view: CoronaHelpDemoView())
                .environment(\.colorScheme, ColorScheme.dark)
                .previewDisplayName("iPhone 11 Pro (Dark)")

            DemoWrapperView(view: CoronaHelpDemoView())
                .previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
                .previewDisplayName("iPhone SE")

            DemoWrapperView(view: CoronaHelpDemoView())
                .previewDevice(PreviewDevice(stringLiteral: "iPad Pro (11-inch) (2nd generation)"))
                .previewDisplayName("iPad Pro 11-inch")
        }
    }
}
#endif
