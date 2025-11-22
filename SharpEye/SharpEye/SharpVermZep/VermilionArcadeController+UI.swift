import UIKit

extension VermilionArcadeController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configureActionButton(_ button: AureateButton,
                               title: String,
                               imageName: String,
                               backgroundColor: UIColor) {
        button.configure(with: title,
                         subtitle: nil,
                         icon: nil,
                         customImageName: nil,
                         allowSystemIcon: false)

        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        } else {
            button.setImage(nil, for: .normal)
            button.imageEdgeInsets = .zero
            button.titleEdgeInsets = .zero
        }

        button.backgroundColor = backgroundColor
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 22, bottom: 16, right: 22)
        button.layer.cornerRadius = 20
    }

    func configureGameUI() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .bold)
        scoreLabel.textColor = .white
        scoreLabel.text = "Score 0"

        roundLabel.translatesAutoresizingMaskIntoConstraints = false
        roundLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        roundLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        roundLabel.text = "Level 1"

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        statusLabel.textColor = .white
        statusLabel.text = currentMode.synopsis
        statusLabel.numberOfLines = 0

        whisperLabel.translatesAutoresizingMaskIntoConstraints = false
        whisperLabel.font = UIFont.systemFont(ofSize: 12)
        whisperLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        whisperLabel.numberOfLines = 0
        whisperLabel.text = "Wait for the brightest tile to arrive under the marquee, then freeze it with Stop."

        modeControl.translatesAutoresizingMaskIntoConstraints = false
        modeControl.selectedSegmentIndex = SharpGameMode.allCases.firstIndex(of: currentMode) ?? 0
        modeControl.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        modeControl.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.25)
        modeControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        modeControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        modeControl.addTarget(self, action: #selector(handleModeChanged), for: .valueChanged)

        configureActionButton(startButton,
                              title: "START",
                              imageName: "AAA",
                              backgroundColor: UIColor(red: 52/255, green: 201/255, blue: 166/255, alpha: 0.4))
        
        configureActionButton(stopButton,
                              title: "STOP",
                              imageName: "BBB",
                              backgroundColor: UIColor(red: 226/255, green: 99/255, blue: 114/255, alpha: 0.4))
        stopButton.alpha = 0.85

        [startButton, stopButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        startButton.addTarget(self, action: #selector(igniteCarousel), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(haltCarousel), for: .touchUpInside)

        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.scrollDirection = .vertical

        tileCollection.translatesAutoresizingMaskIntoConstraints = false
        tileCollection.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        tileCollection.layer.cornerRadius = 20
        tileCollection.dataSource = self
        tileCollection.delegate = self
        tileCollection.contentInset = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        tileCollection.register(ZephyrTileCell.self, forCellWithReuseIdentifier: ZephyrTileCell.reuseID)
        tileCollection.isScrollEnabled = false
        tileCollection.alwaysBounceVertical = false

        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.font = UIFont.systemFont(ofSize: 96, weight: .heavy)
        countdownLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        countdownLabel.textAlignment = .center
        countdownLabel.isHidden = true
        countdownLabel.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        countdownLabel.layer.cornerRadius = 24
        countdownLabel.layer.masksToBounds = true
        countdownLabel.layer.borderWidth = 3
        countdownLabel.layer.borderColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.8).cgColor

        scorePopupLabel.translatesAutoresizingMaskIntoConstraints = false
        scorePopupLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        scorePopupLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        scorePopupLabel.textAlignment = .center
        scorePopupLabel.isHidden = true
        scorePopupLabel.layer.shadowColor = UIColor.black.cgColor
        scorePopupLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        scorePopupLabel.layer.shadowOpacity = 0.8
        scorePopupLabel.layer.shadowRadius = 4

        let scoreStack = UIStackView(arrangedSubviews: [scoreLabel, roundLabel])
        scoreStack.translatesAutoresizingMaskIntoConstraints = false
        scoreStack.axis = .vertical
        scoreStack.spacing = 4

        let buttonStack = UIStackView(arrangedSubviews: [startButton, stopButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        foregroundContainer.addSubview(scoreStack)
        foregroundContainer.addSubview(statusLabel)
        foregroundContainer.addSubview(modeControl)
        foregroundContainer.addSubview(tileCollection)
        tileCollection.addSubview(countdownLabel)
        tileCollection.addSubview(scorePopupLabel)
        foregroundContainer.addSubview(buttonStack)
        foregroundContainer.addSubview(whisperLabel)

        NSLayoutConstraint.activate([
            scoreStack.topAnchor.constraint(equalTo: foregroundContainer.topAnchor, constant: 8),
            scoreStack.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            scoreStack.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),

            statusLabel.topAnchor.constraint(equalTo: scoreStack.bottomAnchor, constant: 6),
            statusLabel.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),

            modeControl.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            modeControl.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            modeControl.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),
            modeControl.heightAnchor.constraint(equalToConstant: 32),

            tileCollection.topAnchor.constraint(equalTo: modeControl.bottomAnchor, constant: 8),
            tileCollection.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            tileCollection.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),
            tileCollection.heightAnchor.constraint(equalTo: foregroundContainer.heightAnchor, multiplier: 0.56),

            countdownLabel.centerXAnchor.constraint(equalTo: tileCollection.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: tileCollection.centerYAnchor),
            countdownLabel.widthAnchor.constraint(equalToConstant: 160),
            countdownLabel.heightAnchor.constraint(equalToConstant: 160),

            scorePopupLabel.centerXAnchor.constraint(equalTo: tileCollection.centerXAnchor),
            scorePopupLabel.centerYAnchor.constraint(equalTo: tileCollection.centerYAnchor),

            whisperLabel.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            whisperLabel.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),
            whisperLabel.bottomAnchor.constraint(equalTo: foregroundContainer.bottomAnchor, constant: -5),
            whisperLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            buttonStack.leadingAnchor.constraint(equalTo: foregroundContainer.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: foregroundContainer.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: whisperLabel.topAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentTiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZephyrTileCell.reuseID, for: indexPath) as? ZephyrTileCell else {
            return UICollectionViewCell()
        }
        let model = currentTiles[indexPath.item]
        let isHighlighted = indexPath.item == highlightedIndex
        cell.configure(with: model, highlighted: isHighlighted)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 5
        let spacing = flowLayout.minimumInteritemSpacing * (columns - 1)
        let totalInset = collectionView.contentInset.left + collectionView.contentInset.right
        let width = (collectionView.bounds.width - spacing - totalInset) / columns
        return CGSize(width: width, height: width * 1.35)
    }
}

