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
    
    private func addViews() {
        self.addSubview(recordingButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            recordingButton.widthAnchor.constraint(equalToConstant: buttonSize),
            recordingButton.heightAnchor.constraint(equalToConstant: buttonSize),
            recordingButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recordingButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
        ])
    }
}
