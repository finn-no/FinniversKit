//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct ListSeparatorStyleNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }.onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
        }
    }
}

@available(iOS 13.0.0, *)
extension List {
    public func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}
