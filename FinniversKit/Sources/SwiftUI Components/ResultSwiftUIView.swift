import SwiftUI

public struct ResultSwiftUIView: View {
    public let image: Image?
    public let imageSize: CGFloat
    public let imageForegroundColor: Color?
    public let title: String
    public let text: String?
    public let buttonTitle: String?
    public let buttonAction: (() -> Void)?

    public init(
        image: Image? = nil,
        imageSize: CGFloat = 40,
        imageForegroundColor: Color? = nil,
        title: String,
        text: String? = nil,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.image = image
        self.imageSize = imageSize
        self.imageForegroundColor = imageForegroundColor
        self.title = title
        self.text = text
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    public var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)
                    .foregroundColor(imageForegroundColor)
                    .padding(.bottom, .spacingS)
            }
            Text(title)
                .finnFont(.title3Strong)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.bottom, .spacingXS)
            if let text {
                Text(text)
                    .finnFont(.body)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .spacingS)
            }
            if let buttonTitle, let buttonAction {
                SwiftUI.Button(buttonTitle, action: buttonAction)
                    .buttonStyle(CallToAction(size: .small, fullWidth: false))
            }
        }
        .padding(.horizontal, .spacingXL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
    }
}

struct ResultSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultSwiftUIView(
                image: Image(ImageAsset.ratingFaceDissatisfied),
                imageSize: 50,
                imageForegroundColor: .red,
                title: "Usjda",
                text: "Noe gikk galt",
                buttonTitle: "Prøv igjen",
                buttonAction: {}
            ).previewDisplayName("Error retry")

            ResultSwiftUIView(
                image: Image(ImageAsset.magnifyingGlass),
                title: "Klarte ikke finne annonsen",
                text: "Det kan se ut som annonsen du kikker etter har blitt slettet"
            ).previewDisplayName("Not found")
        }
    }
}
