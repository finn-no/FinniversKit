//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import MapKit

class SearchResultMapViewDemoViewController: BaseDemoViewController<UIView> {

    private lazy var searchResultMapView: SearchResultMapView = {
        let view = SearchResultMapView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Setup

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override public func viewDidLayoutSubviews() {
        // Place a nice looking view instead of the mapView to prevent the UI tests from failing.
        for subview in searchResultMapView.subviews {
            guard let mapView = subview as? MKMapView else { continue }
            let colorfulView = UIView(withAutoLayout: true)
            colorfulView.backgroundColor = .mint
            mapView.superview?.addSubview(colorfulView)
            let constraints: [NSLayoutConstraint] = [
                colorfulView.topAnchor.constraint(equalTo: mapView.topAnchor),
                colorfulView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
                colorfulView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
                colorfulView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            ]
            NSLayoutConstraint.activate(constraints)
            mapView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak colorfulView] in
                colorfulView?.removeFromSuperview()
                mapView.isHidden = false
            })
        }
    }

    private func setup() {
        view.backgroundColor = .bgPrimary
        view.addSubview(searchResultMapView)

        let region = MKCoordinateRegion(center: SearchResultMapViewAnnotationFactory.centerLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)

        searchResultMapView.configure(withInitialRegion: region, andShowingUserLocation: true)
        searchResultMapView.setMapOverlay(SearchResultMapViewAnnotationFactory.tileOverlay)

        SearchResultMapViewAnnotationFactory.create(numberOfAnnotations: 10).forEach { searchResultMapView.addAnnotation($0) }

        NSLayoutConstraint.activate([
            searchResultMapView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            searchResultMapView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0),
            searchResultMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Private

    private func addMapOverlay() {
        searchResultMapView.setMapOverlay(SearchResultMapViewAnnotationFactory.tileOverlay)
    }

    private func clearMapOverlay() {
        searchResultMapView.clearMapOverlay(SearchResultMapViewAnnotationFactory.tileOverlay)
    }

}

// MARK: - SearchResultMapViewDelegate

extension SearchResultMapViewDemoViewController: SearchResultMapViewDelegate {

    public func searchResultMapView(_ view: SearchResultMapView, didSelect action: MapSettingsView.Action, in mapSettingsView: MapSettingsView) {
        switch action {
        case .centerMap:
            view.setCenter(SearchResultMapViewAnnotationFactory.centerLocation, regionDistance: 1000, animated: true)
        case .changeMapType:
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Kart fra OSM", style: .default, handler: { _ in
                self.addMapOverlay()
            }))
            alert.addAction(UIAlertAction(title: "Standard kart", style: .default, handler: { _ in
                self.clearMapOverlay()
            }))

            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = mapSettingsView
                popoverController.sourceRect = mapSettingsView.bounds.offsetBy(dx: -.spacingS, dy: -20)
                popoverController.permittedArrowDirections = [.right]
            }

            present(alert, animated: true, completion: nil)
        }
    }

    public func searchResultMapView(_ view: SearchResultMapView, didSelect annotationView: MKAnnotationView) {
        print("didSelectAnnotationView of type: \(String(describing: annotationView.annotation))")
    }

    public func searchResultMapView(_ view: SearchResultMapView, didDeselect annotationView: MKAnnotationView) {
        print("didDeselectAnnotationView of type: \(String(describing: annotationView.annotation))")
    }

    public func searchResultMapView(_ view: SearchResultMapView, didUpdate userLocation: MKUserLocation) {
        print("MKMapView(:didUpdateUserLocation)")
    }

    public func searchResultMapViewRegionWillChangeDueToUserInteraction(_ view: SearchResultMapView) {
        print("MKMapView(:regionWillChangeAnimated) due to user interaction")
    }

    public func searchResultMapViewRegionDidChange(_ view: SearchResultMapView) {
        print("MKMapView(:regionDidChangeAnimated)")
    }

}
