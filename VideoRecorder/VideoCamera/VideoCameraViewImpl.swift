//
//  VideoCamera.swift
//  VideoRecorder
//
//  Created by Иван Карплюк on 07.06.2023.
//

import UIKit

protocol VideoCameraViewImplOutput: AnyObject {
    func didTapStartRecordingButton(isRecording: Bool)
}

final class VideoCameraViewImpl: UIView {
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private let buttonSize: CGFloat = 80
    
    private weak var delegate: VideoCameraViewImplOutput?
    
    private var isRecording: Bool = false
    private var startTime: Date?
    private var timer: Timer = Timer()
    
    private var buttonColor: UIColor {
        if isRecording {
            return UIColor.white
        } else {
            return UIColor.red
        }
    }
    
    // MARK: - init
    init(delegate: VideoCameraViewImplOutput) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.backgroundColor = .black
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Obj-c
    @objc
    private func didTapRecordingButton() {
        delegate?.didTapStartRecordingButton(isRecording: isRecording)
        self.isRecording.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.recordingButton.backgroundColor = self.buttonColor
        }
        
        if isRecording {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    @objc
    private func updateTimer() {
        guard let startTime = self.startTime else { return }
        let duration = Date().timeIntervalSince(startTime)
        timerLabel.text = formatTime(duration)
    }
    
    // MARK: - Private methods
    private func startTimer() {
        timer.invalidate()
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
        timerLabel.text = nil
        startTime = nil
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - UI
    private lazy var recordingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = buttonColor
        btn.layer.cornerRadius = buttonSize / 2
        btn.addTarget(self,
                      action: #selector(didTapRecordingButton),
                      for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20,
                                 weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func addViews() {
        self.addSubview(recordingButton)
        self.addSubview(timerLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            recordingButton.widthAnchor.constraint(equalToConstant: buttonSize),
            recordingButton.heightAnchor.constraint(equalToConstant: buttonSize),
            recordingButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recordingButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            
            timerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            timerLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
}
