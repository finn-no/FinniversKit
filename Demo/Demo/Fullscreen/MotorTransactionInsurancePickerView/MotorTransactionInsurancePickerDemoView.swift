import FinnUI

class MotorTransactionInsurancePickerDemoView: UIView {

    private lazy var view = MotorTransactionInsurancePickerView(
        viewModel: InsurancePickerViewModel(),
        withAutoLayout: true
    )

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
        view.delegate = self
    }
}

extension MotorTransactionInsurancePickerDemoView: MotorTransactionInsurancePickerViewDelegate {
    func motorTransactionInsurancePickerView(_ view: MotorTransactionInsurancePickerView, didSelectInsuranceAtIndex index: Int) {
        print("Did select insurance at index \(index)")
    }
}

private struct InsurancePickerViewModel: MotorTransactionInsurancePickerViewModel {
    let title = "Disse selskapene tilbyr deg gratis oppstartsperiode"
    let bodyText = "Du vil bli kontaktet av forsikringsselskapet i løpet av gratisperioden med et tilbud om fortsettelse av forsikringen."

    let insurances: [MotorTransactionInsuranceViewModel] = [
        InsuranceViewModel(
            logo: UIImage(named: .ratingCat),
            companyName: "Forsikring AS",
            bodyTexts: [
                "Kasko med leiebil ● 30 dager til 0 kr ● Egenandel: 4 000 kr",
                "Gjelder for de over 24 år"
            ],
            accessibilityLabel: "Prøv Forsikring AS gratis i 30 dager."
        ),
        InsuranceViewModel(
            logo: UIImage(named: .earthHourEarth),
            companyName: "Grønn forsikring",
            bodyTexts: [
                "Super ● 30 dager til 0 kr ● Egenandel: 4 000 kr",
                "Gjelder for de over 23 år"
            ],
            accessibilityLabel: "Prøv grønn forsikring gratis i 30 dager."
        )
    ]
}

private struct InsuranceViewModel: MotorTransactionInsuranceViewModel {
    let logoImage: UIImage
    let companyName: String
    let bodyTexts: [String]
    let accessibilityLabel: String

    init(logo: UIImage, companyName: String, bodyTexts: [String], accessibilityLabel: String) {
        self.logoImage = logo
        self.companyName = companyName
        self.bodyTexts = bodyTexts
        self.accessibilityLabel = accessibilityLabel
    }
}
