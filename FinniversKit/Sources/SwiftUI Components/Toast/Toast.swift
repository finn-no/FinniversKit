import SwiftUI

struct Toast: ViewModifier {
    let toastView: ToastSwiftUIView
    let timeout: TimeInterval
    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Spacer()
                if isShowing {
                    toastView
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                            isShowing.toggle()
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isShowing)
        }
    }
}

extension View {
    public func toast(view: ToastSwiftUIView, isShowing: Binding<Bool>, timeout: TimeInterval = 5) -> some View {
        self.modifier(Toast(toastView: view, timeout: timeout, isShowing: isShowing))
    }
}
