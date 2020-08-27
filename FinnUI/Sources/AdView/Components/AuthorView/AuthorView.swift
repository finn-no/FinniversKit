//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct AuthorView<ImageProvider: SingleImageProvider>: View {
    let author: AuthorViewModel
    @ObservedObject var imageProvider: ImageProvider
    private let imageSize: CGFloat = 40

    var body: some View {
        HStack(alignment: .center) {
            profilePicture

            VStack(alignment: .leading) {
                HStack(spacing: .spacingXXS) {
                    authorName
                    verifiedIcon
                    Spacer()
                }.foregroundColor(.textAction)

                description
            }
            Spacer()
        }
        .padding()
        .background(Color.bgSecondary)
        .cornerRadius(.spacingS)
        .onAppear(perform: imageProvider.fetchImage)
    }
}

@available(iOS 13.0, *)
extension AuthorView {
    var profilePicture: some View {
        Image(uiImage: imageProvider.image)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .background(Color.bgSecondary)
            .foregroundColor(.btnPrimary)
            .clipShape(Circle())
    }

    var authorName: some View {
        Text(author.name)
            .finnFont(.body)
    }

    var verifiedIcon: Image? {
        author.verified ? Image(.verified) : nil
    }

    var description: some View {
        Text(author.description)
            .finnFont(.detail)
    }
}

@available(iOS 13.0, *)
//swiftlint:disable:next type_name superfluous_disable_command
struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthorView(
                author: .sampleData,
                imageProvider: SampleSingleImageProvider(
                    url: URL(string: AuthorViewModel.sampleData.profilePicture)
                )
            )
        }.previewLayout(.sizeThatFits)
    }
}
