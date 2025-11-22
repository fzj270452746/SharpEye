import UIKit

class MnemonicArchiveController: BaseViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let emptyLabel = UILabel()
    var records: [GameRecord] = []
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Score Journal"
        configureArchiveUI()
        refreshRecords()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshRecords()
    }

    func refreshRecords() {
        records = GameLedger.shared.fetchRecords()
        tableView.reloadData()
        emptyLabel.isHidden = !records.isEmpty
    }

    @objc func purgeAllRecords() {
        GameLedger.shared.purgeAll()
        refreshRecords()
    }
}

