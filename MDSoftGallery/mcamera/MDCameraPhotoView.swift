//
//  MDCameraPhotoView.swift
//  SimpleApp4
//
//  Created by maedi laziman on 25/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol MDCameraPhotoView_Interface {
    func getListAlbum(arrayStr: [MDAlbumModel])
    func tapItemPhoto(inpModel: MDInputModel)
    func userPhotosChoosed(camPhotoModel: [MDCamPhotoModel])
    func showMessageToBody()
}

extension MDCameraPhotoView: SlidePageCameraPhoto_Interface {
    func tapItemAlbum(idx: Int, value: String) {
        getAllPhotoFromAlbum(idx: idx, albumName: value)
    }
    func permissionPhotoLibrary(first: Bool) {
        askPermissionPhotoLibrary(first: first)
    }
}

class MDCameraPhotoView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collViewClnd: UICollectionView!
    var testImg1: UIImage!
    var testImg2: UIImage!
    
    var dataCamPhoto: [MDCamPhotoModel] = []
    
    var usrPhotoChoosed: [MDCamPhotoModel] = []
    
    var arrInputModel: [MDInputModel] = []
    
    var arrAlbum: [MDAlbumModel] = []
    
    var countListImg: Int!
    
    let reuseIdentifier = "camera_photo_cell"
    
    var images = [UIImage]()
    
    var sldPageCamera: SlidePageCameraPhoto!
    
    var delegateIface: MDCameraPhotoView_Interface?
    
    override func layoutSubviews() {
        super.layoutSubviews();
        createView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setListener(sldPgCam: SlidePageCameraPhoto){
        sldPageCamera = sldPgCam
        sldPageCamera.delegateIface = self
    }
    
    func delegateMDCamPhotoViewIface(camPhoto: CameraPhoto){
        camPhoto.setListener_MDCameraPhotoView(camPhotoVw: self)
    }
    
    func createView(){
        let fmBundle = Bundle(for: type(of: self))
        countListImg = 0
        backgroundColor = UIColor(white: 1, alpha: 0.0)
        layer.shadowRadius = 4.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        let wdWindow = methodHelper.getWidthWindow()
        var w = 100
        if wdWindow > 375 && wdWindow < 768{
            w = 105
        } else if wdWindow >= 768 && wdWindow < 834 {
            w = 155
        } else if wdWindow >= 834 && wdWindow < 1024 {
            w = 165
        } else if wdWindow >= 1024 {
            w = 185
        }
        layout.itemSize = CGSize(width: w, height: w)
        collViewClnd = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collViewClnd.backgroundColor = UIColor.white
        self.addSubview(collViewClnd)
        collViewClnd.dataSource = self
        collViewClnd.delegate = self
        collViewClnd.register(UINib.init(nibName: "MDCameraPhoto", bundle: fmBundle), forCellWithReuseIdentifier: reuseIdentifier)
        askPermissionPhotoLibrary(first: true)
    }
    
    func askPermissionPhotoLibrary(first: Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
          guard let self = self else {return}
            if !self.checkPhotoLibraryPermission(first: first) {
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized{
                            if first {
                                self.displayImageLibrary()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.delegateIface?.showMessageToBody()
                            }
                        }
                    })
                }
                else {
                    if photos == .denied || photos == .restricted {
                        DispatchQueue.main.async {
                            self.delegateIface?.showMessageToBody()
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countListImg
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MDCameraPhoto
        cell.configure(model: dataCamPhoto[indexPath.row])
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
       let location = sender.location(in: collViewClnd)
       let indexPath = collViewClnd.indexPathForItem(at: location)
       if let index = indexPath {
        let dx = index.row
        if dx > self.dataCamPhoto.count {
            return
        }
        let bgclr = self.dataCamPhoto[dx].bgColor
        let img = self.dataCamPhoto[dx].img
        var chs = true
        if bgclr == CameraPhoto_BgColor.blue {
            chs = false
        }
        let ix = arrInputModel.count + 1
        let iptModel = MDInputModel(idx: dx, img: img, number: String(ix), choose: chs, bgColor: CameraPhoto_BgColor.blue)
        delegateIface?.tapItemPhoto(inpModel: iptModel)
        if arrInputModel.count > 0 {
            self.arrInputModel.append(iptModel)
            var cloneIptModel = arrInputModel
            arrInputModel.removeAll()
            var mustRmv = false
            for i in (0..<cloneIptModel.count) {
                if dx == cloneIptModel[i].idx {
                    if chs {
                        arrInputModel.append(iptModel)
                    }
                    else {
                        mustRmv = true
                    }
                }
                else {
                    arrInputModel.append(cloneIptModel[i])
                }
            }
            if mustRmv {
                cloneIptModel = arrInputModel
                arrInputModel.removeAll()
                for i in 0..<cloneIptModel.count {
                    arrInputModel.append(MDInputModel(idx: cloneIptModel[i].idx, img: cloneIptModel[i].img, number: String(i+1), choose: cloneIptModel[i].choose, bgColor: cloneIptModel[i].bgColor))
                }
            }
        }
        else {
            arrInputModel.append(iptModel)
        }
        reloadData(arrInput: arrInputModel)
       }
    }
    
    func reloadData(arrInput: [MDInputModel]){
        var nwData: [MDCamPhotoModel]!
        nwData = []
        for i in (0..<countListImg) {
            nwData.append(MDCamPhotoModel(img: dataCamPhoto[i].img, txtLabel: dataCamPhoto[i].txtLabel, choose: false, bgColor: CameraPhoto_BgColor.defColor))
        }
        dataCamPhoto.removeAll()
        usrPhotoChoosed.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
          guard let self = self else {return}
            for i in (0..<nwData.count) {
                if arrInput.count > 0 {
                    var exists = false
                    for x in (0..<arrInput.count) {
                        if i == arrInput[x].idx {
                            exists = true
                            let mdcamphoto = MDCamPhotoModel(img: arrInput[x].img, txtLabel: arrInput[x].number, choose: arrInput[x].choose, bgColor: arrInput[x].bgColor)
                            self.dataCamPhoto.append(mdcamphoto)
                            self.usrPhotoChoosed.append(mdcamphoto)
                        }
                    }
                    if !exists {
                        self.dataCamPhoto.append(MDCamPhotoModel(img: nwData[i].img, txtLabel: nwData[i].txtLabel, choose: false, bgColor: CameraPhoto_BgColor.defColor))
                    }
                }
                else{
                    self.dataCamPhoto.append(MDCamPhotoModel(img: nwData[i].img, txtLabel: nwData[i].txtLabel, choose: false, bgColor: CameraPhoto_BgColor.defColor))
                }
            }
            self.collViewClnd.reloadData()
            self.delegateIface?.userPhotosChoosed(camPhotoModel: self.usrPhotoChoosed)
        }
    }
    
    func displayImageLibrary() {
        let pic = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        if pic {
            arrAlbum.removeAll()
            listAlbums()
            getPhotos()
        }
    }
    
    func listAlbums() {
        var album:[MDAlbumModel] = [MDAlbumModel]()
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        userAlbums.enumerateObjects{ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                let newAlbum = MDAlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
                album.append(newAlbum)
            }
        }

        for item in album {
            arrAlbum.append(item)
        }
        delegateIface?.getListAlbum(arrayStr: arrAlbum)
    }
    
    func getAllPhotoFromAlbum(idx: Int, albumName: String){
        dataCamPhoto.removeAll()
        arrInputModel.removeAll()
        usrPhotoChoosed.removeAll()
        delegateIface?.userPhotosChoosed(camPhotoModel: usrPhotoChoosed)
        if idx == 0 {
            getPhotos()
        }
        else {
            let manager = PHImageManager.default()
            let requestOptions = imageReqOptions()
            let fetchOptions = PHFetchOptions()
            let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            var sameTitle = false
            for k in 0 ..< collection.count {
                let obj:AnyObject! = collection.object(at: k)
                if obj.title == albumName {
                    if let assCollection = obj as? PHAssetCollection {
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        let results = PHAsset.fetchAssets(in: assCollection, options: fetchOptions)
                        let cn = results.count
                        countListImg = cn
                        if cn > 0 {
                            for i in 0..<cn {
                                let asset = results.object(at: i)
                                let size = CGSize(width: 250, height: 250)
                                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                                    if let image = image {
                                        self.images.append(image)
                                        self.dataCamPhoto.append(MDCamPhotoModel(img: image, txtLabel: "", choose: false, bgColor: CameraPhoto_BgColor.defColor))
                                    }
                                }
                            }
                        }
                    }
                    sameTitle = true
                }
                if sameTitle {
                    break
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
              guard let self = self else {return}
                self.collViewClnd.reloadData()
            }
        }
    }
    
    func getPhotos() {
        let manager = PHImageManager.default()
        let requestOptions = imageReqOptions()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let cn = results.count
        countListImg = cn
        if cn > 0 {
            for i in 0..<cn {
                let asset = results.object(at: i)
                let size = CGSize(width: 250, height: 250)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        self.dataCamPhoto.append(MDCamPhotoModel(img: image, txtLabel: "", choose: false, bgColor: CameraPhoto_BgColor.defColor))
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
          guard let self = self else {return}
            self.collViewClnd.reloadData()
        }
    }
    
    func imageReqOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }
    
    func checkPhotoLibraryPermission(first: Bool) -> Bool {
        var b = false
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos {
            case .authorized:
                b = true
                if first {
                    displayImageLibrary()
                }
                break
            case .denied:
                break
            default:
                break
        }
        return b
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
