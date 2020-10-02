//
//  MDCamera.swift
//  SimpleApp4
//
//  Created by maedi laziman on 28/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit
import AVFoundation

protocol MDCamera_Communicate {
    func getAllPhotos(images: [UIImage])
}

class MDCamera: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    var delegateCommunicate: MDCamera_Communicate?
    
    var allPhotos:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let widthWindow = methodHelper.getWidthWindow()
        let heightWindow = methodHelper.getHeightWindow()
        let w4 = widthWindow/4
        let wdimg = w4*2
        let h4 = heightWindow/4
        let hgimg = h4*2
        imagePicked.frame = CGRect(x: w4, y: h4, width: wdimg, height: hgimg)
    }
    
    func showCamera(){
        if !checkCameraPermission() {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.displayImageCamera()
                } else {
                    DispatchQueue.main.async {
                        methodHelper.showToast(view: self.view, message: "You must allow app to access your camera.", font: .systemFont(ofSize: 12.0))
                    }
                }
            })
        }
    }
    
    func displayImageCamera(){
        let cam = UIImagePickerController.isSourceTypeAvailable(.camera)
        if cam {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func checkCameraPermission() -> Bool {
        var b = false
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            b = true
            displayImageCamera()
            break
        case .denied:
            break
        default:
            break
        }
        return b
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imagePicked.image = image
        allPhotos.append(image)
        delegateCommunicate?.getAllPhotos(images: allPhotos)
        CreateMDCameraAlbum.shared.save(albName: CreateMDCameraAlbum.albumName, image: image)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
