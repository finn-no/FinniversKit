import SwiftUI
import Warp

struct UpsaleVisibilityChoicesView: View {
    let title: String
    let buttonTitle: String
    var productModels: [UpsaleVisibilityChoiceModel]
    var onBuyButtonTapped: ((String?) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            Text(title)
                .font(.finnFont(.bodyStrong))

            ForEach(productModels, id: \.self) {
                ExtraVisibilityProductView(
                    buttonTitle: buttonTitle,
                    product: $0,
                    onBuyButtonTapped: onBuyButtonTapped
                )
            }
        }
        .padding([.leading, .bottom])
        .background(Color.background)
    }
}

struct ExtraVisibilityProductView: View {
    let buttonTitle: String
    let product: UpsaleVisibilityChoiceModel?
    var onBuyButtonTapped: ((String?) -> Void)?

    var body: some View {
        HStack(spacing: Warp.Spacing.spacing200) {
            if let icon = product?.icon {
                Image(uiImage: UIImage(named: icon))
                    .resizable()
                    .frame(width: 24, height: 24)
            }

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

            Spacer()

            Warp.Button.create(
                for: .secondary,
                title: buttonTitle,
                action: {
                    onBuyButtonTapped?(product?.specificationUrn)
                }
            )
            .padding(.trailing)
            .background(Color.background)
        }
    }
}

#Preview {
    UpsaleVisibilityChoicesView(
        title: "adIn.userAdManagement.upsale.extra.title",
        buttonTitle: "adIn.userAdManagement.upsale.extra.button.title",
        productModels: [UpsaleVisibilityChoiceModel(
//            category: .bump,
            title: "Anbefalte annonser",
            price: "119 kr",
            description: "Økt synlighet blant lignende annonser - 7 dager",
            icon: .productTop
        )])
}
