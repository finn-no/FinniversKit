//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

struct FavoriteAdsSection {
    let sectionTitle: String?
    let ads: [FavoriteAdViewModel]
}

class FavoriteAdsDemoDataSource {
    private(set) var sections = [FavoriteAdsSection]()
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()

    func configureSection(forAds ads: [FavoriteAdViewModel], withSort sort: AdsSorting, filterQuery: String) {
        let filteredAds = filterQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                          ? ads
                          : ads.filter { $0.titleText.lowercased().contains(filterQuery.lowercased()) }
        switch sort {
        case .alphabetically:
            sections = sortAlphabetically(filteredAds)
        case .lastAdded:
            sections = groupByMonth(filteredAds)
        }
    }

    private func sortAlphabetically(_ ads: [FavoriteAdViewModel]) -> [FavoriteAdsSection] {
        let sorted = ads.sorted(by: { $0.titleText < $1.titleText })
        return [FavoriteAdsSection(sectionTitle: nil, ads: sorted)]
    }

    private func groupByMonth(_ ads: [FavoriteAdViewModel]) -> [FavoriteAdsSection] {
        let grouped = ads.reduce(into: [Date: [FavoriteAdViewModel]]()) { accumulated, ad in
            let components = Calendar.current.dateComponents([.year, .month], from: ad.addedToFolderDate)
            guard let date = Calendar.current.date(from: components) else { return }

            let existing = accumulated[date] ?? []
            accumulated[date] = existing + [ad]
        }

        let sortedMonths = grouped.keys.sorted(by: { $0 > $1 })
        return sortedMonths.map { month in
            let title = sectionTitle(for: month)
            let ads = grouped[month] ?? []
            return FavoriteAdsSection(sectionTitle: title, ads: ads)
        }
    }

    private func sectionTitle(for date: Date) -> String {
        let currentYear = 2019
        let year = Calendar.current.component(.year, from: date)

        if year == currentYear {
            FavoriteAdsDemoDataSource.dateFormatter.dateFormat = "MMMM"
        } else {
            FavoriteAdsDemoDataSource.dateFormatter.dateFormat = "MMMM YYYY"
        }

        return FavoriteAdsDemoDataSource.dateFormatter.string(from: date)
    }
}
