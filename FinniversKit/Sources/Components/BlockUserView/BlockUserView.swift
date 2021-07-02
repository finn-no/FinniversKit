//
//  BlockUserView.swift
//  FinniversKit
//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public protocol BlockUserViewDelegate: AnyObject {
    func blockUserViewDidTapCancel()
    func blockUserViewDidTapBlock(reason: Int)
    func blockUserViewDidTapLink()
}

public class BlockUserView: UIView {

    // MARK: - Private properties

    private lazy var title: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitle: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    lazy var radio: RadioButton = {
        let radio = RadioButton()
        radio.translatesAutoresizingMaskIntoConstraints = false
        radio.delegate = self
        return radio
    }()

    private lazy var info: Label = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var link: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(linkAction), for: .touchUpInside)
        return button
    }()

    private lazy var cancel: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()

    private lazy var block: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(blockAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    public weak var delegate: BlockUserViewDelegate?

    private var viewModel: BlockUserViewModel? {
        didSet {
            title.text = viewModel?.title
            subtitle.text = viewModel?.subtitle
            radio.fields = viewModel?.reasons ?? []
            info.text = viewModel?.info

            link.setTitle(viewModel?.link, for: .normal)
            cancel.setTitle(viewModel?.cancel, for: .normal)
            block.setTitle(viewModel?.block, for: .normal)
        }
    }

    // MARK: - Init

    public init(viewModel: BlockUserViewModel) {
        defer {
            self.viewModel = viewModel
        }

        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(title)
        addSubview(subtitle)
        addSubview(radio)
        addSubview(info)
        addSubview(link)
        addSubview(cancel)
        addSubview(block)

        let dot = Label(style: .caption, withAutoLayout: true)
        dot.text = "."

        addSubview(dot)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL + .spacingS),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingM),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .spacingXS),
            subtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL + .spacingS),
            subtitle.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -.spacingXXL
            ),

            radio.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: .spacingXS),
            radio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),

            info.topAnchor.constraint(equalTo: radio.bottomAnchor, constant: .spacingXS),
            info.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL + .spacingS),
            info.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -.spacingL
            ),

            link.topAnchor.constraint(equalTo: info.bottomAnchor, constant: -.spacingXS),
            link.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL + .spacingS),

            dot.centerYAnchor.constraint(equalTo: link.centerYAnchor, constant: 1),
            dot.leadingAnchor.constraint(equalTo: link.trailingAnchor, constant: -.spacingXXS),

            cancel.topAnchor.constraint(equalTo: block.topAnchor),
            cancel.trailingAnchor.constraint(equalTo: block.leadingAnchor, constant: -.spacingXS),

            block.topAnchor.constraint(equalTo: link.bottomAnchor, constant: .spacingM),
            UIDevice.isIPhone() ? block.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL - .spacingS)
            : block.leadingAnchor.constraint(equalTo: link.trailingAnchor, constant: .spacingXXL + .spacingXL + .spacingL)
        ])

    }

    // MARK: - Actions

    @objc private func cancelAction() {
        delegate?.blockUserViewDidTapCancel()
    }

    @objc private func blockAction() {
        delegate?.blockUserViewDidTapBlock(reason: radio.selectedItem?.index ?? -1)
    }

    @objc private func linkAction() {
        delegate?.blockUserViewDidTapLink()
    }
}

// MARK: - Radio Button Delegate

extension BlockUserView: RadioButtonDelegate {

    public func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem) {
        block.isEnabled = true
    }
    public func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem) {
        block.isEnabled = false
    }
}
