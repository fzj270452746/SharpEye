import UIKit

class ZephyrTileCell: UICollectionViewCell {
    static let reuseID = "ZephyrTileCell"

    let tileImageView = UIImageView()
    let haloView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }

    func configureCell() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0
        
        haloView.translatesAutoresizingMaskIntoConstraints = false
        haloView.layer.cornerRadius = 10
        haloView.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        haloView.isHidden = true

        tileImageView.translatesAutoresizingMaskIntoConstraints = false
        tileImageView.contentMode = .scaleAspectFit
        tileImageView.layer.cornerRadius = 8
        tileImageView.layer.masksToBounds = true

        contentView.addSubview(haloView)
        contentView.addSubview(tileImageView)

        NSLayoutConstraint.activate([
            haloView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            haloView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            haloView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            haloView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            tileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            tileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            tileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            tileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    func configure(with model: SharpEyeModel, highlighted: Bool) {
        tileImageView.image = model.tileImage
        
        if highlighted {
            contentView.layer.borderWidth = 5
            contentView.layer.borderColor = model.tribe.accentColor.cgColor
            contentView.backgroundColor = model.tribe.accentColor.withAlphaComponent(0.25)
            haloView.backgroundColor = model.tribe.accentColor.withAlphaComponent(0.4)
            haloView.isHidden = false
            animatePulse()
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            haloView.isHidden = true
            contentView.layer.removeAllAnimations()
            contentView.transform = .identity
        }
    }

    func animatePulse() {
        UIView.animate(withDuration: 0.18, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.contentView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        } completion: { _ in
            UIView.animate(withDuration: 0.18, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
                self.contentView.transform = .identity
            }
        }
    }
}

