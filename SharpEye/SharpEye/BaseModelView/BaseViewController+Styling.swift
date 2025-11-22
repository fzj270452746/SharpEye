import UIKit

extension BaseViewController {
    func configureBackdropLayers() {
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        backdropImageView.contentMode = .scaleAspectFill

        translucentOverlay.translatesAutoresizingMaskIntoConstraints = false
        translucentOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        foregroundContainer.translatesAutoresizingMaskIntoConstraints = false
        foregroundContainer.backgroundColor = .clear

        view.addSubview(backdropImageView)
        view.addSubview(translucentOverlay)
        view.addSubview(foregroundContainer)

        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            translucentOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            translucentOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            translucentOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            translucentOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            foregroundContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            foregroundContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            foregroundContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            foregroundContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    func configureNavigationGlyph() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true

        backGlyphButton.translatesAutoresizingMaskIntoConstraints = false
        backGlyphButton.setTitle("Back", for: .normal)
        backGlyphButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        backGlyphButton.tintColor = .white
        backGlyphButton.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        backGlyphButton.layer.cornerRadius = 18
        backGlyphButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 14)
        backGlyphButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [backGlyphButton])
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 74, height: 36))
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: customView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: customView.bottomAnchor)
        ])

        if navigationController?.viewControllers.first === self {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
        }
    }

    @objc func handleBackTap() {
        navigationController?.popViewController(animated: true)
    }
}

