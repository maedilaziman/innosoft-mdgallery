//
//  MethodHelper.swift
//  SimpleApp4
//
//  Created by maedi laziman on 30/06/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

var methodHelper = MethodHelper()

class MethodHelper {
    
    func backNavLeft(view : UIView, controll: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(transition, forKey: nil)
        controll.dismiss(animated: false, completion: nil)
    }
    
    func showToast(view : UIView, message : String, font: UIFont) {
        let toastLabel = UITextView(frame: CGRect(x: getWidthWindow()/2 - 75, y: getHeightWindow()/2, width: 150, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.8, delay: 1.5, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func defCardView(vw: UIView) -> UIView {
        let cornerRadius: CGFloat = 2
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 3
        let shadowOpacity: Float = 0.5
        
        vw.backgroundColor = UIColor.white
        vw.layer.cornerRadius = cornerRadius
        vw.layer.masksToBounds = false
        vw.layer.shadowColor = UIColor.black.cgColor
        vw.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        vw.layer.shadowOpacity = shadowOpacity
        vw.layer.shadowPath = UIBezierPath(roundedRect: vw.bounds, cornerRadius: cornerRadius).cgPath
        
        return vw
    }
    
    func defTextView(textView: UITextView) -> UITextView {
        textView.backgroundColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.font = UIFont(name: "Verdana", size: 17)
        textView.textColor = UIColor.black
        textView.isEditable = false
        return textView
    }
    
    func showStoryBoard(vc: UIViewController, boardName: String, identifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let presentedVC = storyBoard.instantiateViewController(withIdentifier: identifier)
        let nvc = UINavigationController(rootViewController: presentedVC)
        vc.present(nvc, animated: false, pushing: true, completion: nil)
    }
    
    func removeZeroInFront(v: String) -> String{
        var s: String = ""
        switch v {
        case "01":
            s = "1"
            break
        case "02":
            s = "2"
            break
        case "03":
            s = "3"
            break
        case "04":
            s = "4"
            break
        case "05":
            s = "5"
            break
        case "06":
            s = "6"
            break
        case "07":
            s = "7"
            break
        case "08":
            s = "8"
            break
        case "09":
            s = "9"
            break
        default:
            s = v
            break
        }
        return s
    }
    
    func getWidthWindow() -> Int{
        return Int(UIScreen.main.bounds.width)
    }
    
    func getHeightWindow() -> Int{
        return Int(UIScreen.main.bounds.height)
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func updateHeightScrollView(scrollview: UIScrollView, paddingBottom: CGFloat){
        var heightDync : CGFloat = 0
        for view: UIView in scrollview.subviews {
             heightDync += view.frame.height + paddingBottom
        }
        
        scrollview.contentSize = CGSize(width: CGFloat(methodHelper.getWidthWindow()), height: heightDync)
    }
    
    func disabledHorizontalScrollview(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "null uuid"
    }
    
    func getIosVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // get preferences
    static func getPrefValue1<T>(defaultValue: T, forKey key: String) -> T{

        let preferences = UserDefaults.standard
        return preferences.object(forKey: key) == nil ? defaultValue : preferences.object(forKey: key) as! T
    }

    // set preferences
    static func setPrefValue1(value: Any, forKey key: String){

        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func setPrefAccessToken(access_token: String, token_type: String, refresh_token: String, scope: String){
        let preferences = UserDefaults.standard
        preferences.set(access_token, forKey: "access_token")
        preferences.set(token_type, forKey: "token_type")
        preferences.set(refresh_token, forKey: "refresh_token")
        preferences.set(scope, forKey: "scope")
        didSave(preferences: preferences)
    }
    
    static func getPrefAccessToken() -> String{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "access_token") != nil{
            let access_token = preferences.string(forKey: "access_token")
            return access_token!
        } else {
            return ""
        }
    }
    
    // Checking the UserDefaults is saved or not
    static func didSave(preferences: UserDefaults){
        let didSave = preferences.synchronize()
        if !didSave{
            // Couldn't Save
            print("Preferences could not be saved!")
        }
    }

}

extension UIView{
    func addBorders(borderWidth: CGFloat = 0.2, borderColor: CGColor = UIColor.lightGray.cgColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
    func addShadowToView(shadowRadius: CGFloat = 2, alphaComponent: CGFloat = 0.6) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaComponent).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
    }
}
