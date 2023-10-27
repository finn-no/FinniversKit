//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

public struct InlineFlatStyle: ButtonStyle {
    private let font: Font
    private let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .backgroundPrimary) {
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

public struct FlatStyle: ButtonStyle {
    private let size: Button.Size
    private let font: Font
    private let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .backgroundPrimary) {
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

public struct DefaultStyle: ButtonStyle {
    private let size: Button.Size
    private let font: Font
    private let textColor: Color

    public init(size: Button.Size = .normal, textColor: Color = .backgroundPrimary) {
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
            configuration.isPressed ? Color(UIColor.defaultButtonHighlightedBodyColor) : .background
        )
        .roundedBorder(
            radius: .spacingS,
            color: configuration.isPressed ? .backgroundPrimary : .backgroundDisabled
        )
    }
}

public struct CallToAction: ButtonStyle {
    @Binding var isEnabled: Bool
    private let background: Color
    private let font: Font
    private let fullWidth: Bool

    public init(size: Button.Size = .normal, background: Color = .backgroundPrimary, fullWidth: Bool = true, isEnabled: Binding<Bool>? = nil) {
        self.background = background
        self.fullWidth = fullWidth
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        if let isEnabledBinding = isEnabled {
            self._isEnabled = isEnabledBinding
        } else {
            self._isEnabled = .constant(true)
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if fullWidth {
                Spacer()
            }
            configuration.label
                .font(font)
                .foregroundColor(isEnabled ? .textInverted : .textCTADisabled)
            if fullWidth {
                Spacer()
            }
        }
        .padding(.vertical, .spacingS)
        .padding(.horizontal, .spacingM)
        .background(isEnabled ? dynamicBackground(configuration) : .backgroundDisabled)
        .cornerRadius(.spacingS)
        .animation(.easeOut, value: isEnabled)
    }

    private func dynamicBackground(_ configuration: Configuration) -> Color {
        configuration.isPressed ? background.opacity(0.8) : background
    }
}
