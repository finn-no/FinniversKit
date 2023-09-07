import FinniversKit

extension FrontPageTransactionViewModel {
    static var tjtRegular: Self {
        .init(
            id: "tjt",
            headerTitle: "Fiks ferdig",
            title: "Gjør klar til sending",
            subtitle: "Velg en kjøper",
            imageUrl: "https://images.finncdn.no/dynamic/960w/2021/4/vertical-0/11/5/214/625/615_1292134726.jpg",
            adId: 1234,
            transactionId: "123-456-789"
        )
    }

    static var tjtLong: Self {
        .init(
            id: "tjt",
            headerTitle: "Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig",
            title: "Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending.",
            subtitle: "Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper.",
            imageUrl: "https://images.finncdn.no/dynamic/960w/2021/4/vertical-0/11/5/214/625/615_1292134726.jpg",
            adId: 1234,
            transactionId: "123-456-789"
        )
    }

    static var tjmRegular: Self {
        .init(
            id: "tjm",
            headerTitle: "Smidig handel",
            title: "Kjøperen har blitt med i kontrakten",
            subtitle: "Vi anbefaler at dere blir enige om de siste detaljene i kontrakten sammen under prøvekjøring",
            imageUrl: nil,
            adId: 2345,
            transactionId: "234-567-890"
        )
    }
}
