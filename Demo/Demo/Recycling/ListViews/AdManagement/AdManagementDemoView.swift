//
//  Copyright © FINN.no AS. All rights reserved.
//

import FinniversKit

public class AdManagementDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Empty statistics") { self.statisticsCellModels = [] },
        TweakingOption(title: "With statistics") { self.statisticsCellModels = AdManagementDemoView.exampleStatisticsCellModels },
    ]

    private let estimatedRowHeight: CGFloat = 200

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserAdManagementStatisticsCell.self)
        tableView.register(UserAdManagementStatisticsEmptyViewCell.self)
        tableView.register(UserAdManagementButtonAndInformationCell.self)
        tableView.register(UserAdManagementUserActionCell.self)
        tableView.register(UserAdManagementMotorTransactionCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgSecondary
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = true
        return tableView
    }()

    private var actionCellModels: [[AdManagementActionCellModel]] = [
        [
            AdManagementActionCellModel(actionType: .rentalApplications, title: "Gå til enkel utleie dashboard", showExternalIcon: true)
        ],
        [
            AdManagementActionCellModel(actionType: .delete, title: "Slett annonsen"),
            AdManagementActionCellModel(actionType: .stop, title: "Skjul annonsen midlertidig", description: "Annonsen blir skjult fra FINNs søkeresultater")
        ],
        [
            AdManagementActionCellModel(actionType: .edit, title: "Rediger annonsen", description: "Sist redigert 13.12.2018"),
            AdManagementActionCellModel(actionType: .republish, title: "Legg ut annonsen på nytt")
        ],
        [
            AdManagementActionCellModel(actionType: .dispose, title: "Marker annonsen som solgt"),
            AdManagementActionCellModel(actionType: .externalFallback, title: "Eierskifteforsikring", description: "Se hvilke tilbud våre samarbeidspartnere kan by på")
        ],
        [
            AdManagementActionCellModel(actionType: .start, title: "Vis annonsen i søkeresultater"),
            AdManagementActionCellModel(actionType: .undispose, title: "Fjern solgtmarkering")
        ],
        [
            AdManagementActionCellModel(actionType: .review, title: "Gi en vurdering")
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
        return StatisticsItemEmptyViewModel(title: "Følg med på effekten",
                                            description: "Etter at du har publisert annonsen din kan du se statistikk for hvor mange som har sett annonsen din, favorisert den og som har fått tips om den.")
    }()

    private let transactionProcessSummaryCellModel = MotorTransactionEntryViewModel(
        title: "Salgsprosess",
        detail: "Overlevering",
        description: "Kjøper har bekreftet. Dere må bekrefte før 8.februar 2020.",
        externalView: .init(text: "Mine kjøretøy", url: "https://www.finn.no/minekjoretoy"),
        style: "ERROR"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public override func didMoveToSuperview() {
        tableView.reloadData()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

extension AdManagementDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        }

        return actionCellModels[section - 2].count

    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return actionCellModels.count + 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

        } else if indexPath.section == 1 {
            let cell = tableView.dequeue(UserAdManagementMotorTransactionCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(with: transactionProcessSummaryCellModel, shouldShowExternalView: true)
            return cell
        } else {
            let cell = tableView.dequeue(UserAdManagementUserActionCell.self, for: indexPath)
            cell.setupWithModel(actionCellModels[indexPath.section - 2][indexPath.row])
            cell.showSeparator(indexPath.row != 0)
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
}

extension AdManagementDemoView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
}

extension AdManagementDemoView: UserAdManagementStatisticsCellDelegate {
    public func userAdManagementStatisticsCellDidSelectFullStatistics(_ cell: UserAdManagementStatisticsCell) {}
}

extension AdManagementDemoView: UserAdManagementMotorTransactionCellDelegate {
    public func userAdManagementMotorTransactionCellDidTapSummary(_ view: UserAdManagementMotorTransactionCell) {
        print("Did tap summary in UserAdManagementTransactionProcessCell")
    }

    public func userAdManagementMotorTransactionCellDidTapExternalView(_ view: UserAdManagementMotorTransactionCell) {
        print("Did tap external view in UserAdManagementTransactionProcessCell")
    }
}
