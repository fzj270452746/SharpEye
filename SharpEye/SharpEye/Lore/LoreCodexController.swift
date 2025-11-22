import UIKit

class LoreCodexController: BaseViewController {
    let scrollView = UIScrollView()
    let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playbook"
        configurePlaybookUI()
    }
}

