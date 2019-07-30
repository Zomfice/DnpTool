//
//  DnpCommon.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/27.
//

import Foundation
import UIKit

internal let screenwidth = UIScreen.main.bounds.width
internal let screenheight = UIScreen.main.bounds.height

internal let navigationHeight = iphoneX ? 88 : 64

internal let statusbarHeight = iphoneX ? 44.0 : 20.0

internal let tabBarHeight: CGFloat = iphoneX ? 83.0 : 49.0

internal let bottomSafeArea: CGFloat = iphoneX ? 34 : 0

internal let navigationbarHeight: CGFloat = 44.0

/// 根据750*1334分辨率计算size
internal func screenScale(x: CGFloat) -> CGFloat {
    return x * screenwidth / 750
}

/// iphoneX
internal var iphoneX: Bool{
    var iphonex = false
    if UIDevice.current.userInterfaceIdiom != .phone{
        return false
    }
    if #available(iOS 11, *) {
        let mainWindow = UIApplication.shared.delegate?.window
        if let window = mainWindow,let bottom = window?.safeAreaInsets.bottom, bottom > CGFloat(0.0){
            iphonex = true
        }
    }
    return iphonex
}

extension UIColor{
    static func dnp_colorWithHex(hex: Int32,alpha: CGFloat)-> UIColor {
        return UIColor(red: CGFloat(((hex >> 16) & 0xFF))/255.0, green: CGFloat(((hex >> 8) & 0xFF))/255.0, blue: CGFloat((hex & 0xFF))/255.0, alpha: alpha)
    }
    static func rgb(red: CGFloat,green: CGFloat,blue: CGFloat,alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

class DnpToolCommon {
    
}


/// 当前资源Bundle
internal class DnpBundle {
    static func getBundlePath(resource name: String,ofType type: String) -> String? {
        var bundle = Bundle(for: DnpToolCommon.self)
        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/DnpTool.bundle") {
            bundle = resourceBundle
        }
        return bundle.path(forResource: name, ofType: type)
    }
}

/// Bundle中图片
extension UIImage {
    static func imageName(name: String) -> UIImage? {
        var imageName = name
        let scale = UIScreen.main.scale
        if abs(scale - 3) <= 0.001 {
            imageName = name + "@3x"
        }else if abs(scale - 2) <= 0.001 {
            imageName = name + "@2x"
        }
        var image: UIImage? = nil
        if let m_path = DnpBundle.getBundlePath(resource: imageName, ofType: "png") {
            image = UIImage(contentsOfFile: m_path)
        }
        if image == nil {
            image = UIImage(named: name)
        }
        return image
    }
}

extension NSObject{
    var classname: String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
        }
    }
}


extension CGFloat {
    func format(f: String = ".1") -> String {
        return String(format: "%\(f)f", self)
    }
}

extension Int{
    func hex(f: String = "%02X") -> String {
        return String(format: "\(f)", self)
    }
}

extension NSString{
    func calculateSize(limitSize: CGSize,font: UIFont,lineSpace: CGFloat) -> CGSize {
        var attributes = [NSAttributedString.Key: Any]()
        if lineSpace > 0{
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            attributes = [NSMutableAttributedString.Key.paragraphStyle : style,
                          NSMutableAttributedString.Key.font : font]
        }else{
            attributes = [NSMutableAttributedString.Key.font : font]
        }
        return self.boundingRect(with: limitSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
}

public let ShowNotification = "ShowPluginNotification"
public let CloseNotification = "ClosePluginNotification"
