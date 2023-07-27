//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class ContactFormDemoView: UIView {

    private lazy var contactFormView: ContactFormView = {
        let view = ContactFormView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contactFormView)
        contactFormView.fillInSuperview()
    }
}

extension ContactFormDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case fullNameAndPhoneNumberNotRequired
        case phoneNumberRequired
        case fullNameRequired
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .fullNameAndPhoneNumberNotRequired:
            contactFormView.configure(with: ViewModel())
            contactFormView.setNeedsLayout()
        case .phoneNumberRequired:
            var viewModel = ViewModel()
            viewModel.phoneNumberRequired = true
            contactFormView.configure(with: viewModel)
            contactFormView.setNeedsLayout()
        case .fullNameRequired:
            var viewModel = ViewModel()
            viewModel.phoneNumberRequired = false
            viewModel.fullNameRequired = true
            viewModel.nameErrorHelpText = "Navn må bestå av fornavn og etternavn"
            contactFormView.configure(with: viewModel)
            contactFormView.setNeedsLayout()
        }
    }
}

// MARK: - ContactFormViewDelegate

extension ContactFormDemoView: ContactFormViewDelegate {
    func contactFormView(_ view: ContactFormView, didSubmitWithName name: String, email: String, phoneNumber: String?) {
        print("Name: \(name), email: \(email), phone number: \(phoneNumber ?? "-")")
    }

    func contactFormViewDidTapDisclaimerButton(_ view: ContactFormView) {}
}

// MARK: - Private types

private struct ViewModel: ContactFormViewModel {
    let title = "Motta oppdateringer om Elveparken, Jessheim Sør"
    let detailText = "FINN.no videreformidler denne informasjonen til denne annonsens kontaktperson slik at de kan holde deg fortløpende orientert om prosjektet."
    let namePlaceholder = "Navn"
    let emailPlaceholder = "E-post"
    let showPhoneNumberQuestion = "Vil du også bli kontaktet på telefon?"
    let showPhoneNumberAnswer = "Ja takk"
    let phoneNumberPlaceholder = "Telefonnummer"
    let submitButtonTitle = "Kjør på!"
    var emailErrorHelpText = "Oppgi en gyldig e-postadresse."
    var phoneNumberErrorHelpText = "Oppgi et gyldig telefonnummer"
    var disclaimerText = "Ved å legge inn din e-postadresse og ditt telefonnummer samtykker du til å motta e-poster samt eventuell henvendelse på telefon om boligprosjektet. Megler/utbygger blir selvstendig behandlingsansvarlig for personinformasjonen de mottar."
    var disclaimerReadMoreButtonTitle = "Les mer"
    var phoneNumberRequired = false
    var fullNameRequired = false
    var nameErrorHelpText: String?
}
