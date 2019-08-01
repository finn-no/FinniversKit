//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

struct AdsSection {
    let sectionTitle: String?
    let ads: [FavoriteAd]
}

class FavoriteAdsDemoDataSource {
    private(set) var sections = [AdsSection]()
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()

    func sort(ads: [FavoriteAd], by sort: AdsSorting) {
        switch sort {
        case .alphabetically:
            sections = sortAlphabetically(ads)
        case .lastAdded:
            sections = groupByMonth(ads)
        }
    }

    private func sortAlphabetically(_ ads: [FavoriteAd]) -> [AdsSection] {
        let sorted = ads.sorted(by: { $0.titleText < $1.titleText })
        return [AdsSection(sectionTitle: nil, ads: sorted)]
    }

    private func groupByMonth(_ ads: [FavoriteAd]) -> [AdsSection] {
        let grouped = ads.reduce(into: [Date: [FavoriteAd]]()) { accumulated, ad in
            let components = Calendar.current.dateComponents([.year, .month], from: ad.addedToFolderDate)
            guard let date = Calendar.current.date(from: components) else { return }

            let existing = accumulated[date] ?? []
            accumulated[date] = existing + [ad]
        }

        let sortedMonths = grouped.keys.sorted(by: { $0 > $1 })
        return sortedMonths.map { month in
            let title = sectionTitle(for: month)
            let ads = grouped[month] ?? []
            return AdsSection(sectionTitle: title, ads: ads)
        }
    }

    private func sectionTitle(for date: Date) -> String {
        let currentYear = 2019
        let year = Calendar.current.component(.year, from: date)

        if year == currentYear {
            dateFormatter.dateFormat = "MMMM"
        } else {
            dateFormatter.dateFormat = "MMMM YYYY"
        }

        return dateFormatter.string(from: date)
    }
}
