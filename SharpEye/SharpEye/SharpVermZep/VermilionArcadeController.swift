import UIKit

class VermilionArcadeController: BaseViewController {
    let repository = SharpEyeRepository.shared
    let flowLayout = UICollectionViewFlowLayout()
    lazy var tileCollection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    let scoreLabel = UILabel()
    let roundLabel = UILabel()
    let statusLabel = UILabel()
    let whisperLabel = UILabel()
    let modeControl = UISegmentedControl(items: SharpGameMode.allCases.map { $0.title })
    let startButton = AureateButton()
    let stopButton = AureateButton()
    let countdownLabel = UILabel()
    let scorePopupLabel = UILabel()

    var marqueeTimer: Timer?
    var countdownTimer: Timer?
    var currentTiles: [SharpEyeModel] = []
    var highlightedIndex = 0
    var currentMode: SharpGameMode
    var roundDepth = 1
    var cumulativeScore = 0
    var tribeIndex = 0
    var timerInterval: TimeInterval = 0.8
    var carouselActive = false
    var isCountingDown = false
    var countdownValue = 3

    init(initialMode: SharpGameMode) {
        self.currentMode = initialMode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.currentMode = .cyclical
        super.init(coder: coder)
    }

    deinit {
        marqueeTimer?.invalidate()
        countdownTimer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureGameUI()
        prepareRound()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        marqueeTimer?.invalidate()
        marqueeTimer = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownLabel.isHidden = true
        isCountingDown = false
        autoSaveRecord()
    }

    @objc func handleModeChanged() {
        let index = modeControl.selectedSegmentIndex
        if index >= 0 && index < SharpGameMode.allCases.count {
            currentMode = SharpGameMode.allCases[index]
        }
        resetRun(preserveScore: false)
    }

    @objc func igniteCarousel() {
        guard !carouselActive, !isCountingDown else { return }
        isCountingDown = true
        countdownValue = 3
        startButton.alpha = 0.5
        stopButton.alpha = 1.0
        updateCountdownLabel()
        countdownLabel.isHidden = false
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleCountdownTick), userInfo: nil, repeats: true)
        RunLoop.current.add(countdownTimer!, forMode: .common)
    }

    @objc func haltCarousel() {
        if isCountingDown {
            endCountdown()
            startButton.alpha = 1.0
            stopButton.alpha = 0.85
            return
        }
        guard carouselActive else { return }
        carouselActive = false
        marqueeTimer?.invalidate()
        marqueeTimer = nil
        startButton.alpha = 1.0
        stopButton.alpha = 0.85
        evaluateHighlight()
    }

    @objc func advanceHighlight() {
        guard !currentTiles.isEmpty else { return }
        highlightedIndex = (highlightedIndex + 1) % currentTiles.count
        tileCollection.reloadData()
    }

    func autoSaveRecord() {
        if cumulativeScore > 0 {
            let record = GameRecord(mode: currentMode, score: cumulativeScore, depth: roundDepth)
            GameLedger.shared.appendRecord(record)
        }
    }

    @objc func handleCountdownTick() {
        countdownValue -= 1
        if countdownValue <= 0 {
            endCountdown()
            beginCarousel()
        } else {
            updateCountdownLabel()
        }
    }

    func updateCountdownLabel() {
        countdownLabel.text = "\(countdownValue)"
        countdownLabel.alpha = 0
        countdownLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.countdownLabel.alpha = 1
            self.countdownLabel.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseIn) {
                self.countdownLabel.alpha = 0.2
                self.countdownLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }

    func endCountdown() {
        isCountingDown = false
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownLabel.isHidden = true
        countdownLabel.alpha = 1
        countdownLabel.transform = .identity
    }

    func beginCarousel() {
        guard !carouselActive else { return }
        carouselActive = true
        stopButton.alpha = 1.0
        marqueeTimer?.invalidate()
        marqueeTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(advanceHighlight), userInfo: nil, repeats: true)
        if let marqueeTimer {
            RunLoop.current.add(marqueeTimer, forMode: .common)
        }
    }
}

