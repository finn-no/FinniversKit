//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit
import UIKit
import Combine

@available(iOS 13.0.0, *)
public struct BapAdView<GalleryImageProvider: CollectionImageProvider, AuthorImageProvider: SingleImageProvider>: View {
    let viewModel: BapAdViewModel
    let actions: BapAdViewActions?
    let galleryImageProvider: GalleryImageProvider?
    let authorAvatarImageProvider: AuthorImageProvider?

    public init(
        viewModel: BapAdViewModel,
        actions: BapAdViewActions? = nil,
        galleryImageProvider: GalleryImageProvider? = nil,
        authorAvatarImageProvider: AuthorImageProvider? = nil
    ) {
        self.viewModel = viewModel
        self.actions = actions
        self.galleryImageProvider = galleryImageProvider
        self.authorAvatarImageProvider = authorAvatarImageProvider
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: .spacingS) {
                imageGallery

                Group {
                    title
                    price
                    favoriteButton
                    sendMessageButton
                    phoneNumber
                    author
                    location
                    description
                    extras

                    Group {
                        heltHjemPromotion
                        extraLinks
                        metadata
                    }
                }
                .padding(.horizontal, .spacingS)
                .frame(maxWidth: 400, alignment: .leading)
            }
        }
        .foregroundColor(.textPrimary)
        .background(Color.bgPrimary)
        .navigationBarTitle("", displayMode: .inline)
    }
}

// MARK: - Subviews
@available(iOS 13.0.0, *)
extension BapAdView {
    private var imageGallery: some View {
        galleryImageProvider.map {
            ImageGalleryView(imageProvider: $0)
                    .onTapGesture(perform: presentFullScreenGallery)
        }
    }

    private var title: some View {
        Text(viewModel.title)
            .finnFont(.title2)
            .padding(.spacingS)
    }

    private var price: some View {
        viewModel.price.map {
            Text($0)
                .finnFont(.title1)
                .padding(.horizontal, .spacingS)
        }
    }

    private var favoriteButton: some View {
        Button(action: addToFavorites) {
            HStack {
                Image(.favoriteActive)
                    .resizable()
                    .frame(width: .spacingM, height: .spacingM)
                Text(viewModel.addToFavoritesButtonTitle)
                    .finnFont(.bodyStrong)
                    .foregroundColor(.textAction)
            }
        }
        .buttonStyle(DefaultStyle())
    }

    private var sendMessageButton: some View {
        Button(viewModel.sendMessageButtonTitle, action: sendMessage)
            .buttonStyle(CallToAction())
    }

    private var phoneNumber: some View {
        viewModel.phoneNumber.map {
            PhoneNumberView(viewModel: $0, contact: self.presentContactOptions)
        }
    }

    private var author: some View {
        authorAvatarImageProvider.map { avatarProvider in
            Button(action: self.navigateToAuthorProfile) {
                AuthorView(author: self.viewModel.author, imageProvider: avatarProvider)
            }
        }
    }

    private var location: some View {
        Button(action: showMap) {
            HStack(spacing: .spacingXS) {
                Image(.pin)
                    .resizable()
                    .frame(width: .spacingM, height: .spacingM)
                    .foregroundColor(.btnPrimary)
                Text(viewModel.locationText)
                    .finnFont(.body)
                    .foregroundColor(Color.btnAction)
            }
        }
        .padding(.spacingS)
    }

    private var description: some View {
        viewModel.description.map {
            DescriptionView(viewModel: $0)
                .padding(.bottom, .spacingM)
        }
    }

    private var extras: some View {
        VStack {
            ForEach(viewModel.extras, id: \.id) { extra in
                HStack {
                    Text(extra.label).finnFont(.bodyStrong)
                    Text(extra.value).finnFont(.body)
                }.foregroundColor(.textPrimary)
            }
        }.padding(.spacingS)
    }

    private var heltHjemPromotion: some View {
        viewModel.tryHeltHjem.map {
            TryHeltHjemView(
                viewModel: $0,
                onReadMore: readMoreAboutHeltHjem,
                onAlternatives: shipmentAlternatives
            )
        }
    }

    private var extraLinks: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Button(viewModel.loanPriceTitle, action: loanPrice)
            Button(viewModel.reportAdTitle, action: reportAd)
        }
        .buttonStyle(InlineFlatStyle())
        .padding(.spacingS)
    }

    private var metadata: some View {
        VStack(alignment: .leading, spacing: .spacingXS) {
            HStack {
                Text(viewModel.finnCode).finnFont(.bodyStrong)
                Text(viewModel.id).finnFont(.body)
            }

            HStack {
                Text(viewModel.lastModifiedTitle).finnFont(.bodyStrong)
                Text(viewModel.lastModified).finnFont(.body)
            }
        }
        .foregroundColor(.textPrimary)
        .padding(.spacingS)
    }
}

// MARK: - Actions
@available(iOS 13.0.0, *)
extension BapAdView {
    func addToFavorites() {
        actions?.addToFavorites()
    }

    func sendMessage() {
        actions?.sendMessage()
    }

    func showMap() {
        actions?.showMap()
    }

    func navigateToAuthorProfile() {
        actions?.navigateToAuthorProfile()
    }

    func presentContactOptions() {
        actions?.presentContactOptions()
    }

    func presentFullScreenGallery() {
        actions?.presentFullScreenGallery()
    }

    func readMoreAboutHeltHjem() {
        actions?.readMoreAboutHeltHjem()
    }

    func shipmentAlternatives() {
        actions?.shipmentAlternatives()
    }

    func loanPrice() {
        actions?.loanPrice()
    }

    func reportAd() {
        actions?.reportAd()
    }
}

@available(iOS 13.0.0, *)
struct BapAdView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BapAdView(
                viewModel: .sampleData,
                galleryImageProvider: SampleCollectionImageDownloader(
                    urls: BapAdViewModel.sampleData.imageUrls
                ),
                authorAvatarImageProvider: SampleSingleImageProvider(
                    url: URL(string: AuthorViewModel.sampleData.profilePicture)
                )
            )
        }
        .colorScheme(.light)
        .previewLayout(.fixed(width: 375, height: 1800))
    }
}
