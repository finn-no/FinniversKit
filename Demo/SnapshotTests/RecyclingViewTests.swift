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
            let traits = UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceStyle: configuration.style),
                UITraitCollection(horizontalSizeClass: configuration.horizontalSizeClass),
            ])
            let demoView = FavoriteFoldersListDemoView()
            demoView.prepareForSnapshotTesting()

            let demoViewController = UIViewController()
            demoViewController.view.backgroundColor = .systemBackground
            demoViewController.view.addSubview(demoView)
            demoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                demoView.topAnchor.constraint(equalTo: demoViewController.view.safeAreaLayoutGuide.topAnchor),
                demoView.leadingAnchor.constraint(equalTo: demoViewController.view.leadingAnchor),
                demoView.trailingAnchor.constraint(equalTo: demoViewController.view.trailingAnchor),
                demoView.bottomAnchor.constraint(equalTo: demoViewController.view.safeAreaLayoutGuide.bottomAnchor),
            ])

            let viewController = UIViewController()
            viewController.addChild(demoViewController)
            viewController.view.addSubview(demoViewController.view)
            demoViewController.view.frame = viewController.view.bounds
            demoViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            demoViewController.didMove(toParent: viewController)
            viewController.setOverrideTraitCollection(traits, forChild: demoViewController)

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
