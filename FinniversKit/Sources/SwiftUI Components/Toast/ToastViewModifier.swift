import Foundation
import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var viewModel: Toast.ViewModel?

    private var isPresented: Bool {
        viewModel != nil
    }

    @State private var toastID: UUID?

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if let viewModel {
                    let position = viewModel.position

                    if position == .bottom {
                        Spacer()
                    }

                    ToastSwiftUIView(text: viewModel.text, style: viewModel.style, actionButton: viewModel.actionButton)
                        .transition(.move(edge: position == .top ? .top : .bottom))
                        .gesture(
                            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                                .onEnded { value in
                                    let swipedVertically = abs(value.translation.height) > abs(value.translation.width)
                                    guard swipedVertically else { return }
                                    let swipedDown = value.translation.height > 0
                                    let swipedUp = !swipedDown
                                    if position == .bottom && swipedDown || position == .top && swipedUp {
                                        self.viewModel = nil
                                    }
                                }
                        )

                    if position == .top {
                        Spacer()
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isPresented)
        }
        .onChange(of: viewModel) { newValue in
            guard let viewModel = newValue else { return }
            let toastID = UUID()
            let dismissToastWorkItem = DispatchWorkItem {
                if self.toastID == toastID, self.viewModel != nil {
                    self.viewModel = nil
                }
            }
            self.toastID = toastID
            DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.timeout, execute: dismissToastWorkItem)
        }
    }
}
