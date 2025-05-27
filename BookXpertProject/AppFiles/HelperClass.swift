//
//  HelperClass.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

import UIKit
import ObjectiveC
import Alamofire

class NetworkConnectivity {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}

//class HelperClass{
//    static let shared = HelperClass()
//    
//    
//}

class  URLConstants {
    
    static let getMobileModelUrl = "https://api.restful-api.dev/objects"
    
    static let accessToken = ""
}


class ColorHelper {
    static let instance = ColorHelper()
    
    let blackColorCode           = "#000000"
    let whiteColorCode           = "#FFFFFF"
    
    func getBlackColor() -> UIColor {
        return UIColor(hexCode: self.blackColorCode)
    }
    
    func getWhiteColor() -> UIColor {
        return UIColor(hexCode: self.whiteColorCode)
    }
    
    func checkMoileIsDarkAppearance() ->Bool{
        if UITraitCollection.current.userInterfaceStyle == .dark {
            print("Dark mode is enabled")
            return true
        }
        return false
    }
}

class BorderView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


extension UIColor {
    public convenience init(hexCode: String) {
        let hexString = hexCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let red = Int(color >> 16) & mask
        let green = Int(color >> 8) & mask
        let blue = Int(color) & mask
        
        let red1   = CGFloat(red) / 255.0
        let green1 = CGFloat(green) / 255.0
        let blue1  = CGFloat(blue) / 255.0
        
        self.init(red: red1, green: green1, blue: blue1, alpha: 1)
    }
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        guard hexSanitized.count == 6 else {
            self.init(cgColor: UIColor.clear.cgColor)
            return
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}



private var activityIndicatorKey: UInt8 = 0

extension UIViewController {

    var activityIndicator: UIActivityIndicatorView {
        get {
            if let indicator = objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView {
                return indicator
            } else {
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.center = self.view.center
                indicator.hidesWhenStopped = true
                self.view.addSubview(indicator)
                objc_setAssociatedObject(self, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return indicator
            }
        }
    }

    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 15, weight: .bold)) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height-150, width: 350, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
