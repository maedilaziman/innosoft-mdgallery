//
//  MDCamPhotoModel.swift
//  SimpleApp4
//
//  Created by maedi laziman on 25/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit
import Photos

enum CameraPhoto_BgColor : Int{
    case defColor
    case blue
}

struct MDCamPhotoModel {
    let img: UIImage!
    let txtLabel: String!
    let choose: Bool!
    let bgColor: CameraPhoto_BgColor!
}

struct MDInputModel {
    let idx: Int!
    let img: UIImage!
    let number: String!
    let choose: Bool!
    let bgColor: CameraPhoto_BgColor!
}

struct MDAlbumModel {
  let name:String
  let count:Int
  let collection:PHAssetCollection
}
