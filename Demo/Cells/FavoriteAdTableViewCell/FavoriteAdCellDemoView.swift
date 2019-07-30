//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct ViewModel: FavoriteAdTableViewCellViewModel {
    let addressText: String?
    let titleText: String?
    let descriptionPrimaryText: String?
    let descriptionSecondaryText: String?
    let imagePath: String?
    let ribbonStyle: RibbonView.Style
    let ribbonTitle: String
}

class FavoriteAdCellDemoView: UIView {
    private let viewModels = ViewModelFactory.create()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteAdTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate

extension FavoriteAdCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (viewModels.count - 1)

        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }

        if let cell = cell as? FavoriteAdTableViewCell {
            cell.loadImage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteAdCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count * 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteAdTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row % viewModels.count])
        cell.remoteImageViewDataSource = self

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        cell.loadingColor = colors[indexPath.row % colors.count]

        return cell
    }
}

// MARK: - RemoteImageTableViewCellDataSource

extension FavoriteAdCellDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - Private types

private struct ViewModelFactory {
    static func create() -> [ViewModel] {
        return [
            ViewModel(
                addressText: "Slottet",
                titleText: "Påhengsmotor",
                descriptionPrimaryText: "15 001,-",
                descriptionSecondaryText: "Båtmotor til salgs・Utenbords・60 hk",
                imagePath: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
                ribbonStyle: .success,
                ribbonTitle: "Aktiv"
            ),
            ViewModel(
                addressText: "Innkjøpsansvarlig, Acme Inc.",
                titleText: "Kategoriansvarlig teknisk innkjøp",
                descriptionPrimaryText: "Kategoriansvarlig teknisk innkjøp",
                descriptionSecondaryText: "Fulltidsstilling・Acme Inc.・Søknadsfrist 2020-02-31・Fast",
                imagePath: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
                ribbonStyle: .error,
                ribbonTitle: "Slettet"
            ),
            ViewModel(
                addressText: "Asker",
                titleText: "Godt brukt Sofa - pris kan diskuteres mot rask henting.",
                descriptionPrimaryText: "2 000,-",
                descriptionSecondaryText: "Torget",
                imagePath: "http://jonvilma.com/images/house-6.jpg",
                ribbonStyle: .warning,
                ribbonTitle: "Solgt"
            ),
            ViewModel(
                addressText: "Røros",
                titleText: "Worcestershire bøll terrier valper. Leveringsklare fra 21. August 2019",
                descriptionPrimaryText: "17 000,-",
                descriptionSecondaryText: "Torget",
                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                ribbonStyle: .disabled,
                ribbonTitle: "Frist utløpt"
            ),
            ViewModel(
                addressText: "Fredrikstad",
                titleText: "Nesten ny bil / Panorama - Se utstyr! Innbytte mulig 2014, 69 700 km, kr 999 500,-",
                descriptionPrimaryText: "2014 • 69 700 km • 999 500,-",
                descriptionSecondaryText: "Bruktbil・Bil・Bensin",
                imagePath: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
                ribbonStyle: .success,
                ribbonTitle: "Aktiv"
            ),
            ViewModel(
                addressText: "Sentrum, Navn Navnesens vei 42A, 0001 Oslo",
                titleText: "BUD INNKOMMET! Lekker tomannsbolig med 70 soverom. Nydelige uteplasser! Garasje med innredet hems.",
                descriptionPrimaryText: "128m² • 2 565 000,-",
                descriptionSecondaryText: "Bolig til salgs・Eier (Selveier)・Tomannsbolig",
                imagePath: "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg",
                ribbonStyle: .disabled,
                ribbonTitle: "Deaktivert"
            ),
            ViewModel(
                addressText: "Østkanten, Helsfyrsveien 10A, 1010 Oslo",
                titleText: "Nordvendt og lekkert rekkehus med mulighet for 2 soverom nær flotte t-baner og skoler.",
                descriptionPrimaryText: "123m² • 2 750 000,-",
                descriptionSecondaryText: "Bolig til salgs・1 989,- pr mnd・Eier (Selveier)・Andre・1 soverom",
                imagePath: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
                ribbonStyle: .warning,
                ribbonTitle: "Solgt"
            )
        ]
    }
}