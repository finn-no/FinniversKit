//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import FinnUI

final class ProjectUnitsDemoView: UIView {
    private lazy var view: ProjectUnitsView = {
        let view = ProjectUnitsView(title: "Utvalgte boliger i prosjektet")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.remoteImageViewDataSource = self
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private let viewModels: [ProjectUnitViewModel] = [
        ProjectUnitViewModel(imageUrl: imageUrls[0], topDetailText: "201", title: "Romslig leilighet med 2 soverom", price: "2 400 000 kr", area: "59 kvm", bottomDetailText: "2 soverom ● 2. etasje"),
        ProjectUnitViewModel(imageUrl: imageUrls[1], topDetailText: "500", title: "4-roms med stor balkong", price: "5 800 000 kr", area: "110 kvm", bottomDetailText: "3 soverom ● 5. etasje"),
        ProjectUnitViewModel(imageUrl: imageUrls[2], topDetailText: "501", title: "Gjennomgående 2-roms med sørvendt tersasse", price: "2 450 000 kr", area: "54 kvm", bottomDetailText: "1 soverom ● 5. etasje"),
        ProjectUnitViewModel(imageUrl: imageUrls[3], topDetailText: "703", title: "Leilighet i toppetasje med fantastisk utsikt", price: "6 150 000 kr", area: "70 kvm", bottomDetailText: "2 soverom ● 7. etasje")
    ]

    private static let imageUrls: [String] = [
        "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
        "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg"
    ]

    private var favoriteIndices: Set = [1]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 360)
        ])
        view.reloadData()
    }
}

extension ProjectUnitsDemoView: ProjectUnitsViewDataSource {
    func numberOfItems(inProjectUnitsView view: ProjectUnitsView) -> Int {
        viewModels.count
    }

    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, modelAtIndex index: Int) -> ProjectUnitViewModel? {
        viewModels[index]
    }

    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, unitAtIndexIsFavorite index: Int) -> Bool {
        favoriteIndices.contains(index)
    }
}

extension ProjectUnitsDemoView: ProjectUnitsViewDelegate {
    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, didTapFavoriteButton button: UIButton, forIndex index: Int) {
        if favoriteIndices.contains(index) {
            favoriteIndices.remove(index)
        } else {
            favoriteIndices.insert(index)
        }
        view.updateFavoriteButtonStates()
    }

    func projectUnitsView(_ projectUnitsView: ProjectUnitsView, didSelectUnitAtIndex index: Int) {
        print("Did select unit at index \(index)")
    }
}

extension ProjectUnitsDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

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

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {

    }
}
