import SwiftUI

struct Toast: ViewModifier {
    let toastView: ToastSwiftUIView
    let timeout: TimeInterval
    let position: ToastPosition
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

public enum ToastPosition {
    case top
    case bottom
}

extension View {
    public func toast(view: ToastSwiftUIView, isShowing: Binding<Bool>, timeout: TimeInterval = 5, position: ToastPosition = .bottom) -> some View {
        self.modifier(Toast(toastView: view, timeout: timeout, position: position, isShowing: isShowing))
    }
}
