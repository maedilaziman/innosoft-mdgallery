//
//  MDCameraPhoto.swift
//  SimpleApp4
//
//  Created by maedi laziman on 25/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

class MDCameraPhoto: UICollectionViewCell {
    
    @IBOutlet weak var parentWall: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var bulletView: UIView!
    @IBOutlet weak var bulletLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let noimg = UIImage(named: "ic_no_img.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        imgPhoto.image = noimg
        bulletView.layer.masksToBounds = true
        bulletView.layer.cornerRadius = bulletView.frame.size.width/2
        bulletView.layer.borderColor = UIColor.white.cgColor
        bulletView.layer.borderWidth = 1.3
        let wdWindow = methodHelper.getWidthWindow()
        var w = 100
        let yb = 10
        var xb = 72
        if wdWindow > 375 && wdWindow < 768{
            w = 105
            xb = xb + 5
            imgPhoto.frame = CGRect(x: 0, y: 0, width: w, height: w)
            bulletView.frame = CGRect(x: xb, y: yb, width: Int(bulletView.frame.width), height: Int(bulletView.frame.height))
        } else if wdWindow >= 768 && wdWindow < 834 {
            w = 155
            xb = xb + 55
            imgPhoto.frame = CGRect(x: 0, y: 0, width: w, height: w)
            bulletView.frame = CGRect(x: xb, y: yb, width: Int(bulletView.frame.width), height: Int(bulletView.frame.height))
        } else if wdWindow >= 834 && wdWindow < 1024 {
            w = 165
            xb = xb + 65
            imgPhoto.frame = CGRect(x: 0, y: 0, width: w, height: w)
            bulletView.frame = CGRect(x: xb, y: yb, width: Int(bulletView.frame.width), height: Int(bulletView.frame.height))
        } else if wdWindow >= 1024 {
            w = 185
            xb = xb + 85
            imgPhoto.frame = CGRect(x: 0, y: 0, width: w, height: w)
            bulletView.frame = CGRect(x: xb, y: yb, width: Int(bulletView.frame.width), height: Int(bulletView.frame.height))
        }
    }
    
    public func configure(model: MDCamPhotoModel){
        imgPhoto.image = model.img
        bulletLbl.text = model.txtLabel
        let bgColor = model.bgColor
        bulletLbl.textColor = UIColor(white: 1, alpha: 0.0)
        switch bgColor {
            case .defColor :
                bulletView.backgroundColor = UIColor(white: 1, alpha: 0.2)
                break
            case .blue :
                bulletView.backgroundColor = methodHelper.hexStringToUIColor (hex:"#4497f4")
                break
            default:
                bulletView.backgroundColor = UIColor(white: 1, alpha: 0.2)
                break
            }
        if model.choose {
            bulletView.backgroundColor = methodHelper.hexStringToUIColor (hex:"#4497f4")
            bulletLbl.textColor = UIColor.white
        }
        else {
            bulletView.backgroundColor = UIColor(white: 1, alpha: 0.2)
            bulletLbl.textColor = UIColor(white: 1, alpha: 0.0)
        }
    }
}
