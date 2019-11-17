//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import Sandbox

public class ContactFormDemoView: UIView, Tweakable {

    public lazy var tweakingOptions: [TweakingOption] = {
        let options = [
            TweakingOption(title: "Full name and phone number not required", action: {
                self.contactFormView.configure(with: ViewModel())
                self.contactFormView.setNeedsLayout()
            }),
            TweakingOption(title: "Phone number required", action: {
                var viewModel = ViewModel()
                viewModel.phoneNumberRequired = true
                self.contactFormView.configure(with: viewModel)
                self.contactFormView.setNeedsLayout()
            }),
            TweakingOption(title: "Full name required", action: {
                var viewModel = ViewModel()
                viewModel.phoneNumberRequired = false
                viewModel.fullNameRequired = true
                viewModel.nameErrorHelpText = "Navn må bestå av fornavn og etternavn"
                self.contactFormView.configure(with: viewModel)
                self.contactFormView.setNeedsLayout()
            }),
        ]
        return options
    }()

    private lazy var contactFormView: ContactFormView = {
        let view = ContactFormView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: ViewModel())
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contactFormView)
        contactFormView.fillInSuperview()
    }
}

// MARK: - ContactFormViewDelegate

extension ContactFormDemoView: ContactFormViewDelegate {
    public func contactFormView(_ view: ContactFormView, didSubmitWithName name: String, email: String, phoneNumber: String?) {
        print("Name: \(name), email: \(email), phone number: \(phoneNumber ?? "-")")
    }

    public func contactFormViewDidTapDisclaimerButton(_ view: ContactFormView) {}
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
