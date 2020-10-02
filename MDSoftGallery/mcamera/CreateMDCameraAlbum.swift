//
//  CreateMDCameraAlbum.swift
//  SimpleApp4
//
//  Created by maedi laziman on 01/10/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit
import Photos

class CreateMDCameraAlbum: NSObject {
    static let albumName = "MDCamera"
    static let shared = CreateMDCameraAlbum()

  private var assetCollection: PHAssetCollection!
    
    var photoLibraryImages = [UIImage]()

  private override init() {
    super.init()

    if let assetCollection = fetchAssetCollectionForAlbum(alb: CreateMDCameraAlbum.albumName) {
      self.assetCollection = assetCollection
      return
    }
  }

  func checkAuthorizationWithHandler(alb: String, completion: @escaping ((_ success: Bool) -> Void)) {
    if PHPhotoLibrary.authorizationStatus() == .notDetermined {
      PHPhotoLibrary.requestAuthorization({ (status) in
        self.checkAuthorizationWithHandler(alb: alb, completion: completion)
      })
    }
    else if PHPhotoLibrary.authorizationStatus() == .authorized {
      self.createAlbumIfNeeded(albName: alb) { (success) in
        if success {
          completion(true)
        } else {
          completion(false)
        }

      }

    }
    else {
      completion(false)
    }
  }

    private func createAlbumIfNeeded(albName: String, completion: @escaping ((_ success: Bool) -> Void)) {
    if let assetCollection = fetchAssetCollectionForAlbum(alb: albName) {
      self.assetCollection = assetCollection
      completion(true)
    } else {
      PHPhotoLibrary.shared().performChanges({
        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albName)   // create an asset collection with the album name
      }) { success, error in
        if success {
          self.assetCollection = self.fetchAssetCollectionForAlbum(alb: albName)
          completion(true)
        } else {
          // Unable to create album
          completion(false)
        }
      }
    }
  }

    private func fetchAssetCollectionForAlbum(alb: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", alb)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
          return collection.firstObject
        }
        return nil
    }
    
    func getAlbum(albName: String, title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        self.checkAuthorizationWithHandler(alb: albName) { (success) in
          if success, self.assetCollection != nil {
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", title)
                let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

                if let album = collections.firstObject {
                    completionHandler(album)
                }
            }
          }
        }
    }
    
    func get_Photos_From_Album(albumName: String) -> [UIImage]
           {
            self.checkAuthorizationWithHandler(alb: albumName) { (success) in
              if success, self.assetCollection != nil {
                self.photoLibraryImages.removeAll()
                           var photoLibraryAssets = [PHAsset]()
                           //whatever you need, you can use UIImage or PHAsset to photos in UICollectionView

                           DispatchQueue.global(qos: .userInteractive).async
                           {
                               let fetchOptions = PHFetchOptions()
                               fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

                               let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                               let customAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)

                               [smartAlbums, customAlbums].forEach {
                                   $0.enumerateObjects { collection, index, stop in

                                       let imgManager = PHImageManager.default()

                                       let requestOptions = PHImageRequestOptions()
                                       requestOptions.isSynchronous = true
                                       requestOptions.deliveryMode = .highQualityFormat

                                       let photoInAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)

                                       if let title = collection.localizedTitle
                                       {
                                           if title == albumName
                                           {
                                               if photoInAlbum.count > 0
                                               {
                                                   for i in (0..<photoInAlbum.count).reversed()
                                                   {
                                                    imgManager.requestImage(for: photoInAlbum.object(at: i) as PHAsset , targetSize: CGSize(width: methodHelper.getWidthWindow(), height: methodHelper.getHeightWindow()), contentMode: .aspectFit, options: requestOptions, resultHandler: {
                                                           image, error in
                                                           if image != nil
                                                           {
                                                            self.photoLibraryImages.append(image!)
                photoLibraryAssets.append(photoInAlbum.object(at: i))
                                                           }
                                                       })
                                                   }
                                               }
                                           }
                                       }
                                   }
                               }
                           }
                
              }
            }
            return photoLibraryImages
               
    }
    
    func get_LibraryImages() -> [UIImage]
    {
        return photoLibraryImages
    }

    func save(albName: String, image: UIImage) {
        self.checkAuthorizationWithHandler(alb: albName) { (success) in
          if success, self.assetCollection != nil {
            PHPhotoLibrary.shared().performChanges({
              let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
              let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
              if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                let enumeration: NSArray = [assetPlaceHolder!]
                albumChangeRequest.addAssets(enumeration)
              }

            }, completionHandler: { (success, error) in
              //if success {
              //} else {
              //}
            })

          }
        }
    }
    
    func askAuthorizationWriteAccessGallery(albName: String, viewControl: UIViewController, vw: UIView) -> Bool {
        var aut = true
        self.checkAuthorizationWithHandler(alb: albName) { (success) in
            if !success {
                aut = false
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Authorization Access Photos", message: "Authorization is not granted!, you cannot save a custom cup if authorization is not granted.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    }))

                    viewControl.present(alert, animated: true)
                }
            }
        }
        return aut
    }

    func saveMovieToLibrary(albName: String, movieURL: URL) {

    self.checkAuthorizationWithHandler(alb: albName) { (success) in
      if success, self.assetCollection != nil {

        PHPhotoLibrary.shared().performChanges({

          if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieURL) {
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
              let enumeration: NSArray = [assetPlaceHolder!]
              albumChangeRequest.addAssets(enumeration)
            }

          }

        }, completionHandler:  { (success, error) in
          //if success {
          //} else {
          //}
        })


      }
    }

  }
}

