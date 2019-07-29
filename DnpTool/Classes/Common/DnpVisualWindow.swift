//
//  DnpVisualWindow.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/27.
//

import UIKit

class DnpVisualWindow: UIWindow {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = screenScale(x: 8)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.dnp_colorWithHex(hex: 0x999999, alpha: 0.2).cgColor
        self.windowLevel = UIWindow.Level.alert
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        self.addGestureRecognizer(pan)
    }
    
    override func becomeKey() {
        let appWindow = UIApplication.shared.delegate?.window
        if let window = appWindow {
            window?.makeKey()
        }
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let panView = sender.view  else {
            return
        }
        if !panView.isHidden{
            let offsetPoint = sender.translation(in: sender.view)
            sender.setTranslation(.zero, in: sender.view)
            let newX: CGFloat = panView.center.x + offsetPoint.x
            let newY: CGFloat = panView.center.y + offsetPoint.y
            let centerPoint: CGPoint = CGPoint(x: newX, y: newY)
            panView.center = centerPoint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
