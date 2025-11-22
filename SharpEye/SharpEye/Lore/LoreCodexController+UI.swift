import UIKit

extension LoreCodexController {
    func configurePlaybookUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 18

        foregroundContainer.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: foregroundContainer.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: foregroundContainer.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -12),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let sections: [(String, String)] = [
            ("Objective", "Watch the luminous carousel at the top, then press Stop exactly when the marquee lands on the tile with value 9."),
            ("Scoring", "Each successful freeze grants 120 points multiplied by the level you currently survive."),
            ("Cycle Run", "Only one tribe of tiles appears per round. Tribes rotate bamboo → coins → characters to keep you guessing."),
            ("Fusion Run", "All tribes merge into the carousel. Multiple nines may surface—freeze any to keep the combo alive."),
            ("Controls", "Tap Start Carousel to launch the marquee. Tap Stop Now to halt it. Archive Run stores the current score into the journal."),
            ("Records", "Visit Score Journal to inspect, delete or purge recorded runs. Empty states remind you to play more."),
            ("Tips", "Higher levels accelerate the pulse. Watch rhythm patterns and anticipate when the maximum tile returns.")
        ]

        sections.forEach { title, body in
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            titleLabel.textColor = .white
            titleLabel.text = title

            let bodyLabel = UILabel()
            bodyLabel.font = UIFont.systemFont(ofSize: 16)
            bodyLabel.textColor = UIColor.white.withAlphaComponent(0.85)
            bodyLabel.numberOfLines = 0
            bodyLabel.text = body

            contentStack.addArrangedSubview(titleLabel)
            contentStack.addArrangedSubview(bodyLabel)
        }
    }
}

