//
//  SelfDeclarationView.swift
//  FinniversKit
//

import SwiftUI

public struct SelfDeclarationView: View {

    public let viewModel: SelfDeclarationViewModel

    public init(viewModel: SelfDeclarationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: .spacingL) {
                ForEach(viewModel.items, id: \.self.question) { item in
                    VStack(alignment: .leading, spacing: .spacingXS) {
                        Text(item.question)
                            .font(.finnFont(.body))
                        Text("\(item.answer) \(item.explanation)")
                            .font(.finnFont(.bodyStrong))
                    }
                }
            }
            Spacer()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .top
        )
    }
}

struct SelfDeclarationView_Previews: PreviewProvider {
    static let viewModel = SelfDeclarationViewModel(items: [
        .init(
            question: "Kjente feil, mangler eller synlige skader?",
            answer: "Ja.",
            explanation: "Liten bulk på støtfanger foran"
        ),
        .init(
            question: "Er det gjort større reparasjoner?",
            answer: "Nei.",
            explanation: ""
        ),
        .init(
            question: "Har bilen heftelser/gjeld?",
            answer: "Nei.",
            explanation: ""
        )
    ])
    static var previews: some View {
        SelfDeclarationView(viewModel: viewModel)
    }
}
