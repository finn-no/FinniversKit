//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0.0, *)
public struct SettingsView: View {
    private let sections: [SettingsSection]

    public init(sections: [SettingsSection]) {
        self.sections = sections
    }

    public var body: some View {
        List {
            ForEach(0..<sections.count) { section in
                self.sections[section].title.map(Header.init)

                ForEach(0..<self.sections[section].items.count) { row in
                    self.cell(at: row, in: section)
                        .bottomDivider(self.isLastRow(row, in: section))
                }

                self.sections[section].footerTitle.map(Footer.init)
            }
        }
        .listSeparatorStyleNone()
        .edgesIgnoringSafeArea(.all)
    }

    private func cell(at row: Int, in section: Int) -> AnyView {
        let model = sections[section].items[row]

        switch model {
        case let model as SettingsViewToggleCellModel:
            return AnyView(ToggleCell(model: model))
        case let model as SettingsViewConsentCellModel:
            return AnyView(ConsentCell(model: model))
        default:
            return AnyView(BasicListCell(model: model))
        }
    }

    private func isLastRow(_ row: Int, in section: Int) -> Bool {
        row != self.sections[section].items.count - 1
    }
}

// MARK: - Cells

@available(iOS 13.0.0, *)
private struct Header: View {
    let text: String

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(text.uppercased())
                    .font(Font(UIFont.detailStrong))
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, .spacingM)
                    .padding(.bottom, .spacingS)
                Spacer()
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .background(Color.bgTertiary)
        .frame(height: 48)
    }
}

@available(iOS 13.0.0, *)
private struct Footer: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(Font(UIFont.caption))
                .foregroundColor(.textSecondary)
                .padding(.horizontal, .spacingM)
                .padding(.vertical, .spacingS)
            Spacer()
        }
        .background(Color.bgTertiary)
        .listRowInsets(EdgeInsets())
    }
}

@available(iOS 13.0.0, *)
private struct ConsentCell: View {
    let model: SettingsViewConsentCellModel

    var body: some View {
        BasicListCell(model: model, detailText: { _ in
            Text(model.status)
                .font(Font(UIFont.body))
                .foregroundColor(.textSecondary)
        })
    }
}

@available(iOS 13.0.0, *)
private struct ToggleCell: View {
    let model: SettingsViewToggleCellModel
    @SwiftUI.State private var isOn = true

    init(model: SettingsViewToggleCellModel) {
        self.model = model
        _isOn = State(initialValue: model.isOn)
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            BasicListCell(model: model)
        }
        .padding(.trailing, .spacingM)
        .background(Color.bgPrimary)
    }
}

// MARK: - Previews

@available(iOS 13.0.0, *)
struct SettingsView_Previews: PreviewProvider {
    private static let sections = [
        SettingsSection(
            title: "Varslinger",
            items: [
                ToggleRow(
                    id: "priceChange",
                    title: "Prisnedgang på favoritter - Torget",
                    isOn: false
                ),
            ],
            footerTitle: "FINN varsler deg når prisen på en av dine favoritter på Torget blir satt ned."
        ),
        SettingsSection(
            title: "Meldinger",
            items: [
                ConsentRow(title: "Meldinger til e-post", status: "Av"),
            ]
        ),
        SettingsSection(
            title: "Personvern",
            items: [
                ConsentRow(title: "Få nyhetsbrev fra FINN", status: "Av"),
                ConsentRow(title: "Personlig tilpasset FINN", status: "På"),
                ConsentRow(title: "Motta viktig informasjon fra FINN", status: "På"),
                TextRow(title: "Smart reklame"),
                TextRow(title: "Last ned dine data"),
                TextRow(title: "Slett meg som bruker")
            ]
        )
    ]

    static var previews: some View {
        ZStack {
            Color.bgTertiary
            SettingsView(sections: sections)
        }
    }
}

private struct TextRow: SettingsViewCellModel {
    let title: String
}

private struct ToggleRow: SettingsViewToggleCellModel {
    let id: String
    let title: String
    let isOn: Bool
}

private struct ConsentRow: SettingsViewConsentCellModel {
    let title: String
    let status: String
}
