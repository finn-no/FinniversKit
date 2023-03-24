//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class LabelDemoView: UIView {
    private lazy var labelLinkTap = Label(style: .detail, withAutoLayout: true)

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
        let labelBodyStrong = Label(style: .bodyStrong)
        let labelDetailStrong = Label(style: .detailStrong)
        let labelCaptionStrong = Label(style: .captionStrong)
        let labelCaption = Label(style: .caption)
        let labelBody = Label(style: .body)
        let labelDetail = Label(style: .detail)

        let testStyle: Label.Style = .body
        let multilineLabel = Label(style: testStyle)
        let label1 = Label(style: testStyle)
        let label2 = Label(style: testStyle)
        let label3 = Label(style: testStyle)
        let labelWide = Label(style: .body)

        let labelWithLink = Label(style: .body)
        let labelWithCustomLink = Label(style: .body)
        let labelWithTwoLinks = Label(style: .body)
        [labelWithLink, labelWithCustomLink, labelWithTwoLinks].forEach {
            $0.isUserInteractionEnabled = true
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.linkDelegate = self
        }

        labelT1.translatesAutoresizingMaskIntoConstraints = false
        labelT2.translatesAutoresizingMaskIntoConstraints = false
        labelT3.translatesAutoresizingMaskIntoConstraints = false
        labelBodyStrong.translatesAutoresizingMaskIntoConstraints = false
        labelDetailStrong.translatesAutoresizingMaskIntoConstraints = false
        labelCaptionStrong.translatesAutoresizingMaskIntoConstraints = false
        labelCaption.translatesAutoresizingMaskIntoConstraints = false
        labelBody.translatesAutoresizingMaskIntoConstraints = false
        labelDetail.translatesAutoresizingMaskIntoConstraints = false

        multilineLabel.translatesAutoresizingMaskIntoConstraints = false
        multilineLabel.numberOfLines = 0
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        labelWide.translatesAutoresizingMaskIntoConstraints = false
        labelWide.backgroundColor = .bgSuccess
        labelWide.textColor = .textToast
        labelWide.textAlignment = .center

        addSubview(labelT1)
        addSubview(labelT2)
        addSubview(labelT3)
        addSubview(labelBodyStrong)
        addSubview(labelDetailStrong)
        addSubview(labelCaptionStrong)
        addSubview(labelCaption)
        addSubview(labelBody)
        addSubview(labelDetail)

        addSubview(multilineLabel)
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        addSubview(labelWide)

        addSubview(labelWithLink)
        addSubview(labelWithCustomLink)
        addSubview(labelWithTwoLinks)
        addSubview(labelLinkTap)

        NSLayoutConstraint.activate([
            labelT1.topAnchor.constraint(equalTo: topAnchor, constant: topSpacing),
            labelT1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),

            labelT2.topAnchor.constraint(equalTo: labelT1.bottomAnchor, constant: interimSpacing),
            labelT2.leadingAnchor.constraint(equalTo: labelT1.leadingAnchor),

            labelT3.topAnchor.constraint(equalTo: labelT2.bottomAnchor, constant: interimSpacing),
            labelT3.leadingAnchor.constraint(equalTo: labelT2.leadingAnchor),

            labelBodyStrong.topAnchor.constraint(equalTo: labelT3.bottomAnchor, constant: interimSpacing),
            labelBodyStrong.leadingAnchor.constraint(equalTo: labelT3.leadingAnchor),

            labelDetailStrong.topAnchor.constraint(equalTo: labelBodyStrong.bottomAnchor, constant: interimSpacing),
            labelDetailStrong.leadingAnchor.constraint(equalTo: labelBodyStrong.leadingAnchor),

            labelCaptionStrong.topAnchor.constraint(equalTo: labelDetailStrong.bottomAnchor, constant: interimSpacing),
            labelCaptionStrong.leadingAnchor.constraint(equalTo: labelDetailStrong.leadingAnchor),

            labelCaption.topAnchor.constraint(equalTo: labelCaptionStrong.bottomAnchor, constant: interimSpacing),
            labelCaption.leadingAnchor.constraint(equalTo: labelCaptionStrong.leadingAnchor),

            labelBody.topAnchor.constraint(equalTo: labelCaption.bottomAnchor, constant: interimSpacing),
            labelBody.leadingAnchor.constraint(equalTo: labelCaption.leadingAnchor),

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

            labelWithLink.topAnchor.constraint(equalTo: labelWide.bottomAnchor, constant: topSpacing),
            labelWithLink.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            labelWithLink.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingM),

            labelWithCustomLink.topAnchor.constraint(equalTo: labelWithLink.bottomAnchor, constant: topSpacing),
            labelWithCustomLink.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            labelWithCustomLink.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingM),

            labelWithTwoLinks.topAnchor.constraint(equalTo: labelWithCustomLink.bottomAnchor, constant: topSpacing),
            labelWithTwoLinks.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            labelWithTwoLinks.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            labelLinkTap.topAnchor.constraint(equalTo: labelWithTwoLinks.bottomAnchor, constant: topSpacing),
            labelLinkTap.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            labelLinkTap.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])

        label1.text = "Test"
        label2.text = "Test"
        label3.text = "Test"
        multilineLabel.text = "Test Test Test"
        labelWide.text = "Test center"

        labelT1.text = "Label Title1"
        labelT2.text = "Label Title2"
        labelT3.text = "Label Title3"
        labelBodyStrong.text = "Label Body Strong"
        labelDetailStrong.text = "Label Detail Strong"
        labelCaptionStrong.text = "Label Caption Strong"
        labelCaption.text = "Label Caption"
        labelBody.text = "Label Body"
        labelDetail.text = "Label Detail"

        let attributedLink = NSAttributedString(string: "first example link", attributes: [
            .link: URL(string: "https://finn.no")!
        ])
        let attributedCustomLink = NSAttributedString(string: "second example link", attributes: [
            .foregroundColor: UIColor.red,
            .linkCustom: "linkCustom"
        ])

        let labelWithLinkText = NSMutableAttributedString(string: "This is the ")
        labelWithLinkText.append(attributedLink)
        labelWithLink.attributedText = labelWithLinkText

        let labelWithCustomLinkText = NSMutableAttributedString(string: "This is the ")
        labelWithCustomLinkText.append(attributedCustomLink)
        labelWithCustomLink.attributedText = labelWithCustomLinkText

        let labelWithTwoLinksText = NSMutableAttributedString(string: "This is the ")
        labelWithTwoLinksText.append(attributedLink)
        labelWithTwoLinksText.append(NSAttributedString(string: ", and this is the "))
        labelWithTwoLinksText.append(attributedCustomLink)
        labelWithTwoLinks.attributedText = labelWithTwoLinksText

        labelLinkTap.text = "Link tap:"
    }
}

extension LabelDemoView: LabelLinkDelegate {
    public func labelDidTapLink(_ label: Label, kind: LabelLinkKind) {
        let text: String
        switch kind {
        case .text(let linkText):
            text = linkText
        case .url(let url):
            text = url.absoluteString
        }
        labelLinkTap.text = "Link tap: \(text)"
    }
}
