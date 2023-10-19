//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import FinniversKit
import DemoKit

enum SwiftUIDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case checkBox
    case htmlText
    case iconButton
    case loadingIndicator
    case loadingView
    case radioButton
    case selectionListView
    case textField
    case textFieldNew
    case textView
    case toast
    case resultView

    static var groupTitle: String { "SwiftUI" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .checkBox:
            return SwiftUICheckBox_Previews()
        case .htmlText:
            return HTMLTextDemoViewController()
        case .iconButton:
            return SwiftUIIconButton_Previews()
        case .loadingIndicator:
            return SwiftUILoadingIndicatorDemoView_Previews()
        case .loadingView:
            return LoadingSwiftUIDemoView_Previews()
        case .radioButton:
            return SwiftUIRadioButton_Previews()
        case .selectionListView:
            return SwiftUISelectionListDemoView_Previews()
        case .textField:
            return FinnTextField_Previews()
        case .textFieldNew:
            return SwiftUITextFieldStyles_Previews()
        case .textView:
            return FinnTextView_Previews()
        case .toast:
            return ToastSwiftUIDemoView_Previews()
        case .resultView:
            return ResultSwiftUIDemoViewController()
        }
    }
}

// MARK: - PreviewProvider conformances

extension SwiftUIIconButton_Previews: Demoable {}
extension SwiftUICheckBox_Previews: Demoable {}
extension SwiftUIFloatingButton_Previews: Demoable {}
extension SwiftUIRadioButton_Previews: Demoable {}
extension SwiftUITextFieldStyles_Previews: Demoable {}
extension FinnTextView_Previews: Demoable {}

// MARK: - The same previews found in FinniversKit to use for demo
struct SwiftUIRadioButton_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper(true) { binding in
                SwiftUIRadioButton(isSelected: binding)
                    .onTapGesture {
                        binding.wrappedValue.toggle()
                    }
            }

            StatefulPreviewWrapper(false) { binding in
                SwiftUIRadioButton(isSelected: binding)
                    .onTapGesture {
                        binding.wrappedValue.toggle()
                    }
            }
        }
    }
}

struct SwiftUICheckBox_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper(false) {
                SwiftUICheckBox(isChecked: $0)
            }
            StatefulPreviewWrapper(true) {
                SwiftUICheckBox(isChecked: $0)
            }
        }
    }
}

struct SwiftUIIconButton_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        StatefulPreviewWrapper(true) { binding in
            SwiftUIIconButton(style: .favorite, isToggled: binding)
                .onTapGesture {
                    binding.wrappedValue.toggle()
                }
        }
    }
}
extension SwiftUITextFieldStyles_Previews: Demoable {}