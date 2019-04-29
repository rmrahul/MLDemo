//
//  ImageViewController.swift
//  MLDemo
//
//  Created by Rahul Mane on 20/04/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ImageViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = label.font.withSize(35)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
        
        view.addSubview(label)
        setupLabel()
    }
    
    func setupCaptureSession() {
        
        // creates a new capture session
        let captureSession = AVCaptureSession()
        
        // search for available capture devices
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        // get capture device, add device input to capture session
        do {
            if let captureDevice = availableDevices.first {
                captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // setup output, add output to capture session
        let captureOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(captureOutput)
        
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    // called everytime a frame is captured
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let Observation = results.first else { return }
            
            DispatchQueue.main.async(execute: {
                
                if(Observation.confidence > 0.90){
                    self.label.text = "\(Observation.identifier)"
                }
                else{
                    self.label.text = "Not sure "
                }
                print(Observation.confidence)
            })
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // executes request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupLabel() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 150).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
    }

}
