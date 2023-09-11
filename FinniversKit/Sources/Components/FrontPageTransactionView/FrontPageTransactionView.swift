import SwiftUI

public struct FrontPageTransactionView: View {
    @ObservedObject
    public var model: FrontPageTransactionViewModel

    private let cornerRadius: CGFloat = 8
    private let imageWidth: CGFloat = 56

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

                    Group {
                        if let image = model.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle()
                                .fill(Color.bgColor)
                        }
                    }
                    .cornerRadius(cornerRadius)
                    .frame(width: imageWidth, height: imageWidth)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .roundedBorder(radius: cornerRadius, width: 1, color: .black.opacity(0.1))
                    .animation(.easeOut(duration: 0.2), value: model.image)
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
        .onAppear {
            Task { @MainActor in
                await model.loadImage()
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
