import SwiftUI

struct Toast: ViewModifier {
    let toastView: ToastSwiftUIView
    let duration: TimeInterval = 2
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
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
    public func toast(view: ToastSwiftUIView, isShowing: Binding<Bool>) -> some View {
        self.modifier(Toast(toastView: view, isShowing: isShowing))
    }
}
