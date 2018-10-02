//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

class ConsentViewDemoView: UIView {

    private let detailModel = ConsentViewModel(title: "Få nyhetsbrev fra FINN", text: "FINN sender deg nyhetsbrev med for eksempel reisetips, jobbtrender, morsomme konkurranser og smarte råd til deg som kjøper og selger.\nFor å gjøre dette bruker vi kontaktinformasjonen knyttet til brukeren din på FINN.", buttonTitle: "Les Mer", buttonStyle: .flat, indexPath: IndexPath(row: 0, section: 0))

    private lazy var consentDetailView: ConsentView = {
        let view = ConsentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.model = detailModel
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(consentDetailView)
        consentDetailView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
