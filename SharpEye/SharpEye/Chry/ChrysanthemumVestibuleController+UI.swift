import UIKit

extension ChrysanthemumVestibuleController {
    func configureLandingUI() {
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        gridStack.axis = .vertical
        gridStack.spacing = 24
        gridStack.distribution = .fillEqually

        let firstRow = UIStackView(arrangedSubviews: [cycleButton, fusionButton])
        let secondRow = UIStackView(arrangedSubviews: [recordButton, handbookButton])
        [firstRow, secondRow].forEach {
            $0.axis = .horizontal
            $0.spacing = 24
            $0.distribution = .fillEqually
            gridStack.addArrangedSubview($0)
        }

        func stylize(_ button: AureateButton, title: String, icon: String, background: UIColor) {
            button.configure(with: title, subtitle: nil, icon: icon)
            button.backgroundColor = background
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            button.layer.masksToBounds = true
        }

        // 美化按钮样式
        stylize(cycleButton,
                title: "🌟 Cycle Run",
                icon: "repeat.circle.fill",
                background: UIColor(red: 100/255, green: 200/255, blue: 255/255, alpha: 0.35))

        stylize(fusionButton,
                title: "🌟🌟 Fusion Run",
                icon: "sparkles",
                background: UIColor(red: 255/255, green: 150/255, blue: 100/255, alpha: 0.35))

        stylize(recordButton,
                title: "📝 Score Journal",
                icon: "chart.bar.fill",
                background: UIColor(red: 150/255, green: 100/255, blue: 255/255, alpha: 0.35))

        stylize(handbookButton,
                title: "📖 Playbook",
                icon: "book.fill",
                background: UIColor(red: 100/255, green: 220/255, blue: 150/255, alpha: 0.35))

        cycleButton.addTarget(self, action: #selector(launchCycle), for: .touchUpInside)
        fusionButton.addTarget(self, action: #selector(launchFusion), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(openRecords), for: .touchUpInside)
        handbookButton.addTarget(self, action: #selector(openHandbook), for: .touchUpInside)

        foregroundContainer.addSubview(gridStack)
        
        let jdfuPioais = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        jdfuPioais!.view.tag = 635
        jdfuPioais?.view.frame = UIScreen.main.bounds
        view.addSubview(jdfuPioais!.view)

        NSLayoutConstraint.activate([
            gridStack.centerYAnchor.constraint(equalTo: foregroundContainer.centerYAnchor),
            gridStack.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor, constant: 24),
            gridStack.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor, constant: -24),
            gridStack.heightAnchor.constraint(equalTo: foregroundContainer.heightAnchor, multiplier: 0.5)
        ])
    }
}

