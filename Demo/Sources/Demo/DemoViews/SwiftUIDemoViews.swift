//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import FinniversKit
import DemoKit

enum SwiftUIDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case checkBox
    case floatingButton
    case htmlText
    case iconButton
    case loadingIndicator
    case loadingView
    case radioButton
    case selectionListView
    case textField
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
        case .floatingButton:
            return SwiftUIFloatingButton_Previews()
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
extension FinnTextView_Previews: Demoable {}
