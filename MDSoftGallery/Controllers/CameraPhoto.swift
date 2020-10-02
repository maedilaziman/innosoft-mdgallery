//
//  CameraPhoto.swift
//  SimpleApp4
//
//  Created by maedi laziman on 24/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol CameraPhoto_Interface {
    func tapItemAlbum(idx: Int, value: String)
    func permissionPhotoLibrary(first: Bool)
}

public protocol CameraPhoto_Communicate {
    func getAllPhotos(images: [UIImage])
}

extension CameraPhoto: DropDownAlbum_Interface {
    func getDataToDropDownAlbum(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String) {
        let customCell = cell as! TableDropDownAlbum
        let strLbl = arrUpAlbum[indexPos]
        customCell.labelTitle.text = strLbl
        customCell.labelTitle.tag = indexPos
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapCellDropDown))
        customCell.labelTitle.isUserInteractionEnabled = true
        customCell.labelTitle.addGestureRecognizer(tap)
    }
    func numberOfRowsAlbum(makeDropDownIdentifier: String) -> Int {
        return totalCellDropDownAlbum
    }
    func selectItemInDropDownAlbum(indexPos: Int, makeDropDownIdentifier: String) {
        dropDown.hideDropDown()
    }
}

extension CameraPhoto: MDCameraPhotoView_Interface{
    func getListAlbum(arrayStr: [MDAlbumModel]) {
        arrUpAlbum.removeAll()
        arrUpAlbum.append(zeroAlbName)
        for item in arrayStr {
            let albName = item.name
            arrUpAlbum.append(albName)
        }
        totalCellDropDownAlbum = arrUpAlbum.count
    }
    func tapItemPhoto(inpModel: MDInputModel) {
        hideDropDownAlbum()
    }
    func userPhotosChoosed(camPhotoModel: [MDCamPhotoModel]) {
        mdCamPhotoModel = camPhotoModel
    }
    func showMessageToBody() {
        methodHelper.showToast(view: self.view, message: "You must allow app to access your photos.", font: .systemFont(ofSize: 12.0))
    }
}

extension CameraPhoto: MDCamera_Communicate {
    func getAllPhotos(images: [UIImage]) {
        for item in images {
            allPhotos.append(item)
        }
    }
}

enum CastError: Error {
    case showErrorCast(str: String)
}

