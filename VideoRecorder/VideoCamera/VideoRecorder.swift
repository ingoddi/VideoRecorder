//
//  VideoRecorder.swift
//  VideoRecorder
//
//  Created by Иван Карплюк on 07.06.2023.
//

import AVFoundation
import Photos

final class VideoRecorder: NSObject,
                           AVCaptureFileOutputRecordingDelegate,
                           AVCaptureVideoDataOutputSampleBufferDelegate,
                           AVCaptureAudioDataOutputSampleBufferDelegate {
    
    private let captureQueue = DispatchQueue(label: "captureQueue")
    private let captureSession = AVCaptureSession()
    private let fileOutput = AVCaptureMovieFileOutput()
    
    private var isRecording: Bool = false
    
    // MARK: - init
    override init() {
        super.init()
        
        setupCaptureSession()
        captureQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    // MARK: - Public methods
    public func privewLayer() -> CALayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return previewLayer
    }
    
    // MARK: - Start recoding
    func startRecording(isRecording: Bool) {
        self.isRecording = isRecording
        guard let outputUrl = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first?.appendingPathComponent("output.mov") else {
            return
        }
        
        fileOutput.startRecording(to: outputUrl,
                                  recordingDelegate: self)
        print("Recording started")
    }
    
    // MARK: - Stop recording
    func stopRecording(isRecording: Bool) {
        self.isRecording = isRecording
        fileOutput.stopRecording()
        print("Recording stopped")
    }
    
    // MARK: - Set Up Capture Session
    private func setupCaptureSession() {
        // Add file output
        if captureSession.canAddOutput(fileOutput) {
            captureSession.addOutput(fileOutput)
            
            if let connection = fileOutput.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
        }
        
        // Input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(captureInput)
        captureSession.sessionPreset = .high
        
        // Output video
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
        captureSession.addOutput(videoOutput)
        
        // Output audio
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: captureQueue)
        captureSession.addOutput(audioOutput)
        
        // Audio settings
        let audioDevice = AVCaptureDevice.default(for: .audio)
        let audioInput = try? AVCaptureDeviceInput(device: audioDevice!)
        
        if let audioInput = audioInput, captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            }) { saved, error in
                if saved {
                    print("Video saved to gallery")
                } else {
                    print("Error saving video to gallery: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
}
