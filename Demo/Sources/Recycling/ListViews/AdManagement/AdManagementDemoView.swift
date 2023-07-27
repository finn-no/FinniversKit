//
//  Copyright © FINN.no AS. All rights reserved.
//

import FinniversKit
import DemoKit

class AdManagementDemoView: UIView {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserAdManagementStatisticsCell.self)
        tableView.register(UserAdManagementStatisticsEmptyViewCell.self)
        tableView.register(UserAdManagementButtonAndInformationCell.self)
        tableView.register(UserAdManagementUserActionCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgSecondary
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = true
        return tableView
    }()

    private var actionCellModels: [[AdManagementActionCellModel]] = [
        [
            AdManagementActionCellModel(title: "Gå til enkel utleie dashboard", iconImage: .stakeholder, trailingItem: .external)
        ],
        [
            AdManagementActionCellModel(title: "Slett annonsen", iconImage: .adManagementTrashcan),
            AdManagementActionCellModel(title: "Skjul annonsen midlertidig", iconImage: .eyeHide),
            AdManagementActionCellModel(title: "Flott toggle", iconImage: .checkCircle, trailingItem: .toggle),
        ],
        [
            AdManagementActionCellModel(title: "Rediger annonsen", iconImage: .pencilPaper, trailingItem: .chevron),
            AdManagementActionCellModel(title: "Legg ut annonsen på nytt", iconImage: .republish, trailingItem: .chevron)
        ],
        [
            AdManagementActionCellModel(title: "Marker annonsen som solgt", iconImage: .checkCircle),
            AdManagementActionCellModel(title: "Eierskifteforsikring", iconImage: .more, trailingItem: .chevron)
        ],
        [
            AdManagementActionCellModel(title: "Vis annonsen i søkeresultater", iconImage: .view),
            AdManagementActionCellModel(title: "Fjern solgtmarkering", iconImage: .uncheckCircle)
        ],
        [
            AdManagementActionCellModel(title: "Gi en vurdering", iconImage: .rated, trailingItem: .chevron)
        ]
    ]

    private lazy var statisticModel: StatisticsModel = {
        let header = StatisticsModel.HeaderModel(
            title: "Annonsestatistikk",
            fullStatisticsTitle: "Se full statistikk"
        )
        return StatisticsModel(header: header, statisticItems: statisticsCellModels)
    }()

    private static var exampleStatisticsCellModels: [StatisticsItemModel] = [
        .init(type: .seen, value: 968, text: "har sett annonsen"),
        .init(type: .favourited, value: 16, text: "har lagret annonsen"),
        .init(type: .email, value: 1337, text: "har fått e-post om annonsen")
    ]

    private var statisticsCellModels: [StatisticsItemModel] = exampleStatisticsCellModels {
        didSet {
            tableView.reloadData()
        }
    }

    private var statisticsEmptyViewCellModel: StatisticsItemEmptyViewModel = {
        StatisticsItemEmptyViewModel(
            title: "Følg med på effekten",
            description: "Etter at du har publisert annonsen din kan du se statistikk for hvor mange som har sett annonsen din, favorisert den og som har fått tips om den.")
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
        configure(forTweakAt: 0)
    }
}

extension AdManagementDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case withStatistics
        case emptyStatistics
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .withStatistics:
            statisticsCellModels = AdManagementDemoView.exampleStatisticsCellModels
        case .emptyStatistics:
            statisticsCellModels = []
        }
    }
}

// MARK: - UITableViewDataSource

extension AdManagementDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return actionCellModels[section - 1].count

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        actionCellModels.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 && statisticsCellModels.isEmpty == true {
                let cell = tableView.dequeue(UserAdManagementStatisticsEmptyViewCell.self, for: indexPath)
                cell.itemModel = statisticsEmptyViewCellModel
                return cell
            }

            switch indexPath.row {
            case 0:
                let cell = tableView.dequeue(UserAdManagementStatisticsCell.self, for: indexPath)
                cell.configure(with: statisticModel)
                cell.delegate = self
                return cell
            default:
                let cell = tableView.dequeue(UserAdManagementButtonAndInformationCell.self, for: indexPath)
                cell.informationText = "Du kan øke synligheten av annonsen din ytterligere ved å oppgradere den."
                cell.buttonText = "Kjøp mer synlighet"
                return cell
            }
        } else {
            let cell = tableView.dequeue(UserAdManagementUserActionCell.self, for: indexPath)
            let model = actionCellModels[indexPath.section - 1][indexPath.row]
            cell.delegate = self
            cell.configure(with: model)
            cell.showSeparator(indexPath.row != 0)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

// MARK: - UITableViewDelegate

extension AdManagementDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
}

// MARK: - UserAdManagementStatisticsCellDelegate

extension AdManagementDemoView: UserAdManagementStatisticsCellDelegate {
    func userAdManagementStatisticsCellDidSelectFullStatistics(_ cell: UserAdManagementStatisticsCell) {}
}

// MARK: - UserAdManagementActionCellDelegate

extension AdManagementDemoView: UserAdManagementActionCellDelegate {
    func userAdManagementActionCell(_ cell: UserAdManagementUserActionCell, switchChangedState switchIsOn: Bool) {
        print("✅ Toggle switched state. Is on: \(switchIsOn)")
    }
}

// MARK: - Private extensions

private extension AdManagementActionCellModel {
    init(title: String, iconImage: ImageAsset, trailingItem: TrailingItem = .none) {
        self.init(title: title, iconImage: UIImage(named: iconImage), trailingItem: trailingItem)
    }
}