public class CameraPhoto: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var viewTab: UIView!
    
    @IBOutlet weak var stackViewTab: UIStackView!
    @IBOutlet weak var stackTab1: UIStackView!
    @IBOutlet weak var stackTab2: UIStackView!
    @IBOutlet weak var borderTab: UIView!
    @IBOutlet weak var bgHeader: UIView!
    @IBOutlet weak var btnAlbumName: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var waitDataView: UIView!
    
    var widthWindow: Int!
    var heightWindow: Int!
    var defViewParentStack: CGFloat!
    
    var widthBorderTab1: Int!
    var widthBorderTab2: Int!
    var posxBrdTab1: Int!
    var posxBrdTab2: Int!
    var posxBrdTab3: Int!
    var hgBgHeader: CGFloat!
    var scrViewHg: CGFloat!
    var posYTab: CGFloat!
    var scrFromRight: Bool!
    var tapTabBtn: Bool!
    var lastPosScr = 0
    var yplusHeader = 0
    
    let dropDown = DropDownAlbum()
    var dropDownRowHeight: CGFloat = 40
    var isShowDropDown: Bool!
    var totalCellDropDownAlbum = 0
    var arrUpAlbum: [String]!
    
    var camPhotoView: MDCameraPhotoView!
    var MDBoardCamera: MDCamera!
    
    var delegateIface: CameraPhoto_Interface?
    var delegateCommunicate: CameraPhoto_Communicate?
    
    let zeroAlbName = "All Photo"
    
    var mdCamPhotoModel:[MDCamPhotoModel] = []
    var allPhotos:[UIImage] = []
    
    @IBAction func actGetGallery(_ sender: Any) {
        scrFromRight = false
        toPage(topage: 0)
    }
    
    @IBAction func actGetCamera(_ sender: Any) {
        scrFromRight = true
        toPage(topage: 1)
    }
    
    @IBAction func actTapAlbum(_ sender: Any) {
        let h = heightWindow/2
        let frmBtnALbum = self.btnAlbumName.frame
        let wdDropDownAlbum = frmBtnALbum.width * 2
        isShowDropDown = dropDown.showDropDown(heightdd: CGFloat(h), widthdd: wdDropDownAlbum)
        let posYActualDropDown = Int(frmBtnALbum.height) + yplusHeader + 60
        let posXDropDownAlbum = frmBtnALbum.origin.x + 10
        dropDown.frame = CGRect(x: posXDropDownAlbum, y: CGFloat(posYActualDropDown), width: CGFloat(wdDropDownAlbum), height: CGFloat(h))
    }
    
    @IBAction func actDone(_ sender: Any) {
        if delegateCommunicate == nil {
            methodHelper.showToast(view: self.view, message: "Protocol extension doesn't implement yet!", font: .systemFont(ofSize: 12.0))
            return
        }
        for item in mdCamPhotoModel {
            allPhotos.append(item.img)
        }
        delegateCommunicate?.getAllPhotos(images: allPhotos)
        methodHelper.backNavLeft(view: self.view, controll: self)
    }
    
    var slides:[Any] = [];

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController!.navigationBar.shadowImage = UIImage()
        viewTab.backgroundColor = methodHelper.hexStringToUIColor (hex:"#e4e9ee")
        
        widthWindow = methodHelper.getWidthWindow()
        heightWindow = methodHelper.getHeightWindow()
        if heightWindow > 736 {
            yplusHeader = 25
        }
        scrFromRight = true
        tapTabBtn = false
        hgBgHeader = btnAlbumName.frame.height + 20
        bgHeader.frame = CGRect(x:0, y:CGFloat(yplusHeader), width: CGFloat(widthWindow), height: hgBgHeader)
        waitDataView.frame = CGRect(x:0, y:CGFloat(Int(hgBgHeader)+yplusHeader-4), width: CGFloat(widthWindow/3), height: 4)
        waitDataView.isHidden = true
        btnAlbumName.frame = CGRect(x:0, y:10, width: btnAlbumName.frame.width, height: btnAlbumName.frame.height)
        let wdBtnDone = btnDone.frame.width
        let posXDone = CGFloat(widthWindow) - wdBtnDone
        btnDone.frame = CGRect(x:posXDone, y:10, width: btnDone.frame.width, height: btnDone.frame.height)
        
        let hgViewTab = btnGallery.frame.height + 30
        posYTab = CGFloat(heightWindow) - hgViewTab
        viewTab.frame = CGRect(x:0, y:posYTab, width: CGFloat(widthWindow), height: hgViewTab)
        defViewParentStack = viewTab.frame.height
        scrViewHg = CGFloat(heightWindow) - (defViewParentStack+hgBgHeader)
        let defStackTabHeight = stackTab1.frame.height
        let defButtonWidth = stackTab1.frame.width
        let totalWidthButtonTab = defButtonWidth*2
        let totalWidthSpace = CGFloat(widthWindow) - CGFloat(totalWidthButtonTab)
        let spaceHrzStackTab = totalWidthSpace/4
        let spcHrzStackTab2 = spaceHrzStackTab * 2
        
        stackViewTab.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewTab.topAnchor.constraint(equalTo: viewTab.topAnchor, constant: 10),
            stackViewTab.leftAnchor.constraint(equalTo: viewTab.leftAnchor, constant: spaceHrzStackTab),
        ])
        stackTab2.translatesAutoresizingMaskIntoConstraints = false
        let hrzSpaceTabBtn2 = NSLayoutConstraint(item:stackTab2, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal,
             toItem:stackTab1,
             attribute: NSLayoutConstraint.Attribute.trailing,
        multiplier:1,
          constant:spcHrzStackTab2)
        NSLayoutConstraint.activate([hrzSpaceTabBtn2])
        
        let spaceVrtStackTab = ((defViewParentStack - defStackTabHeight) / 2)+4
        stackTab1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackTab1.topAnchor.constraint(equalTo: viewTab.topAnchor, constant: spaceVrtStackTab)
        ])
        widthBorderTab1 = Int(btnGallery.frame.width) + 20
        widthBorderTab2 = Int(btnCamera.frame.width) + 20
        posxBrdTab1 = Int(spaceHrzStackTab) - 10
        posxBrdTab2 = (Int(btnGallery.frame.width) + Int(spaceHrzStackTab*2)) - 10
        borderTab.backgroundColor = UIColor.systemBlue
        borderTab.frame = CGRect(x: posxBrdTab1, y: Int(posYTab)-4, width: widthBorderTab1, height: 4)
        setupSlideScrollView()
        btnAlbumName.setTitle(zeroAlbName, for: .normal)
        arrUpAlbum = []
        isShowDropDown = false
        view.isOpaque = false
        let tapBody = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBody(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapBody)
        waitLoadData()
        showWaitData()
    }
    
    func castCommunicate(comm: UIViewController) throws {
        guard let c = try comm as? CameraPhoto_Communicate else {
            throw CastError.showErrorCast(str: "Error Cast..")
        }
    }
    public func showPhotoGalleryAndCamera(comm: UIViewController) {
        var safeCast = true
        do {
            let test = try castCommunicate(comm: comm)
        } catch let error {
            safeCast = false
            methodHelper.showToast(view: comm.view, message: "Protocol extension doesn't implement yet!", font: .systemFont(ofSize: 12.0))
            return
        }
        if safeCast {
            let fmBundle = Bundle(for: type(of: self))
            let storyBoard: UIStoryboard = UIStoryboard(name: "Board_CameraPhoto", bundle: fmBundle)
            let presentedVC = storyBoard.instantiateViewController(withIdentifier: "CameraPhoto_ID") as! CameraPhoto
            presentedVC.delegateCommunicate = try comm as! CameraPhoto_Communicate
            let nvc = UINavigationController(rootViewController: presentedVC)
            comm.present(nvc, animated: false, pushing: true, completion: nil)
        }
    }
    
    func toPage(topage: Int){
        tapTabBtn = true
        let pageWidth:CGFloat = self.scrollView.frame.width
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        let slideToX = pageWidth * CGFloat(topage)
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        let m4 = 4
        if scrFromRight {
            let px = posxBrdTab2 + 10 + posxBrdTab1
            borderTab.frame = CGRect(x: px, y: Int(posYTab)-m4, width: widthBorderTab1, height: m4)
        }
        else {
            borderTab.frame = CGRect(x: posxBrdTab1, y: Int(posYTab)-m4, width: widthBorderTab1, height: m4)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
          guard let self = self else {return}
            if topage == 1 {
                self.MDBoardCamera.showCamera()
            }
            else {
                self.delegateIface?.permissionPhotoLibrary(first: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
          guard let self = self else {return}
            self.tapTabBtn = false
        }
    }
    
    @objc func handleTapBody(_ touch: UITapGestureRecognizer? = nil) {
        hideDropDownAlbum()
    }
    
    @objc func handleTapCellDropDown(sender: UITapGestureRecognizer) {
          let sentLabel = sender.view as? UILabel
          if let lbl = sentLabel {
            showWaitData()
            let tag = lbl.tag
            isShowDropDown = false
            dropDown.hideDropDown()
            btnAlbumName.setTitle(arrUpAlbum[tag], for: .normal)
            delegateIface?.tapItemAlbum(idx: tag, value: arrUpAlbum[tag])
        }
    }
    
    func showWaitData(){
        waitDataView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
          guard let self = self else {return}
            self.waitDataView.isHidden = true
        }
    }
    
    func setListener_MDCameraPhotoView(camPhotoVw: MDCameraPhotoView){
        camPhotoView = camPhotoVw
        camPhotoVw.delegateIface = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Call this in viewDidAppear to get correct frame values
        setUpDropDown()
    }
    
    public override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSlides() -> [SlidePageCameraPhoto] {
        let slide1:SlidePageCameraPhoto = Bundle.main.loadNibNamed("SlidePageCameraPhoto", owner: self, options: nil)?.first as! SlidePageCameraPhoto
        let sldHg = scrViewHg-hgBgHeader
        slide1.setViewWidthAndHeight(posY: 0, hgview: Int(sldHg))
        let slide2:SlidePageCameraPhoto = Bundle.main.loadNibNamed("SlidePageCameraPhoto", owner: self, options: nil)?.first as! SlidePageCameraPhoto
        slide2.setViewWidthAndHeight(posY: 0, hgview: Int(sldHg))
        return [slide1, slide2]
    }
        
    func setupSlideScrollView() {
        let fmBundle = Bundle(for: type(of: self))
        let posYSlide = Int(hgBgHeader) + yplusHeader
        scrollView.frame = CGRect(x: 0, y: CGFloat(posYSlide), width: CGFloat(view.frame.width), height: CGFloat(view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(2), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        let slide1:SlidePageCameraPhoto = fmBundle.loadNibNamed("SlidePageCameraPhoto", owner: self, options: nil)?.first as! SlidePageCameraPhoto
        let sldHg = scrViewHg-hgBgHeader
        slide1.setViewWidthAndHeight(posY: 0, hgview: Int(sldHg))
        slide1.setListener(camPhoto: self)
        slide1.frame = CGRect(x: view.frame.width * CGFloat(0), y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(slide1)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "MDBoardCamera", bundle: fmBundle)
        MDBoardCamera = storyBoard.instantiateViewController(withIdentifier: "MDCamera_ID") as! MDCamera
        MDBoardCamera.delegateCommunicate = self
        MDBoardCamera.view.frame = CGRect(x: view.frame.width * CGFloat(1), y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(MDBoardCamera.view)
    }
        
        
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tapTabBtn {
            return
        }
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.x > 0){
            scrFromRight = false
        }else{
            scrFromRight = true
        }
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        var xbrd = 0
        if scrFromRight {
            let px = posxBrdTab2 + 10
            let posactX = borderTab.frame.origin.x - CGFloat(posxBrdTab1)
            if posactX < CGFloat(px) {
                let offset = currentHorizontalOffset
                xbrd = posxBrdTab1+Int(offset)
                if offset <= CGFloat(px) {
                    borderTab.frame = CGRect(x: xbrd, y: Int(posYTab)-4, width: widthBorderTab1, height: 4)
                }
            }
        }
        else {
            let posactX = borderTab.frame.origin.x
            if posactX > CGFloat(posxBrdTab1) {
                xbrd = Int(currentHorizontalOffset) - ((posxBrdTab2+10)-posxBrdTab1)
                if CGFloat(xbrd) >= CGFloat(posxBrdTab1) {
                      borderTab.frame = CGRect(x: xbrd, y: Int(posYTab)-4, width: widthBorderTab1, height: 4)
                }
            }
        }
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        let velocity = scrollView.panGestureRecognizer.velocity(in: view)
        let velx = abs(velocity.x)
        let m4 = 4
        let s = 0.2
        if scrFromRight {
            let px = posxBrdTab2 + 10 + posxBrdTab1
            if velx > 300 {
                borderTab.frame = CGRect(x: px, y: Int(posYTab)-m4, width: widthBorderTab1, height: m4)
                DispatchQueue.main.asyncAfter(deadline: .now() + s) { [weak self] in
                  guard let self = self else {return}
                    self.MDBoardCamera.showCamera()
                }
            }
            if pageIndex == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + s) { [weak self] in
                  guard let self = self else {return}
                    self.MDBoardCamera.showCamera()
                }
            }
        }
        else {
            if velx > 300 {
                borderTab.frame = CGRect(x: posxBrdTab1, y: Int(posYTab)-m4, width: widthBorderTab1, height: m4)
                DispatchQueue.main.asyncAfter(deadline: .now() + s) { [weak self] in
                  guard let self = self else {return}
                    self.delegateIface?.permissionPhotoLibrary(first: false)
                }
            }
            if pageIndex == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + s) { [weak self] in
                  guard let self = self else {return}
                    self.delegateIface?.permissionPhotoLibrary(first: false)
                }
            }
        }
    }
        
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
    }
    
    func setUpDropDown(){
        let fmBundle = Bundle(for: type(of: self))
        dropDown.makeDropDownIdentifier = "DROP_DOWN_NEW"
        dropDown.cellReusableIdentifier = "dropDownCell"
        dropDown.makeDropDownDataSourceProtocol = self
        dropDown.setUpDropDown(viewPositionReference: (btnAlbumName.frame), offset: 2)
        dropDown.nib = UINib(nibName: "TableDropDownAlbum", bundle: fmBundle)
        dropDown.setRowHeight(height: self.dropDownRowHeight)
        self.view.addSubview(dropDown)
    }
    
    func hideDropDownAlbum(){
        if isShowDropDown {
            isShowDropDown = false
            dropDown.hideDropDown()
        }
    }
    
    func waitLoadData(){
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .curveEaseOut],
        animations: {
            self.waitDataView.center.x += self.view.bounds.width
        }, completion: {(finished : Bool) in
            if(finished){}
        })
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
