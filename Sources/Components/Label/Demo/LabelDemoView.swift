//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class LabelDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let topSpacing: CGFloat = 32
        let margin: CGFloat = 16
        let interimSpacing: CGFloat = 0

        let labelT1 = Label(style: .title1)
        let labelT2 = Label(style: .title2)
        let labelT3 = Label(style: .title3)
        let labelT4 = Label(style: .title4(.licorice))
        let labelT5 = Label(style: .title5(.licorice))
        let labelBody = Label(style: .body(.licorice))
        let labelDetail = Label(style: .detail(.licorice))

        let testStyle: Label.Style = .body(.licorice)
        let multilineLabel = Label(style: testStyle)
        let label1 = Label(style: testStyle)
        let label2 = Label(style: testStyle)
        let label3 = Label(style: testStyle)
        let labelWide = Label(style: .body(.licorice))

        labelT1.translatesAutoresizingMaskIntoConstraints = false
        labelT2.translatesAutoresizingMaskIntoConstraints = false
        labelT3.translatesAutoresizingMaskIntoConstraints = false
        labelT4.translatesAutoresizingMaskIntoConstraints = false
        labelT5.translatesAutoresizingMaskIntoConstraints = false
        labelBody.translatesAutoresizingMaskIntoConstraints = false
        labelDetail.translatesAutoresizingMaskIntoConstraints = false

        multilineLabel.translatesAutoresizingMaskIntoConstraints = false
        multilineLabel.numberOfLines = 0
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        labelWide.translatesAutoresizingMaskIntoConstraints = false
        labelWide.backgroundColor = .mint
        labelWide.textAlignment = .center

        addSubview(labelT1)
        addSubview(labelT2)
        addSubview(labelT3)
        addSubview(labelT4)
        addSubview(labelT5)
        addSubview(labelBody)
        addSubview(labelDetail)

        addSubview(multilineLabel)
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        addSubview(labelWide)

        NSLayoutConstraint.activate([
            labelT1.topAnchor.constraint(equalTo: topAnchor, constant: topSpacing),
            labelT1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),

            labelT2.topAnchor.constraint(equalTo: labelT1.bottomAnchor, constant: interimSpacing),
            labelT2.leadingAnchor.constraint(equalTo: labelT1.leadingAnchor),

            labelT3.topAnchor.constraint(equalTo: labelT2.bottomAnchor, constant: interimSpacing),
            labelT3.leadingAnchor.constraint(equalTo: labelT2.leadingAnchor),

            labelT4.topAnchor.constraint(equalTo: labelT3.bottomAnchor, constant: interimSpacing),
            labelT4.leadingAnchor.constraint(equalTo: labelT3.leadingAnchor),

            labelT5.topAnchor.constraint(equalTo: labelT4.bottomAnchor, constant: interimSpacing),
            labelT5.leadingAnchor.constraint(equalTo: labelT4.leadingAnchor),

            labelBody.topAnchor.constraint(equalTo: labelT5.bottomAnchor, constant: interimSpacing),
            labelBody.leadingAnchor.constraint(equalTo: labelT5.leadingAnchor),

            labelDetail.topAnchor.constraint(equalTo: labelBody.bottomAnchor, constant: interimSpacing),
            labelDetail.leadingAnchor.constraint(equalTo: labelBody.leadingAnchor),

            label1.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: topSpacing),
            label1.leadingAnchor.constraint(equalTo: labelDetail.leadingAnchor),

            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor),

            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 0),
            label3.leadingAnchor.constraint(equalTo: label2.leadingAnchor),

            multilineLabel.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 4),
            multilineLabel.topAnchor.constraint(equalTo: label1.topAnchor),
            multilineLabel.widthAnchor.constraint(equalToConstant: 50), // used to force a linebreak

            labelWide.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 16),
            labelWide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelWide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelWide.heightAnchor.constraint(equalToConstant: 40),
        ])

        label1.text = "Test"
        label2.text = "Test"
        label3.text = "Test"
        multilineLabel.text = "Test Test Test"
        labelWide.text = "Test center"

        labelT1.text = "Label Title1"
        labelT2.text = "Label Title2"
        labelT3.text = "Label Title3"
        labelT4.text = "Label Title4"
        labelT5.text = "Label Title5"
        labelBody.text = "Label Body"
        labelDetail.text = "Label Detail"
    }
}
