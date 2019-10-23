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
                actionButtonIcon: UIImage(named: FinniversImageAsset.gift),
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

struct ChristmasWishListDemoWrapperView: UIViewRepresentable {
    func updateUIView(_ uiView: ChristmasWishListDemoView, context: Context) {
    }

    func makeUIView(context: Context) -> ChristmasWishListDemoView {
        return ChristmasWishListDemoView()
    }
}

@available(iOS 13.0, *)
struct ChristmasWishListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChristmasWishListDemoWrapperView()

            ChristmasWishListDemoWrapperView()
                .environment(\.colorScheme, ColorScheme.dark)
                .previewDisplayName("Dark")

            ChristmasWishListDemoWrapperView()
                .previewDevice(PreviewDevice.init(stringLiteral: "iPhone SE"))
                .previewDisplayName("iPhone SE")

            ChristmasWishListDemoWrapperView()
                .previewDevice(PreviewDevice.init(stringLiteral: "iPhone 8"))
                .previewDisplayName("iPhone 8")

            ChristmasWishListDemoWrapperView()
                .previewDevice(PreviewDevice.init(stringLiteral: "iPad Pro (11-inch)"))
                .previewDisplayName("iPad Pro")

            ChristmasWishListDemoWrapperView()
                .previewDevice(PreviewDevice.init(stringLiteral: "iPad Pro (11-inch)"))
                .environment(\.colorScheme, ColorScheme.dark)
                .previewDisplayName("iPad Pro Dark")
        }
    }
}
#endif
