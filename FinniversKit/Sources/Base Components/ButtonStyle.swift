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
    private let fullWidth: Bool
    private let padding: EdgeInsets

    public init(
        size: Button.Size = .normal,
        textColor: Color = .backgroundPrimary,
        fullWidth: Bool = true,
        padding: EdgeInsets = .init(top: .spacingS, leading: .spacingM, bottom: .spacingS, trailing: .spacingM)
    ) {
        self.size = size
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
        self.fullWidth = fullWidth
        self.padding = padding
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if fullWidth {
                Spacer()
            }
            InlineFlatStyle(size: size, textColor: textColor)
                .makeBody(configuration: configuration)
            if fullWidth {
                Spacer()
            }
        }
        .padding(padding)
    }
}

public struct DefaultStyle: ButtonStyle {
    private let size: Button.Size
    private let font: Font
    private let textColor: Color
    private let fullWidth: Bool
    private let padding: EdgeInsets

    public init(
        size: Button.Size = .normal,
        textColor: Color = .backgroundPrimary,
        fullWidth: Bool = true,
        padding: EdgeInsets = .init(top: .spacingS, leading: .spacingM, bottom: .spacingS, trailing: .spacingM)
    ) {
        self.size = size
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)
        self.textColor = textColor
        self.fullWidth = fullWidth
        self.padding = padding
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if fullWidth {
                Spacer()
            }
            configuration
                .label
                .font(font)
                .foregroundColor(textColor)
            if fullWidth {
                Spacer()
            }
        }
        .padding(padding)
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
    private let padding: EdgeInsets

    public init(
        size: Button.Size = .normal,
        background: Color = .backgroundPrimary,
        fullWidth: Bool = true,
        isEnabled: Binding<Bool>? = nil,
        padding: EdgeInsets? = nil
    ) {
        self.background = background
        self.fullWidth = fullWidth
        self.font = size == .normal ? .finnFont(.bodyStrong) : .finnFont(.detailStrong)

        if let padding {
            self.padding = padding
        } else {
            let verticalPadding: CGFloat = size == .normal ? .normalButtonVerticalPadding : .spacingS
            let defaultPadding: EdgeInsets = .init(top: verticalPadding, leading: .spacingM, bottom: verticalPadding, trailing: .spacingM)
            self.padding = defaultPadding
        }

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
                .foregroundColor(isEnabled ? .textInverted : .text)
            if fullWidth {
                Spacer()
            }
        }
        .padding(padding)
        .background(isEnabled ? dynamicBackground(configuration) : .backgroundDisabled)
        .cornerRadius(.spacingS)
        .animation(.easeOut, value: isEnabled)
    }

    private func dynamicBackground(_ configuration: Configuration) -> Color {
        configuration.isPressed ? background.opacity(0.8) : background
    }
}

private extension CGFloat {
    static let normalButtonVerticalPadding: CGFloat = 13
}

#Preview {
    VStack {
        HStack(spacing: 0) {
            Text("Example ")
                .finnFont(.body)
            SwiftUI.Button("inline style", action: {})
                .buttonStyle(InlineFlatStyle())
            Text(" with some text")
                .finnFont(.body)
        }
        SwiftUI.Button("Flat", action: {})
            .buttonStyle(FlatStyle())
        SwiftUI.Button("Default (full width)", action: {})
            .buttonStyle(DefaultStyle())
        SwiftUI.Button("Default", action: {})
            .buttonStyle(DefaultStyle(fullWidth: false))
        SwiftUI.Button("Call to action (full width)", action: {})
            .buttonStyle(CallToAction())
        SwiftUI.Button("Call to action", action: {})
            .buttonStyle(CallToAction(fullWidth: false))
    }
}
