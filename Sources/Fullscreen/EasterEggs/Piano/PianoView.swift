//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit
import AVFoundation

public final class PianoView: UIView {
    private let notes: [UInt8] = {
        let octave: UInt8 = 5
        let root: UInt8 = octave * 12
        let numberOfNotesInOctave: UInt8 = 12
        return (0..<numberOfNotesInOctave).map({ root + $0 })
    }()

    private lazy var sampler = AVAudioUnitSampler()

    private lazy var audioEngine: AVAudioEngine = {
        let audioEngine = AVAudioEngine()

        audioEngine.attach(reverb)
        audioEngine.attach(distortion)
        audioEngine.attach(sampler)

        audioEngine.connect(sampler, to: reverb, format: nil)
        audioEngine.connect(reverb, to: distortion, format: nil)
        audioEngine.connect(distortion, to: audioEngine.mainMixerNode, format: nil)

        return audioEngine
    }()

    private lazy var reverb: AVAudioUnitReverb = {
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.cathedral)
        reverb.wetDryMix = 0
        return reverb
    }()

    private lazy var distortion: AVAudioUnitDistortion = {
        let distortion = AVAudioUnitDistortion()
        distortion.loadFactoryPreset(.multiBrokenSpeaker)
        distortion.wetDryMix = 0
        return distortion
    }()

    // MARK: - Views

    private lazy var pianoView: PianoKeyboardView = {
        let pianoView = PianoKeyboardView(withAutoLayout: true)
        pianoView.dataSource = self
        pianoView.delegate = self
        return pianoView
    }()

    private lazy var reverbView: PianoEffectView = {
        let view = PianoEffectView(withAutoLayout: true)
        view.titleLabel.text = "reverb"
        view.control.sliderColor = UIColor(r: 50, g: 162, b: 255)
        view.control.delegate = self
        return view
    }()

    private lazy var distortionView: PianoEffectView = {
        let view = PianoEffectView(withAutoLayout: true)
        view.titleLabel.text = "distortion"
        view.control.sliderColor = UIColor(r: 255, g: 75, b: 0)
        view.control.delegate = self
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        loadSoundBankInstrument()
        startAudio()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor(r: 216, g: 219, b: 227)

        addSubview(reverbView)
        addSubview(distortionView)
        addSubview(pianoView)

        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let reverbYAnchor = isPad
            ? reverbView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -.veryLargeSpacing)
            : reverbView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing)
        let pianoTopConstant: CGFloat = isPad ? .veryLargeSpacing : .mediumLargeSpacing

        NSLayoutConstraint.activate([
            reverbYAnchor,
            reverbView.trailingAnchor.constraint(equalTo: pianoView.centerXAnchor),

            distortionView.topAnchor.constraint(equalTo: reverbView.topAnchor),
            distortionView.leadingAnchor.constraint(equalTo: reverbView.trailingAnchor, constant: 55),
            distortionView.heightAnchor.constraint(equalTo: reverbView.heightAnchor),

            pianoView.topAnchor.constraint(equalTo: reverbView.bottomAnchor, constant: pianoTopConstant),
            pianoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pianoView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            pianoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing)
        ])

        pianoView.reloadData()
    }

    // MARK: - Audio

    private func loadSoundBankInstrument() {
        guard let url = Bundle.finniversKit.url(forResource: "Piano", withExtension: ".sf2") else {
            print("Failed to load sound bank instrument")
            return
        }

        do {
            let bankMSB = UInt8(kAUSampler_DefaultMelodicBankMSB)
            let bankLSB = UInt8(kAUSampler_DefaultBankLSB)
            try sampler.loadSoundBankInstrument(at: url, program: 0, bankMSB: bankMSB, bankLSB: bankLSB)
        } catch {
            print(error)
        }
    }

    private func startAudio() {
        let audioSession = AVAudioSession.sharedInstance()

        // start engine, set up audio session
        do {
            try audioEngine.start()
            try audioSession.swift_setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("set up failed")
            return
        }
    }
}

// MARK: - PianoKeyboardViewDataSource

extension PianoView: PianoKeyboardViewDataSource {
    func pianoKeyboardViewNumberOfKeyViews(_ pianoView: PianoKeyboardView) -> Int {
        return notes.count
    }
}

// MARK: - PianoKeyboardViewDelegates

extension PianoView: PianoKeyboardViewDelegate {
    func pianoKeyboardView(_ pianoView: PianoKeyboardView, didSelectKeyViewAt index: Int) {
        let note = notes[index]
        sampler.startNote(note, withVelocity: 120, onChannel: 0)
    }

    func pianoKeyboardView(_ pianoView: PianoKeyboardView, didDeselectKeyViewAt index: Int) {
        let note = notes[index]
        sampler.stopNote(note, onChannel: 0)
    }
}

// MARK: - PianoEffectControlDelegate

extension PianoView: PianoEffectControlDelegate {
    func pianoEffectControl(_ control: PianoEffectControl, didChangeValue value: Float) {
        if control == reverbView.control {
            reverb.wetDryMix = value * 100
        } else if control == distortionView.control {
            distortion.wetDryMix = value * 100
        }
    }
}
