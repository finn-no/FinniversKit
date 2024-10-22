import SwiftUI
import Warp

struct UpsaleVisibilitySectionView: View {
    static let upsaleVisibilitySectionViewCellIdentifier = "upsaleVisibilitySectionViewCellIdentifier"
    private let hairLineSize = 1.0 / UIScreen.main.scale

    let title: String
    let buttonTitle: String
    let upsaleChoicesViewTitle: String
    let upsaleChoicesViewButtonTitle: String
    let selectedProductModels: [SelectedProductsModel]
    var onBuyAnotherProductButtonTapped: (() -> Void)?

    var extraVisibilityProductModels: [UpsaleVisibilityChoiceModel]?
    var onBuyExtraButtonTapped: ((String?) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            Divider()
                .foregroundColor(.border)
                .padding([.leading, .trailing], Warp.Spacing.spacing200)

            if !selectedProductModels.isEmpty {
                Text(title)
                    .font(.finnFont(.bodyStrong))
                    .padding(.leading)
            }

            ForEach(selectedProductModels, id: \.self) {
                UpsaleVisibilityView(selectedProductsModel: $0)
            }

            if let extraVisibilityProductModels, !extraVisibilityProductModels.isEmpty {
                UpsaleVisibilityChoicesView(
                    title: upsaleChoicesViewTitle,
                    buttonTitle: upsaleChoicesViewButtonTitle,
                    productModels: extraVisibilityProductModels,
                    onBuyButtonTapped: onBuyExtraButtonTapped
                )
            } else {
                HStack {
                    Warp.Button.create(
                        for: .secondary,
                        title: buttonTitle,
                        action: {
                            onBuyAnotherProductButtonTapped?()
                        }
                    )
                    .padding([.leading, .bottom])

                    Spacer()
                }
            }
        }
    }
}

private struct UpsaleVisibilityView: View {
    let selectedProductsModel: SelectedProductsModel

    var body: some View {
        VStack(alignment: .leading) {
            if let innerProducts = selectedProductsModel.innerProducts {
                if let name = selectedProductsModel.name {
                    Text(name)
                        .font(.finnFont(.caption))

                    ForEach(innerProducts, id: \.self) {
                        SelectedProductView(product: $0)
                    }
                }
            } else {
                SelectedProductView(product: selectedProductsModel.product)
            }
        }
        .padding(.leading)
    }
}

private struct SelectedProductView: View {
    let product: UpsaleVisibilityModel?

    var body: some View {
        HStack(spacing: Warp.Spacing.spacing200) {
            UpsaleProgressView(
                icon: product?.icon,
                progress: product?.durationRemaining
            )

            VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                if let title = product?.title {
                    Text(title)
                        .font(.finnFont(.captionStrong))
                }

                if let description = product?.description {
                    Text(description)
                        .font(.finnFont(.body))
                }

            }
        }
    }
}

#Preview {
    UpsaleVisibilitySectionView(
        title: "Extra visibility bought",
        buttonTitle: "Buy another visibility product",
        upsaleChoicesViewTitle: "Upsale view title",
        upsaleChoicesViewButtonTitle: "Upsale view button title",
        selectedProductModels:
            [SelectedProductsModel(
                name: "Name",
                innerProducts: nil,
                product: UpsaleVisibilityModel(
                    title: "Bump",
                    description: "Lifted to top of search on 12th May",
                    durationRemaining: 100,
                    icon: nil
                )
            )],
        onBuyAnotherProductButtonTapped: nil,
        extraVisibilityProductModels: nil,
        onBuyExtraButtonTapped: nil
    )
}

#Preview {
    UpsaleVisibilitySectionView(
        title: "Extra visibility bought",
        buttonTitle: "Buy another visibility product",
        upsaleChoicesViewTitle: "Get extra visibility",
        upsaleChoicesViewButtonTitle: "+ Buy",
        selectedProductModels: [SelectedProductsModel(
            name: "Name",
            innerProducts: nil,
            product: UpsaleVisibilityModel(
                title: "Bump",
                description: "Lifted to top of search on 12th May",
                durationRemaining: 100,
                icon: nil
            )
        )],
        onBuyAnotherProductButtonTapped: nil,
        extraVisibilityProductModels: [UpsaleVisibilityChoiceModel(
            title: "Anbefalte annonser",
            price: "119 kr",
            description: "Økt synlighet blant lignende annonser - 7 dager",
            icon: nil
        )],
        onBuyExtraButtonTapped: nil
    )
}
