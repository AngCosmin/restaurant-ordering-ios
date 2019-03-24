//
//  MainScreenViewController.swift
//  RewardMe
//
//  Created by Cosmin on 23/03/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class MainScreenViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var cameraView: UIView!
    
    var scannedTableId: Int? = nil
    var wasScanned: Bool = false
    
    enum error: Error {
        case noCameraAvailable
        case videoInputInitFailed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try scanQRCode()
        }
        catch {
            print("Failed to scan QR code")
        }
    }
    
    @IBAction func onScanQRPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToProducts", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                let scannedCode = machineReadableCode.stringValue!
                scannedTableId = Int(scannedCode)
                
                
                if scannedTableId != nil && wasScanned == false {
                    wasScanned = true
                    print("Table: \(scannedTableId!)")
                    self.performSegue(withIdentifier: "goToProducts", sender: self)
                }
            }
        }
    }
    
    func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No camera")
            throw error.noCameraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to init camera")
            throw error.videoInputInitFailed
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = cameraView.bounds
        
        self.cameraView.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
    }
    
    @IBAction func onLogoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
        catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProducts" {
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! ProductsTableViewController
            
            tableVC.tableId = scannedTableId!
        }
    }
}
