//
//  DnpFpsView.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/28.
//

import UIKit

class DnpFpsView: UIView {
    
    var viewInfoWindow: DnpVisualWindow!
    var fpsLabel: DnpFPSLabel!
    var boxView : UIView!
    
    init() {
        let rect = CGRect(x: 0, y: 0, width: screenwidth, height: screenheight)
        super.init(frame: rect)
        self.backgroundColor = UIColor.clear
        self.layer.zPosition = CGFloat(FLT_MAX)
        
        boxView = UIView(frame: CGRect(x: screenScale(x: 5), y: navigationHeight, width: 60, height: 20))
        boxView.layer.cornerRadius = 4
        boxView.layer.masksToBounds = true
        boxView.backgroundColor = UIColor(white: 1.0, alpha: 0)
        self.addSubview(boxView)
        
        fpsLabel = DnpFPSLabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        boxView.addSubview(fpsLabel)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        boxView.addGestureRecognizer(pan)
    }
    
    @objc func pan(sender:UIPanGestureRecognizer) {
        let offsetPoint = sender.translation(in: sender.view)
        sender.setTranslation(.zero, in: sender.view)
        
        var newx: CGFloat = 0.0
        var newy: CGFloat = 0.0
        if let panView = sender.view {
            newx = panView.center.x + offsetPoint.x
            newy = panView.center.y + offsetPoint.y
            let centerPoint = CGPoint(x: newx, y: newy)
            panView.center = centerPoint
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if boxView.frame.contains(point) {
            return true
        }
        return false
    }
    
    internal func show() {
        self.fpsLabel.start()
        self.isHidden = false
    }
    
    internal func hide() {
        self.fpsLabel.end()
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
