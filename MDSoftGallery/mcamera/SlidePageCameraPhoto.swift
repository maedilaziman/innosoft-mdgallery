//
//  SlidePageCameraPhoto.swift
//  SimpleApp4
//
//  Created by maedi laziman on 25/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol SlidePageCameraPhoto_Interface {
    func tapItemAlbum(idx: Int, value: String)
    func permissionPhotoLibrary(first: Bool)
}

extension SlidePageCameraPhoto: CameraPhoto_Interface {
    func tapItemAlbum(idx: Int, value: String) {
        delegateIface?.tapItemAlbum(idx: idx, value: value)
    }
    func permissionPhotoLibrary(first: Bool) {
        delegateIface?.permissionPhotoLibrary(first: first)
    }
}

class SlidePageCameraPhoto: UIView {

    @IBOutlet weak var viewCamPhoto: MDCameraPhotoView!
    
    var cameraPhoto: CameraPhoto!
    
    var delegateIface: SlidePageCameraPhoto_Interface?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setListener(camPhoto: CameraPhoto){
        cameraPhoto = camPhoto
        cameraPhoto.delegateIface = self
        viewCamPhoto.setListener(sldPgCam: self)
        viewCamPhoto.delegateMDCamPhotoViewIface(camPhoto: cameraPhoto)
    }
    
    func setViewWidthAndHeight(posY: Int, hgview: Int){
        let widthWindow = methodHelper.getWidthWindow()
        let posx = 5
        let wdView = widthWindow - (posx*4)
        viewCamPhoto.frame = CGRect(x:posx, y:posY, width:wdView, height: hgview)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
