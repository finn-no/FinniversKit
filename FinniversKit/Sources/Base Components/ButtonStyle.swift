//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct InlineFlatStyle: ButtonStyle {
    private let font: Font
    private let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .btnPrimary) {
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(font)
            .foregroundColor(configuration.isPressed ? textColor.opacity(0.8) : textColor)
    }
}

@available(iOS 13.0, *)
public struct FlatStyle: ButtonStyle {
    private let size: Button.Size
    private let font: Font
    private let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .btnPrimary) {
        self.size = size
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            InlineFlatStyle(size: size, textColor: textColor)
                .makeBody(configuration: configuration)
            Spacer()
        }
        .padding(.vertical, .spacingS)
        .padding(.horizontal, .spacingM)
    }
}

@available(iOS 13.0, *)
public struct DefaultStyle: ButtonStyle {
    private let size: Button.Size
    private let font: Font
    private let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .btnPrimary) {
        self.size = size
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
    }

    public func makeBody(configuration: Configuration) -> some View {
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
        .background(
            configuration.isPressed ? Color(UIColor.defaultButtonHighlightedBodyColor) : Color.bgPrimary
        )
        .roundedBorder(
            radius: .spacingS,
            color: configuration.isPressed ? .btnPrimary : .btnDisabled
        )
    }
}

@available(iOS 13.0, *)
public struct CallToAction: ButtonStyle {
    private let background: Color
    private let font: Font

    public init(size: Button.Size = .normal, background: Color = .btnPrimary) {
        self.background = background
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
    }

    public func makeBody(configuration: Configuration) -> some View {
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

    private func dynamicBackground(_ configuration: Configuration) -> Color {
        configuration.isPressed ? background.opacity(0.8) : background
    }
}
