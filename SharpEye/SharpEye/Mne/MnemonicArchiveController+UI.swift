import UIKit

extension MnemonicArchiveController: UITableViewDataSource, UITableViewDelegate {
    func configureArchiveUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        tableView.layer.cornerRadius = 18
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        tableView.rowHeight = 72

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No runs recorded yet. Freeze a tile to build history."
        emptyLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center

        let purgeButton = AureateButton()
        purgeButton.configure(with: "Clear Journal", subtitle: "Remove all records", icon: "trash.circle")
        purgeButton.translatesAutoresizingMaskIntoConstraints = false
        purgeButton.addTarget(self, action: #selector(purgeAllRecords), for: .touchUpInside)

        foregroundContainer.addSubview(tableView)
        foregroundContainer.addSubview(emptyLabel)
        foregroundContainer.addSubview(purgeButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: foregroundContainer.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: foregroundContainer.heightAnchor, multiplier: 0.65),

            purgeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            purgeButton.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            purgeButton.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),

            emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor, constant: 18),
            emptyLabel.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor, constant: -18),

            purgeButton.bottomAnchor.constraint(lessThanOrEqualTo: foregroundContainer.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        let record = records[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        let title = "\(record.mode.title) · \(record.score) pts"
        let subtitle = "Level \(record.depth) · \(formatter.string(from: record.createdAt))"
        cell.textLabel?.text = "\(title)\n\(subtitle)"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record = records[indexPath.row]
            GameLedger.shared.purge(recordID: record.id)
            refreshRecords()
        }
    }
}

