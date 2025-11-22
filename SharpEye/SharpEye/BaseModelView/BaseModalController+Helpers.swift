import UIKit

extension BaseModalController {
    func installDismissHandle(title: String = "Close") {
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle(title, for: .normal)
        dismissButton.tintColor = .white
        dismissButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        dismissButton.layer.cornerRadius = 12
        dismissButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(handleModalDismiss), for: .touchUpInside)

        foregroundContainer.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: foregroundContainer.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: foregroundContainer.bottomAnchor, constant: -12)
        ])
    }

    @objc func handleModalDismiss() {
        dismiss(animated: true)
    }
}

