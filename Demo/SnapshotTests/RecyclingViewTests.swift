@testable import Demo
import XCTest
import UIKit
import FinniversKit
import DemoKitSnapshot
import SnapshotTesting

@MainActor
class RecyclingViewTests: XCTestCase {
    private struct SnapshotConfiguration {
        let style: UIUserInterfaceStyle
        let imageConfig: ViewImageConfig
        let horizontalSizeClass: UIUserInterfaceSizeClass
        let name: String
    }

    private func snapshot(_ component: RecyclingDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testNotificationsListView() {
        snapshot(.notificationsListView)
    }

    func testAdRecommendationsGridView() {
        snapshot(.adRecommendationsGridView)
    }

    func testFavoritesListView() {
        snapshot(.favoritesListView)
    }

    func testFavoriteFoldersListView() {
        let configurations = [
            SnapshotConfiguration(style: .light, imageConfig: .iPadPro12_9, horizontalSizeClass: .regular, name: "light_iPad"),
            SnapshotConfiguration(style: .light, imageConfig: .iPhoneX, horizontalSizeClass: .compact, name: "light_iPhone"),
            SnapshotConfiguration(style: .dark, imageConfig: .iPadPro12_9, horizontalSizeClass: .regular, name: "dark_iPad"),
            SnapshotConfiguration(style: .dark, imageConfig: .iPhoneX, horizontalSizeClass: .compact, name: "dark_iPhone"),
        ]

        for configuration in configurations {
            let demoView = FavoriteFoldersListDemoView()
            demoView.loadsRemoteImages = false

            let viewController = UIViewController()
            viewController.view.backgroundColor = .systemBackground
            viewController.view.addSubview(demoView)
            demoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                demoView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
                demoView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                demoView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
                demoView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor),
            ])

            let traits = UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceStyle: configuration.style),
                UITraitCollection(horizontalSizeClass: configuration.horizontalSizeClass),
            ])

            if let size = configuration.imageConfig.size {
                viewController.view.frame = CGRect(origin: .zero, size: size)
            }
            viewController.view.layoutIfNeeded()
            demoView.view.reloadData()
            viewController.view.layoutIfNeeded()

            assertSnapshot(
                of: viewController,
                as: .image(on: configuration.imageConfig, traits: traits),
                named: configuration.name,
                testName: "FavoriteFoldersListDemoView"
            )
        }
    }

    func testSavedSearchesListView() {
        snapshot(.savedSearchesListView)
    }

    func testSettingsView() {
        snapshot(.settingsView)
    }

    func testNeighborhoodProfileView() {
        snapshot(.neighborhoodProfileView)
    }

    func testBasicTableView() {
        snapshot(.basicTableView)
    }
}
