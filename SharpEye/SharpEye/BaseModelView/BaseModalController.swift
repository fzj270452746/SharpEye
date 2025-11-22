import UIKit

class BaseModalController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .pageSheet
    }
}

