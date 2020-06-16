//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
@testable import FinnUI

// swiftlint:disable superfluous_disable_command type_name
@available(iOS 13.0.0, *)
struct NewBapAdView_Previews: PreviewProvider {
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
