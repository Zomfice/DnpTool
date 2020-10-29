//
//  DnpToolEnterView.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/30.
//

import UIKit

class DnpToolEnterView: UIWindow {

    var isOpen: Bool = false
    var entryButton = UIButton()
    var kEntryViewSize: CGFloat = 0.0
    
    init() {
        kEntryViewSize = screenScale(x: 80)//116
        let rect = CGRect(x: 0, y: screenheight * 0.8 , width: kEntryViewSize, height: kEntryViewSize)
        if #available(iOS 13, *),let scene = UIApplication.shared.keyWindow?.windowScene {
            super.init(windowScene: scene)
        } else {
            super.init(frame: rect)
        }
        self.backgroundColor = UIColor.clear
        
        self.windowLevel = UIWindow.Level.statusBar + 100.0
        let version = UIDevice.current.systemVersion as NSString
        if version.doubleValue >= 10.0{
            if self.rootViewController == nil{
                self.rootViewController = UIViewController()
            }
        }else{
            if self.rootViewController == nil{
                self.rootViewController = DnpToolStatusBarController()
            }
        }
        let entryBtn = UIButton(frame: self.bounds)
        entryBtn.backgroundColor = UIColor.clear
        entryBtn.setImage(UIImage.imageName(name: "dnptool_enter"), for: .normal)
        //entryBtn.layer.cornerRadius = 20
        entryBtn.addTarget(self, action: #selector(entryClick(sender:)), for: .touchUpInside)
        self.rootViewController?.view.addSubview(entryBtn)
        entryButton = entryBtn
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        self.addGestureRecognizer(pan)
    }
    
    override func becomeKey() {
        let appWindow = UIApplication.shared.delegate?.window
        if let window = appWindow{
            window?.makeKey()
        }
    }
    
    @objc func entryClick(sender:UIButton) {
        if DnpToolHomeWindow.shareInstance.isHidden{
            DnpToolHomeWindow.shareInstance.show()
        }else{
            DnpToolHomeWindow.shareInstance.hide()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CloseNotification), object: nil, userInfo: nil)
    }
    
    @objc func pan(sender:UIPanGestureRecognizer) {
        let offsetPoint = sender.translation(in: sender.view)
        sender.setTranslation(.zero, in: sender.view)
        
        if let panView = sender.view{
            var newX = panView.center.x + offsetPoint.x
            var newY = panView.center.y + offsetPoint.y
            if newX < kEntryViewSize/2{
                newX = kEntryViewSize/2
            }
            if newX > (screenwidth - kEntryViewSize/2){
                newX = screenwidth - kEntryViewSize/2
            }
            if newY < kEntryViewSize/2{
                newY = kEntryViewSize/2
            }
            if newY > (screenheight - kEntryViewSize/2){
                newY = screenheight - kEntryViewSize/2
            }
            panView.center = CGPoint(x: newX, y: newY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
