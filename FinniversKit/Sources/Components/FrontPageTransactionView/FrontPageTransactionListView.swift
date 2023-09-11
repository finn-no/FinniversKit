import SwiftUI

public struct FrontPageTransactionListView: View {
    public let models: [FrontPageTransactionViewModel]

    public init(models: [FrontPageTransactionViewModel]) {
        self.models = models
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .spacingL) {
            ForEach(models) { model in
                FrontPageTransactionView(model: model)
            }
        }
    }
}

struct FrontPageTransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        FrontPageTransactionListView(
            models: [
                .init(
                    id: .init(rawValue: "tjm"),
                    headerTitle: "Smidig handel",
                    title: "Kjøperen har blitt med i kontrakten",
                    subtitle: "Vi anbefaler at dere blir enige om de siste detaljene i kontrakten sammen under prøvekjøring",
                    imageUrl: nil,
                    destinationUrl: nil,
                    adId: 1234,
                    transactionId: nil
                ),
                .init(
                    id: .init(rawValue: "tjm"),
                    headerTitle: "Smidig handel",
                    title: "Kjøperen har blitt med i kontrakten Kjøperen har blitt med i kontrakten Kjøperen har blitt med i kontrakten",
                    subtitle: "Vi anbefaler at dere blir enige om de siste detaljene i kontrakten sammen under prøvekjøring Vi anbefaler at dere blir enige om de siste detaljene i kontrakten sammen under prøvekjøring Vi anbefaler at dere blir enige om de siste detaljene i kontrakten sammen under prøvekjøring",
                    imageUrl: nil,
                    destinationUrl: nil,
                    adId: 1234,
                    transactionId: nil
                )
            ]
        )
        .padding(.spacingM)
    }
}
