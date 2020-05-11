//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0.0, *)
public struct BasicListCell: View {
    var action: (() -> Void)?
    private let model: BasicTableViewCellViewModel
    private let title: Text
    private let subtitle: Text?
    private let detailText: Text?

    public init(
        model: BasicTableViewCellViewModel,
        action: (() -> Void)? = nil,
        @ViewBuilder title: (String) -> Text = title,
        @ViewBuilder subtitle: (String?) -> Text? = subtitle,
        @ViewBuilder detailText: (String?) -> Text? = detailText
    ) {
        self.model = model
        self.action = action
        self.title = title(model.title)
        self.subtitle = subtitle(model.subtitle)
        self.detailText = detailText(model.detailText)
    }

    public var body: some View {
        Button(
            action: { self.action?() },
            label: { content }
        ).buttonStyle(BasicButtonStyle())
    }

    private var content: some View {
        HStack {
            VStack(alignment: .leading, spacing: .spacingXXS) {
                Spacer()
                title
                subtitle
                Spacer()
            }
            .padding(.trailing, .spacingM)
            .padding(.vertical, .spacingXS)

            Spacer()

            detailText

            if model.hasChevron {
                chevron
            }
        }.padding(.horizontal, .spacingM)
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(Color.gray.opacity(0.5))
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .padding(.leading, .spacingXXS)
    }

    // MARK: - Defaults

    public static func title(_ text: String) -> Text {
        Text(text)
            .finnFont(.body)
            .foregroundColor(.textPrimary)
    }

    public static func subtitle(_ text: String?) -> Text? {
        text.map({
            Text($0)
                .finnFont(.caption)
                .foregroundColor(.textPrimary)
        })
    }

    public static func detailText(_ text: String?) -> Text? {
        text.map({
            Text($0)
                .finnFont(.detail)
                .foregroundColor(.textSecondary)
        })
    }
}

@available(iOS 13.0, *)
private struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color(selectedColor) : Color.bgPrimary)
    }

    private var selectedColor: UIColor {
        return UIColor.dynamicColorIfAvailable(
            defaultColor: UIColor(r: 230, g: 235, b: 242),
            darkModeColor: UIColor(hex: "2f3039")
        )
    }
}

// MARK: - Previews

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct BasicListCell_Previews: PreviewProvider {
    private static let viewModels = [
        ViewModel(title: "Hagemøbler", subtitle: nil, detailText: nil, hasChevron: false),
        ViewModel(title: "Kattepuser", subtitle: "Fin-fine kattunger", detailText: nil, hasChevron: true),
        ViewModel(title: "Mac Mini Pro", subtitle: "En noe kraftigere Mac Mini", detailText: nil, hasChevron: true),
        ViewModel(title: "Mac Pro Mini", subtitle: nil, detailText: nil, hasChevron: false),
        ViewModel(title: "Mac Pro Max", subtitle: nil, detailText: nil, hasChevron: false),
        ViewModel(title: "Kristiansand", subtitle: nil, detailText: "4 352", hasChevron: false),
        ViewModel(title: "Oslo", subtitle: nil, detailText: "46 347", hasChevron: true)
    ]

    static var previews: some View {
        List {
            ForEach(viewModels, id: \.self) { model in
                BasicListCell(model: model)
                    .bottomDivider(model != self.viewModels.last)
            }
        }.listSeparatorStyleNone()
    }
}

private struct ViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    var title: String
    var subtitle: String?
    var detailText: String?
    var hasChevron: Bool
}
