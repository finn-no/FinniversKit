import SwiftUI

public struct FrontPageTransactionView: View {
    public let model: FrontPageTransactionViewModel

    private let cornerRadius: CGFloat = 8

    public init(model: FrontPageTransactionViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .spacingS) {
            Text(model.headerTitle)
                .finnFont(.bodyStrong)
                .foregroundColor(.textPrimary)
                .accessibilityAddTraits(.isHeader)

            VStack {
                HStack(alignment: .top, spacing: .spacingS) {
                    VStack(alignment: .leading, spacing: .spacingXS) {
                        Text(model.title)
                            .finnFont(.bodyStrong)
                            .foregroundColor(.textPrimary)

                        Text(model.subtitle)
                            .finnFont(.body)
                            .foregroundColor(.textPrimary)
                    }

                    Spacer()

                    // TODO: Async image
                    Image(uiImage: UIImage(named: .noImage))
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(cornerRadius)
                        .frame(width: model.imageWidth, height: model.imageWidth)
                        .roundedBorder(radius: cornerRadius, width: 1, color: .black.opacity(0.1))
                        .clipped()
                }
                .padding(.spacingM)
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.bgColor)
                    .shadow(color: .shadowColor.opacity(0.24), radius: 1, x: 0, y: 1)
                    .shadow(color: .shadowColor.opacity(0.16), radius: 5, x: 0, y: 1)
            )
            .onTapGesture {
                model.transactionTapped()
            }
        }
    }
}

// MARK: - Private extensions

private extension Color {
    static var shadowColor: Color {
        Color(UIColor(hex: "475569"))
    }

    static var bgColor: Color {
        Color(UIColor.dynamicColor(defaultColor: .white, darkModeColor: .darkBgPrimaryProminent))
    }
}

struct FrontPageTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        FrontPageTransactionView(
            model: .init(
                id: .init(rawValue: "tjm"),
                headerTitle: "Smidig handel",
                title: "Kjøperen har blitt med i kontrakten",
                subtitle: "Vi anbefaler at dere blir enige om de siste detaljene i kontrakten sammen under prøvekjøring",
                imageUrl: nil,
                destinationUrl: nil,
                adId: 1234,
                transactionId: nil
            )
        )
        .padding(.spacingM)
    }
}
