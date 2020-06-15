//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct ImageGalleryView<ImageProvider: CollectionImageProvider>: View {
    @ObservedObject var imageProvider: ImageProvider
    @State var selectedImageIndex: Int = 0

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.bgSecondary)
            images
            indicatorView
        }
        .frame(height: 250)
        .onAppear(perform: imageProvider.fetchImages)
    }
}

@available(iOS 13.0, *)
extension ImageGalleryView {
    var totalImages: Int {
        imageProvider.imageCount
    }

    var selectedImage: String {
        "\(selectedImageIndex + 1)"
    }

    var images: some View {
        PagerView(pageCount: imageProvider.imageCount, currentIndex: $selectedImageIndex) {
            ForEach(imageProvider.images, id: \.self) { (image) in
                SwiftUI.Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 375, height: 250)
            }
        }
    }

    var indicatorView: some View {
        VStack {
            Spacer()
            Text("\(selectedImage) / \(totalImages)")
                .finnFont(.caption)
                .foregroundColor(.textTertiary)
                .padding(.spacingS)
                .background(Color.gray)
                .cornerRadius(.spacingS)
                .padding()
        }
    }
}
