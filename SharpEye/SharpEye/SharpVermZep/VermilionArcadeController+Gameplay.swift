import UIKit

extension VermilionArcadeController {
    func prepareRound() {
        highlightedIndex = 0
        switch currentMode {
        case .cyclical:
            let tribe = SharpEyeModel.TileTribe.allCases[tribeIndex % SharpEyeModel.TileTribe.allCases.count]
            let baseTiles = repository.tiles(for: tribe).shuffled()
            currentTiles = gridReadyTiles(from: baseTiles)
            tribeIndex += 1
            statusLabel.text = "\(currentMode.title): \(tribe.englishTitle)"
        case .fusion:
            currentTiles = gridReadyTiles(from: repository.fusionTiles(count: 20))
            statusLabel.text = "\(currentMode.title): Mixed tribes clash"
        }

        // 初始速度更慢（0.8秒），每轮减少0.035秒，最低0.15秒
        // Level 1: 0.8s, Level 2: 0.765s, Level 3: 0.73s ... Level 19+: 0.15s
        timerInterval = max(0.15, 0.8 - Double(roundDepth - 1) * 0.035)
        tileCollection.reloadData()
        updateStatLabels()
        whisperLabel.text = descriptiveWhisper()
        stopButton.alpha = 0.85
        startButton.alpha = 1.0
    }

    func descriptiveWhisper() -> String {
        switch currentMode {
        case .cyclical:
            return "Click to stop when the cursor reaches its maximum value!"
        case .fusion:
            return "Blend mode hides multiple peaks—freeze any tile with value 9 to score."
        }
    }

    func updateStatLabels() {
        scoreLabel.text = "Score \(cumulativeScore)"
        roundLabel.text = "Level \(roundDepth)"
    }

    func evaluateHighlight() {
        guard !currentTiles.isEmpty else { return }
        let selectedTile = currentTiles[highlightedIndex]
        let maxValue = currentTiles.map { $0.faceValue }.max() ?? 9

        if selectedTile.faceValue == maxValue {
            celebrateSuccess()
        } else {
            handleFailure()
        }
    }

    func celebrateSuccess() {
        let points = 120 * roundDepth
        cumulativeScore += points
        roundDepth += 1
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        showScorePopup(points: points)
        animateScoreLabel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.prepareRound()
        }
    }

    func animateScoreLabel() {
        UIView.transition(with: scoreLabel, duration: 0.3, options: .transitionFlipFromTop) {
            self.updateStatLabels()
        }
    }

    func showScorePopup(points: Int) {
        scorePopupLabel.text = "+\(points) 🎉"
        scorePopupLabel.isHidden = false
        scorePopupLabel.alpha = 0
        scorePopupLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.scorePopupLabel.alpha = 1
            self.scorePopupLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn) {
                self.scorePopupLabel.alpha = 0
                self.scorePopupLabel.transform = CGAffineTransform(translationX: 0, y: -50).scaledBy(x: 0.8, y: 0.8)
            } completion: { _ in
                self.scorePopupLabel.isHidden = true
                self.scorePopupLabel.transform = .identity
            }
        }
    }

    func handleFailure() {
        let alert = UIAlertController(title: "Missed Peak", message: "You stopped on \(currentTiles[highlightedIndex].faceValue). Continue the current level or restart a fresh run?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep Going", style: .default, handler: { _ in
            self.carouselActive = false
            self.stopButton.alpha = 0.85
            self.startButton.alpha = 1.0
        }))
        alert.addAction(UIAlertAction(title: "Restart Run", style: .destructive, handler: { _ in
            self.archiveCurrentRun()
            self.resetRun(preserveScore: false)
        }))
        present(alert, animated: true)
    }

    func archiveCurrentRun() {
        let record = GameRecord(mode: currentMode, score: cumulativeScore, depth: roundDepth)
        GameLedger.shared.appendRecord(record)
    }

    func resetRun(preserveScore: Bool) {
        marqueeTimer?.invalidate()
        marqueeTimer = nil
        endCountdown()
        carouselActive = false
        stopButton.alpha = 0.85
        startButton.alpha = 1.0

        if !preserveScore {
            cumulativeScore = 0
            roundDepth = 1
            tribeIndex = 0
        }
        prepareRound()
    }

    func gridReadyTiles(from baseTiles: [SharpEyeModel]) -> [SharpEyeModel] {
        guard !baseTiles.isEmpty else { return [] }
        var bucket = baseTiles.shuffled()
        var result: [SharpEyeModel] = []
        while result.count < 20 {
            if bucket.isEmpty {
                bucket = baseTiles.shuffled()
            }
            guard !bucket.isEmpty else { break }
            result.append(bucket.removeFirst())
        }
        return result
    }
}

