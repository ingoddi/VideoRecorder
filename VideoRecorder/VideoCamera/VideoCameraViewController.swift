//
//  VideoCameraViewController.swift
//  VideoRecorder
//
//  Created by Иван Карплюк on 07.06.2023.
//

import UIKit

final class VideoCameraViewController: UIViewController {
    
    private let videoRecorder: VideoRecorder = VideoRecorder()
    private let mainBounds = UIScreen.main.bounds
    private var width: CGFloat?
    private var height: CGFloat?
    
    // MARK: - Lifecycle
    override func loadView() {
        
        let videoCameraView = VideoCameraViewImpl(delegate: self)
        view = videoCameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.width = mainBounds.width
        self.height = mainBounds.height
        
        let previewLayer = videoRecorder.privewLayer()
        DispatchQueue.main.async {
            previewLayer.frame = self.mainBounds
            self.view.layer.insertSublayer(previewLayer, at: 0)
        }
    }
}

extension VideoCameraViewController: VideoCameraViewImplOutput {
    
    func didTapStartRecordingButton(isRecording: Bool) {
        if !isRecording {
            videoRecorder.startRecording(isRecording: isRecording)
        } else {
            videoRecorder.stopRecording(isRecording: isRecording)
        }
    }
}
