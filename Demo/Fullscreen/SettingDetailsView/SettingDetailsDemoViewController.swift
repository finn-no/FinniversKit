//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct DemoViewModel: SettingDetailsViewModel {
    var icon: UIImage {
        return UIImage(named: "nyhetsbrev-fra-finn")!
    }

    var title: String {
        return "Nyhetsbrev fra FINN"
    }

    var primaryButtonStyle: Button.Style {
        return .callToAction
    }

    var primaryButtonTitle: String {
        return "Skru på nyhetsbrev"
    }

    func text(for state: SettingDetailsView.State) -> String {
        switch state {
        case .lessDetails:
            return "FINN sender deg nyhetsbrev med for eksempel reisetips, jobbtrender, morsomme konkurranser og smarte råd til deg som kjøper og selger. For å gjøre dette bruker vi kontakt-informasjonen knyttet til brukeren din på FINN."
        case .moreDetails:
            return "Formål\nVi ønsker å tilby bedre tjenester gjennom å gi deg mer relevant innhold. Dette kan f.eks være tjenester som anbefalinger på forsiden av FINN, FINN-annonser du har gått glipp av kan vises på andre nettsteder som VG, Facebook, etc., sortering av søkeresultat, mm.\n\nHvilke data trenger vi?\nFor å kunne lage slike tjenester trenger vi å lagre data om din bruk av FINN. Dette vil typisk være hvilke annonser du har vist interesse for, din søkehistorikk, stedsinformasjon og lignende.\n\nHvordan virker dette?\nVi bruker ditt bruksmønster til å finne tilsvarende bruksmønster fra andre brukere på FINN, for å kunne anbefale deg det de har vist interesse for. Du vil ikke kunne bli identifisert gjennom dataene vi lagrer, og vi deler heller ikke disse dataene med andre."
        }
    }

    func textAlignment(for state: SettingDetailsView.State) -> NSTextAlignment {
        switch state {
        case .lessDetails: return .center
        case .moreDetails: return .left
        }
    }

    func secondaryButtonTitle(for state: SettingDetailsView.State) -> String? {
        switch state {
        case .lessDetails: return "Les mer"
        case .moreDetails: return "Les mindre"
        }
    }
}

final class SettingDetailsDemoViewController: UIViewController {

    private lazy var settingDetailsView: SettingDetailsView = {
        let detailsView = SettingDetailsView(withAutoLayout: true)
        detailsView.configure(with: DemoViewModel())
        detailsView.delegate = self
        return detailsView
    }()

    weak var bottomSheet: BottomSheet?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingDetailsView)
        settingDetailsView.fillInSuperview()
    }

    var contentSize: CGSize {
        CGSize(
            width: settingDetailsView.intrinsicContentSize.width,
            height: settingDetailsView.intrinsicContentSize.height + 20
        )
    }
}

extension SettingDetailsDemoViewController: SettingDetailsViewDelegate {
    func settingDetailsView(_ detailsView: SettingDetailsView, didChangeTo state: SettingDetailsView.State, with model: SettingDetailsViewModel) {
        view.layoutIfNeeded()
        let contentHeight = contentSize.height
        let height = min(contentHeight, BottomSheet.Height.defaultFilterHeight.expanded)
        bottomSheet?.height = .init(compact: height, expanded: height)
    }

    func settingDetailsView(_ detailsView: SettingDetailsView, didTapPrimaryButtonWith model: SettingDetailsViewModel) {
        print("Did tap action button with model:\n\t- \(model)")
    }
}
