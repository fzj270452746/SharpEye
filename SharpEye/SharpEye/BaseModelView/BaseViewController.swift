import UIKit

class BaseViewController: UIViewController {
    let backdropImageView = UIImageView(image: UIImage(named: "sharp"))
    let translucentOverlay = UIView()
    let foregroundContainer = UIView()
    let backGlyphButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureBackdropLayers()
        configureNavigationGlyph()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationGlyph()
    }
}

