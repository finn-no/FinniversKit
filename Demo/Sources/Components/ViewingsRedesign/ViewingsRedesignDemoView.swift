import UIKit
import FinniversKit

class ViewingsRedesignDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "demoModel", action: { [weak self] in
            self?.configure(with: .demoModel)
        }),
        TweakingOption(title: "Only MoreInfo", action: { [weak self] in
            self?.configure(with: .onlyMoreInfo)
        }),
        TweakingOption(title: "Only ProspectusButton", action: { [weak self] in
            self?.configure(with: .onlyProspectusButton)
        }),
        TweakingOption(title: "Only ViewingSignup", action: { [weak self] in
            self?.configure(with: .onlyViewingSignup)
        }),
        TweakingOption(title: "Without Viewings", action: { [weak self] in
            self?.configure(with: .withoutViewings)
        }),
        TweakingOption(title: "Without MoreInfo", action: { [weak self] in
            self?.configure(with: .withoutMoreInfo)
        }),
        TweakingOption(title: "Without Prospectus", action: { [weak self] in
            self?.configure(with: .withoutProspectus)
        }),
        TweakingOption(title: "Without SignupButton", action: { [weak self] in
            self?.configure(with: .withoutSignupButton)
        }),
        TweakingOption(title: "Empty", action: { [weak self] in
            self?.configure(with: .empty)
        }),
    ]

    // MARK: - Private properties

    private var viewingsView: ViewingsRedesignView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func configure(with model: ViewingsRedesignViewModel) {
        viewingsView?.removeFromSuperview()

        let viewingsView = ViewingsRedesignView(viewModel: model, delegate: self, withAutoLayout: true)

        addSubview(viewingsView)
        NSLayoutConstraint.activate([
            viewingsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            viewingsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            viewingsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        self.viewingsView = viewingsView
    }
}

// MARK: - ViewingsRedesignViewDelegate

extension ViewingsRedesignDemoView: ViewingsRedesignViewDelegate {
    func viewingsRedesignView(_ view: ViewingsRedesignView, didSelectButton selectedButton: ViewingsRedesignView.SelectedButton) {
        switch selectedButton {
        case .prospectus:
            print("👉 Prospectus was selected")
        case .viewingSignup:
            print("👉 Viewing signup was selected")
        case .viewing(let index):
            print("👉 Selected viewing at index \(index)")
        }
    }
}

// MARK: - Private extensions

private extension ViewingsRedesignViewModel {
    static var demoModel: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: "Visning",
            viewings: [
                .init(weekday: "Fredag", month: "JAN", day: "13", timeInterval: "Kl. 16.00 - 17.00", note: nil),
                .init(weekday: "Lørdag", month: "JAN", day: "14", timeInterval: "Kl. 16.00 - 17.00", note: "Langt notat som ikke gir veldig mye mening, men jeg tar det med så vi får sett hvordan viewet oppfører seg når det kommer en lang tekst."),
                .init(weekday: "Søndag", month: "JAN", day: "15", timeInterval: "Kl. 17.00 - 18.00", note: "Også et kort notat"),
            ],
            moreInfoText: "Vil du komme på visning? Trykk på 'Visningspåmelding' eller kontakt megler på telefon/mail for å avtale tidspunkt, senest kl. 12 på visningsdagen. Annonserte visninger uten påmeldinger vil ikke bli avholdt.",
            prospectusButton: .init(
                title: "Husk å lese komplett salgsoppgave før visning.",
                description: "Bestill komplett, utskriftsvennlig salgsoppgave",
                url: "https://finn.no"
            ),
            viewingSignupButton: .init(title: "Visningspåmelding", url: "https://finn.no"),
            addToCalendarButtonTitle: "Legg til i kalender"
        )
    }

    static var onlyMoreInfo: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: [],
            moreInfoText: demoModel.moreInfoText,
            prospectusButton: nil,
            viewingSignupButton: nil,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var onlyProspectusButton: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: [],
            moreInfoText: nil,
            prospectusButton: demoModel.prospectusButton,
            viewingSignupButton: nil,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var onlyViewingSignup: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: [],
            moreInfoText: nil,
            prospectusButton: nil,
            viewingSignupButton: demoModel.viewingSignupButton,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var withoutViewings: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: [],
            moreInfoText: demoModel.moreInfoText,
            prospectusButton: demoModel.prospectusButton,
            viewingSignupButton: demoModel.viewingSignupButton,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var withoutMoreInfo: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: demoModel.viewings,
            moreInfoText: nil,
            prospectusButton: demoModel.prospectusButton,
            viewingSignupButton: demoModel.viewingSignupButton,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var withoutProspectus: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: demoModel.viewings,
            moreInfoText: demoModel.moreInfoText,
            prospectusButton: nil,
            viewingSignupButton: demoModel.viewingSignupButton,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var withoutSignupButton: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: demoModel.viewings,
            moreInfoText: demoModel.moreInfoText,
            prospectusButton: demoModel.prospectusButton,
            viewingSignupButton: nil,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }

    static var empty: ViewingsRedesignViewModel {
        ViewingsRedesignViewModel(
            title: demoModel.title,
            viewings: [],
            moreInfoText: nil,
            prospectusButton: nil,
            viewingSignupButton: nil,
            addToCalendarButtonTitle: demoModel.addToCalendarButtonTitle
        )
    }
}
