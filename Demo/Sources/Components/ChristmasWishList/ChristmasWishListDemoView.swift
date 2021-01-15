//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class ChristmasWishListDemoView: UIView {
    private lazy var backgroundView = UIView()
    private lazy var christmasWishListView = ChristmasWishListView(withAutoLayout: true)
    let viewModel = ChristmasWishListViewModel()

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
        christmasWishListView.configure(with: viewModel)

        addSubview(backgroundView)
        addSubview(christmasWishListView)

        christmasWishListView.dropShadow(color: .black, opacity: 0.5, offset: CGSize(width: 5, height: 5), radius: 30)

        backgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            christmasWishListView.widthAnchor.constraint(equalToConstant: 337),
            christmasWishListView.heightAnchor.constraint(equalToConstant: 463),
            christmasWishListView.centerXAnchor.constraint(equalTo: centerXAnchor),
            christmasWishListView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ChristmasWishListViewModel {
    init() {
        self.init(
            firstPage: Page(
                title: "Ønsk deg brukte gaver til jul!",
                text: "Gjør det enkelt for dine nærmeste ved å dele ønskelisten din!",
                accessoryButtonTitle: "Les mer om brukte julegaver",
                actionButtonIcon: UIImage(named: .gift),
                actionButtonTitle: "Lag ønskeliste"
            ),
            secondPage: Page(
                title: "Ønskelisten din er nå opprettet",
                text: "Du vil nå kunne finne en helt nystrøken ønskeliste blant dine favorittlister.",
                accessoryButtonTitle: nil,
                actionButtonIcon: nil,
                actionButtonTitle: "Den er god! God jul!"
            )
        )
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct ChristmasWishListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DemoWrapperView(view: ChristmasWishListDemoView())

            DemoWrapperView(view: ChristmasWishListDemoView())
                .environment(\.colorScheme, ColorScheme.dark)
                .previewDisplayName("Dark")

            DemoWrapperView(view: ChristmasWishListDemoView())
                .previewDevice(PreviewDevice.init(stringLiteral: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
    }
}
#endif
