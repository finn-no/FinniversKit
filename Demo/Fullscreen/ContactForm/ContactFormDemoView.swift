//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ContactFormDemoView: UIView {
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
}
