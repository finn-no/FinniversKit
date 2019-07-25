//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import MapKit

public class SearchResultMapViewDemoViewController: UIViewController {

    private var didSetupView = false

    private lazy var demoTile: MKTileOverlay = {
        let tile = MKTileOverlay(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png")
        tile.canReplaceMapContent = true
        return tile

    }()

    private let defaultRegion = MKCoordinateRegion.init(
        center: CLLocationCoordinate2D.init(latitude: 66.149068058495473, longitude: 17.653576306638673),
        span: MKCoordinateSpan.init(latitudeDelta: 19.853012316209828, longitudeDelta: 28.124998591005721)
    )

    private lazy var searchResultMapView: SearchResultMapView = {
        let view = SearchResultMapView(withAutoLayout: true)
        view.configure(withDefaultRegion: defaultRegion, andOverlay: demoTile)
        view.delegate = self
        return view
    }()

    // MARK: - Setup

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .milk
        view.addSubview(searchResultMapView)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                searchResultMapView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: searchResultMapView.bottomAnchor, multiplier: 1.0),
                searchResultMapView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                searchResultMapView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
                ])
        }
    }
    
    // MARK: - Private

    private func addMapOverlay() {
        searchResultMapView.setMapOverlay(overlay: demoTile)
    }

    private func clearMapOverlay() {
        searchResultMapView.clearMapOverlay(overlay: demoTile)
    }

}

// MARK: - SearchResultMapViewDelegate

extension SearchResultMapViewDemoViewController: SearchResultMapViewDelegate {

    public func searchResultMapViewDidSelectChangeMapTypeButton(_ view: SearchResultMapView) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancel = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
        let demoOverlayAction = UIAlertAction(title: "Kart fra OSM", style: .default) { _ in
            self.addMapOverlay()
        }
        let defaultMapAction = UIAlertAction(title: "Standard kart", style: .default) { _ in
            self.clearMapOverlay()
        }

        alert.addAction(cancel)
        alert.addAction(demoOverlayAction)
        alert.addAction(defaultMapAction)

        present(alert, animated: true, completion: nil)
    }
}
