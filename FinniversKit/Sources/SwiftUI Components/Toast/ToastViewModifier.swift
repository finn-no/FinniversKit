import Foundation
import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var viewModel: Toast.ViewModel?

    private var isPresented: Bool {
        viewModel != nil
    }

    @State private var toastTimeoutWorkItem: DispatchWorkItem? {
        didSet {
            oldValue?.cancel()
        }
    }

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
                        .onAppear {
                            let dismissToastWorkItem = DispatchWorkItem {
                                self.viewModel = nil
                            }
                            toastTimeoutWorkItem = dismissToastWorkItem
                            DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.timeout, execute: dismissToastWorkItem)
                        }
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
    }
}
