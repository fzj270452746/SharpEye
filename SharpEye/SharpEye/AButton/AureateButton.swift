import UIKit

class AureateButton: UIButton {
    let gradientLayer = CAGradientLayer()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }

    func setupAppearance() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .left
        contentHorizontalAlignment = .leading
        blurView.isUserInteractionEnabled = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        gradientLayer.colors = [
            UIColor(red: 0.95, green: 0.72, blue: 0.32, alpha: 0.3).cgColor,
            UIColor(red: 0.75, green: 0.29, blue: 0.47, alpha: 0.3).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
        alpha = 0.95
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func configure(with title: String,
                   subtitle: String? = nil,
                   icon: String? = nil,
                   customImageName: String? = nil,
                   allowSystemIcon: Bool = true) {
        let mutableTitle = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ])
        if let subtitleText = subtitle {
            let newline = "\n\(subtitleText)"
            let attributedSubtitle = NSAttributedString(string: newline, attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(0.82)
            ])
            mutableTitle.append(attributedSubtitle)
        }
        setAttributedTitle(mutableTitle, for: .normal)

        // 优先使用自定义图片
        if let imageName = customImageName,
           let customImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            setImage(customImage, for: .normal)
            tintColor = .white
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        } else if allowSystemIcon, let iconName = icon {
            setImage(UIImage(systemName: iconName), for: .normal)
            tintColor = .white
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        } else {
            setImage(nil, for: .normal)
        }
    }
}

