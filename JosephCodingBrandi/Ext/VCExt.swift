//
//  VCExt.swift
//  JosephCodingBrandi
//
//  Created by Joseph_iMac on 2020/12/30.
//

import UIKit
import Foundation
import PKHUD
import Alamofire

let date = Date()

extension UIViewController
{
    func showProgress()
    {
        HUD.allowsInteraction = false
        HUD.dimsBackground = true
        HUD.show(.progress)
    }
    
    func hideProgress()
    {
        HUD.hide()
    }
    
    func showAlert(message:String)
    {
        let alertController = UIAlertController(title: "알림", message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default,handler: { Void in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    var apiControl:ApiControl {
        get {
            return ApiControl.shared
        }
    }
}

extension UIView {
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
