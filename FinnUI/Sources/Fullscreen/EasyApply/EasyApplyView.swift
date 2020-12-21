//
//  EasyApplyView.swift
//  FinnUI
//
//  Created by Håkon Ødegård Løvdal on 21/12/2020.
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct EasyApplyView: View {
    var body: some View {
        VStack(alignment: .leading) {

            VStack(alignment: .leading) {
                Text("Søk stilling som:").finnFont(.detail)
                Text("Systemutvikler / softwareutvikler i Krabbe AS").finnFont(.bodyStrong)
            }
            .padding(.bottom, .spacingS)

            VStack(alignment: .leading) {
                Text("Du er logget inn som:").finnFont(.caption)
                Text("Test Testesen").finnFont(.bodyRegular)
            }

            VStack(alignment: .leading) {

            }

        }
    }
}

@available(iOS 14.0, *)
struct EasyApplyView_Previews: PreviewProvider {
    static var previews: some View {
        EasyApplyView()
            .colorScheme(.light)
            .previewLayout(.device)
    }
}
