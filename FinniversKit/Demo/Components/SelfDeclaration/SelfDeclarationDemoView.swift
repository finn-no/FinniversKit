//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class SelfDeclarationDemoView: UIView {

    private lazy var selfDeclarationView = SelfDeclarationView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(selfDeclarationView)

        NSLayoutConstraint.activate([
            selfDeclarationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            selfDeclarationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            selfDeclarationView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .spacingM),
            selfDeclarationView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.spacingM),
        ])

        selfDeclarationView.configure(with: .default)
    }
}

// MARK: - Private extensions

private extension SelfDeclarationViewModel {
    static let `default`: SelfDeclarationViewModel = {
        let introduction = "Punktene nedenfor er de vanligste årsakene til tvistesaker ved salg av bruktbil mellom private, og bør sjekkes. Selger har svart ut fra sin kjennskap til bilens historikk."
        let items = [
            SelfDeclarationItemViewModel(
                question: "Mangellapp foreligger",
                answer: "Ja",
                explanation: "Hvis svaret er JA her betyr det at bilen har vært på EU-kontroll og ikke blitt godkjent og derfor fått en liste med ting som må utbedres før den blir godkjent."
            ),
            SelfDeclarationItemViewModel(
                question: "Bilen er brukt i næringsvirksomhet",
                answer: "Nei",
                explanation: "Hvis svaret er JA her betyr det at bilen har blitt brukt som drosje, leiebil, begravelsesbil eller annen næringsvirksomhet. Dette er greit å vite om da bruken ofte er mer omfattende enn vanlig privat bruk."
            ),
            SelfDeclarationItemViewModel(
                question: "Bilen er eller har vært chiptrimmet",
                answer: "Vet ikke",
                explanation: "Dersom svaret er JA her trenger ikke dette å være negativt, men det er viktig å være klar over og lurt å undersøke. Det finnes mange måter å optimalisere eller trimme en motor på, men enkelte metoder gjør at garantier og lignende kan bortfalle eller at forsikringen ikke er dekkende hvis trimmingen ikke er oppgitt til forsikringsselskapet."
            ),
            SelfDeclarationItemViewModel(
                question: "Bilen har hatt en større kollisjonsskade",
                answer: "Ja",
                explanation: "Hvis svaret er JA her, burde du be selger for dokumentasjon på hvor og hvordan skaden har blitt reparert. Dette er fordi det kan ofte knyttes usikkerhet til om skaden er fullstendig utbedret eller ikke. "
            )
        ]
        return SelfDeclarationViewModel(introduction: introduction, items: items)
    }()
}
