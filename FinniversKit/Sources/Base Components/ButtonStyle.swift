//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct InlineFlatStyle: ButtonStyle {
    let font: Font
    let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .btnPrimary) {
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(font)
            .foregroundColor(textColor)
    }
}

@available(iOS 13.0, *)
struct FlatStyle: ButtonStyle {
    let font: Font
    let textColor: Color

    init(size: Button.Size = .normal, textColor: Color = .btnPrimary) {
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration
                .label
                .font(font)
                .foregroundColor(textColor)
            Spacer()
        }
        .padding(.vertical, .spacingS)
        .padding(.horizontal, .spacingM)
    }
}

@available(iOS 13.0, *)
struct DefaultStyle: ButtonStyle {
    let font: Font
    let textColor: Color

    init(size: Button.Size = .normal, textColor: Color = .btnPrimary) {
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(font)
                .foregroundColor(textColor)
            Spacer()
        }
        .padding(.vertical, .spacingS)
        .padding(.horizontal, .spacingM)
        .background(Color.bgPrimary)
        .roundedBorder(radius: .spacingS, color: .btnDisabled)
    }
}

@available(iOS 13.0, *)
struct CallToAction: ButtonStyle {
    let background: UIColor
    let font: Font

    init(size: Button.Size = .normal, background: UIColor = .btnPrimary) {
        self.background = background
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(font)
                .foregroundColor(.textTertiary)
            Spacer()
        }
        .padding(.vertical, .spacingS)
        .padding(.horizontal, .spacingM)
        .background(dynamicBackground(configuration))
        .cornerRadius(.spacingS)
    }

    func dynamicBackground(_ configuration: Configuration) -> Color {
        if configuration.isPressed {
            return Color(background.withAlphaComponent(0.8))
        } else {
            return Color(background)
        }
    }
}
