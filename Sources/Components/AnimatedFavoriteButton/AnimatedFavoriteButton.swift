import UIKit
import AVFoundation

public class AnimatedFavoriteButton: UIView {
    public private(set) var isSelected: Bool = false

    private lazy var nonSelected: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: .favoriteAdd)
        imageView.alpha = 0
        return imageView
    }()

    private lazy var selected: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: .favouriteAdded)
        imageView.alpha = 0
        return imageView
    }()

    private lazy var audioPlayer: AVAudioPlayer? = {
        let url = Bundle.finniversKit.url(forResource: "favorite-sound", withExtension: "mp3")
        let player = url.flatMap({ try? AVAudioPlayer(contentsOf: $0) })
        player?.volume = 0.8
        return player
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(nonSelected)
        NSLayoutConstraint.activate([
            nonSelected.topAnchor.constraint(equalTo: topAnchor),
            nonSelected.bottomAnchor.constraint(equalTo: bottomAnchor),
            nonSelected.leadingAnchor.constraint(equalTo: leadingAnchor),
            nonSelected.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

        addSubview(selected)
        NSLayoutConstraint.activate([
            selected.topAnchor.constraint(equalTo: topAnchor),
            selected.bottomAnchor.constraint(equalTo: bottomAnchor),
            selected.leadingAnchor.constraint(equalTo: leadingAnchor),
            selected.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        addGestureRecognizer(tapGesture)

        selected.alpha = isSelected ? 1 : 0
        nonSelected.alpha = isSelected ? 0 : 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @objc func buttonTapped() {
        if isSelected {
            isSelected = false

            UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                self.selected.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.selected.alpha = 0
                self.nonSelected.alpha = 1
            }, completion: nil)
        } else {
            isSelected = true

            audioPlayer?.currentTime = 0
            audioPlayer?.play()

            UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
                self.nonSelected.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: nil)

            selected.alpha = 0
            selected.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

            UIView.animate(withDuration: 0.15, delay: 0.06, options: .beginFromCurrentState, animations: {
                self.selected.alpha = 1
                self.selected.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.nonSelected.alpha = 0
            }) { _ in

                UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseIn, animations: {
                    self.selected.transform = CGAffineTransform.identity
                    self.nonSelected.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
}
