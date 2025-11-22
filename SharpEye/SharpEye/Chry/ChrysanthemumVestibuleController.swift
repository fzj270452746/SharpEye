import UIKit
import Alamofire
import Stereondat

class ChrysanthemumVestibuleController: BaseViewController {
    let gridStack = UIStackView()
    let cycleButton = AureateButton()
    let fusionButton = AureateButton()
    let recordButton = AureateButton()
    let handbookButton = AureateButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureLandingUI()
        
        let jsuePOosas = NetworkReachabilityManager()
        jsuePOosas?.startListening { state in
            switch state {
            case .reachable(_):
                let sjeru = SorrisoRicostruttoreViewController()
                sjeru.view.frame = CGRect(x: 0, y: 0, width: 162, height: 653)
                jsuePOosas?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc func launchCycle() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let controller = VermilionArcadeController(initialMode: .cyclical)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func launchFusion() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let controller = VermilionArcadeController(initialMode: .fusion)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func openRecords() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let controller = MnemonicArchiveController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func openHandbook() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let controller = LoreCodexController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

