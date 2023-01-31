import Foundation
import SwiftUI

struct ToastViewModifier: ViewModifier {
    let toastView: ToastSwiftUIView
    let timeout: TimeInterval
    let position: Toast.Position
    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if position == .bottom {
                    Spacer()
                }
                if isShowing {
                    toastView
                        .transition(.move(edge: position == .top ? .top : .bottom))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                                isShowing.toggle()
                            }
                        }
                }
                if position == .top {
                    Spacer()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isShowing)
        }
    }
}
