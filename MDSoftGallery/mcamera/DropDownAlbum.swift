//
//  DropDownAlbum.swift
//  SimpleApp4
//
//  Created by maedi laziman on 29/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol DropDownAlbum_Interface{
    func getDataToDropDownAlbum(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String)
    func numberOfRowsAlbum(makeDropDownIdentifier: String) -> Int
    func selectItemInDropDownAlbum(indexPos: Int, makeDropDownIdentifier: String)
}

class DropDownAlbum: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var makeDropDownIdentifier: String = "DROP_DOWN"
     // Reuse Identifier of your custom cell
     var cellReusableIdentifier: String = "DROP_DOWN_CELL"
     // Table View
     var dropDownTableView: UITableView?
     var width: CGFloat = 0
     var offset:CGFloat = 0
     var makeDropDownDataSourceProtocol: DropDownAlbum_Interface?
     var nib: UINib?{
         didSet{
             dropDownTableView?.register(nib, forCellReuseIdentifier: self.cellReusableIdentifier)
         }
     }
     // Other Variables
     var viewPositionRef: CGRect?
     var isDropDownPresent: Bool = false
    
    var widthCell: CGFloat!
    var heightCell: CGFloat!
    
     
     //MARK: - DropDown Methods
     
     // Make Table View Programatically
     
     func setUpDropDown(viewPositionReference: CGRect,  offset: CGFloat){
         self.addBorders()
         self.addShadowToView()
         self.frame = CGRect(x: viewPositionReference.minX, y: viewPositionReference.maxY + offset, width: 0, height: 0)
         dropDownTableView = UITableView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: 0, height: 0))
         self.width = viewPositionReference.width
         self.offset = offset
         self.viewPositionRef = viewPositionReference
         dropDownTableView?.showsVerticalScrollIndicator = false
         dropDownTableView?.showsHorizontalScrollIndicator = false
         dropDownTableView?.backgroundColor = .white
        dropDownTableView?.separatorStyle = .none
         dropDownTableView?.delegate = self
         dropDownTableView?.dataSource = self
         dropDownTableView?.allowsSelection = true
         dropDownTableView?.isUserInteractionEnabled = true
         dropDownTableView?.tableFooterView = UIView()
         self.addSubview(dropDownTableView!)
         
     }
     
    func showDropDown(heightdd: CGFloat, widthdd: CGFloat) -> Bool{
         isDropDownPresent = true
         self.frame = CGRect(x: (self.viewPositionRef?.minX)!, y: 0, width: 0, height: 0)
          self.dropDownTableView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
          self.dropDownTableView?.reloadData()
          widthCell = widthdd
          UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05, options: .curveLinear
              , animations: {
              self.frame.size = CGSize(width: widthdd, height: heightdd)
              self.dropDownTableView?.frame.size = CGSize(width: widthdd, height: heightdd)
          })
         return isDropDownPresent
     }
     
     func reloadDropDown(height: CGFloat){
         self.frame = CGRect(x: (self.viewPositionRef?.minX)!, y: (self.viewPositionRef?.maxY)!
             + self.offset, width: width, height: 0)
         self.dropDownTableView?.frame = CGRect(x: 0, y: 0, width: width, height: 0)
         self.dropDownTableView?.reloadData()
         UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05, options: .curveLinear
             , animations: {
             self.frame.size = CGSize(width: self.width, height: height)
             self.dropDownTableView?.frame.size = CGSize(width: self.width, height: height)
         })
     }
     
     func setRowHeight(height: CGFloat){
        heightCell = height
         self.dropDownTableView?.rowHeight = height
         self.dropDownTableView?.estimatedRowHeight = height
     }
     
     func hideDropDown(){
         isDropDownPresent = false
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear
             , animations: {
             self.frame.size = CGSize(width: 0, height: 0)
             self.dropDownTableView?.frame.size = CGSize(width: 0, height: 0)
         })
     }
     
     func removeDropDown(){
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear
             , animations: {
             self.dropDownTableView?.frame.size = CGSize(width: 0, height: 0)
         }) { (_) in
             self.removeFromSuperview()
             self.dropDownTableView?.removeFromSuperview()
         }
     }

    
}


extension DropDownAlbum: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (makeDropDownDataSourceProtocol?.numberOfRowsAlbum(makeDropDownIdentifier: self.makeDropDownIdentifier) ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (dropDownTableView?.dequeueReusableCell(withIdentifier: self.cellReusableIdentifier) ?? UITableViewCell())
        cell.frame.size = CGSize(width: widthCell, height: heightCell)
        let customCell = cell as! TableDropDownAlbum
        customCell.labelTitle.frame.size = CGSize(width: widthCell, height: 28)
        customCell.borderBottomLabel.frame.size = CGSize(width: widthCell, height: 1)
        makeDropDownDataSourceProtocol?.getDataToDropDownAlbum(cell: cell, indexPos: indexPath.row, makeDropDownIdentifier: self.makeDropDownIdentifier)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        makeDropDownDataSourceProtocol?.selectItemInDropDownAlbum(indexPos: indexPath.row, makeDropDownIdentifier: self.makeDropDownIdentifier)
    }
}

extension UIView{
    func addBordersDropDownAlbum(borderWidth: CGFloat = 0.2, borderColor: CGColor = UIColor.lightGray.cgColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
        
    func addShadowDropDownAlbum(shadowRadius: CGFloat = 2, alphaComponent: CGFloat = 0.6) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaComponent).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
    }
}


