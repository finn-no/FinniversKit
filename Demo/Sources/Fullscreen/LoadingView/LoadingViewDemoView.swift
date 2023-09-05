//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

extension LoadingView.DisplayType {
    var title: String {
        switch self {
        case .fullscreen: return "Fullscreen"
        case .boxed: return "Boxed"
        }
    }
}

private struct Option {
    var title: String
    var description: String
    var action: (() -> Void)
}

class LoadingViewDemoView: UIView, Demoable {
    var currentDisplayType: LoadingView.DisplayType {
        return LoadingView.DisplayType(rawValue: displayTypeSegment.selectedSegmentIndex) ?? .fullscreen
    }

    private lazy var options: [Option] = {
        var options = [Option]()

        options.append(Option(title: "Simple show", description: "(shows after 0.5s, hides after a second)", action: {
            LoadingView.show(displayType: self.currentDisplayType)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.hide()
            })
        }))

        options.append(Option(title: "Simple show", description: "(shows immediately, hides after a second)", action: {
            LoadingView.show(afterDelay: 0, displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show with message", description: "shows after 0.5s, hides after a second", action: {
            LoadingView.show(withMessage: "Hi there!", displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show with message", description: "shows immediately, hides after a second", action: {
            LoadingView.show(withMessage: "Hi there!", afterDelay: 0, displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success", description: "shows after 0.5s, hides after a second", action: {
            LoadingView.showSuccess(displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success", description: "shows immediately, hides after a second", action: {
            LoadingView.showSuccess(afterDelay: 0, displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success with message", description: "shows after 0.5s, hides after a second", action: {
            LoadingView.showSuccess(withMessage: "Hi there!", displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Show success with message", description: "shows immediately, hides after a second", action: {
            LoadingView.showSuccess(withMessage: "Hi there!", afterDelay: 0, displayType: self.currentDisplayType)
            LoadingView.hide(afterDelay: 1.0)
        }))

        options.append(Option(title: "Full: Shows w/ message, Success, Hides", description: "shows after 0.5s, hides after 2s", action: {
            LoadingView.show(withMessage: "Hi there!", displayType: self.currentDisplayType)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.showSuccess(withMessage: "It worked!", displayType: self.currentDisplayType)
                LoadingView.hide(afterDelay: 1.0)
            })
        }))

        options.append(Option(title: "Full: Show w/ message, Success, Hides", description: "shows immediately, hides after 2s", action: {
            LoadingView.show(withMessage: "Hi there!", afterDelay: 0, displayType: self.currentDisplayType)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.showSuccess(withMessage: "It worked!", afterDelay: 0, displayType: self.currentDisplayType)
                LoadingView.hide(afterDelay: 1.0)
            })
        }))

        options.append(Option(title: "throttling: show and hide right after", description: "should not be visible at all", action: {
            LoadingView.show(withMessage: "Hi there!", displayType: self.currentDisplayType)
            LoadingView.hide()
        }))

        options.append(Option(title: "Racy scheduling", description: "Show only show the success-view", action: {
            LoadingView.show(withMessage: "Should not be visible", afterDelay: 0.2, displayType: self.currentDisplayType)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                LoadingView.showSuccess(withMessage: "Success", afterDelay: 0, displayType: self.currentDisplayType)
                LoadingView.hide(afterDelay: 0.5)
            })
        }))

        return options
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var displayTypeSegment: UISegmentedControl = {
        let view = UISegmentedControl(items: LoadingView.DisplayType.allCases.map { $0.title })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.selectedSegmentIndex = 0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(tableView)
        addSubview(displayTypeSegment)

        NSLayoutConstraint.activate([
            displayTypeSegment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            displayTypeSegment.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
            displayTypeSegment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: displayTypeSegment.topAnchor, constant: -.spacingM),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])

        tableView.register(OptionCell.self)
    }
}

// MARK: - UITableViewDataSource

extension LoadingViewDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OptionCell.self, for: indexPath)
        let option = options[indexPath.row]
        cell.option = option
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LoadingViewDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        option.action()
    }
}

// MARK: - OptionCell

private class OptionCell: UITableViewCell {

    var option: Option? {
        didSet {
            titleLabel.text = option?.title
            descriptionLabel.text = option?.description
        }
    }

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.spacingS),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.spacingS),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS)
        ])
    }
}
