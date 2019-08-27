//
//  DnpRulerView.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/27.
//

import UIKit

class DnpRulerView: UIView {
    
    let lineColor = UIColor.magenta
    let viewRulerSize: CGFloat = 62
    var imageView : UIImageView!
    var h_line : UIView!
    var v_line : UIView!
    var leftLb : UILabel!
    var topLb  : UILabel!
    var rightLb: UILabel!
    var bottomLb: UILabel!
    
    var viewInfoWindow: DnpVisualWindow!
    var infoLb : UILabel!
    var closeBtn: UIButton!
    
    init() {
        let rect = CGRect(x: 0, y: 0, width: screenwidth, height: screenheight)
        super.init(frame: rect)
        self.backgroundColor = UIColor.clear
        self.layer.zPosition = CGFloat(FLT_MAX)
        
        imageView = UIImageView(frame: CGRect(x: screenwidth/2 - viewRulerSize/2 , y: screenheight/2 - viewRulerSize/2, width: viewRulerSize, height: viewRulerSize))
        imageView.image = UIImage.imageName(name: "dnptool_visual")
        self.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pangesture(sender:)))
        imageView.addGestureRecognizer(pan)
        
        h_line = UIView(frame: CGRect(x: 0, y: imageView.center.y - 0.25, width: self.frame.size.width, height: 0.5))
        h_line.backgroundColor = lineColor
        self.addSubview(h_line)
        
        v_line = UIView(frame: CGRect(x: imageView.center.x-0.25, y: 0, width: 0.5, height: self.frame.size.height))
        v_line.backgroundColor = lineColor
        self.addSubview(v_line)
        
        self.bringSubviewToFront(imageView)
        
        leftLb = UILabel()
        leftLb.font = UIFont.systemFont(ofSize: 12)
        leftLb.textColor = lineColor
        leftLb.text = String(format: "%0.1f", imageView.center.x)
        self.addSubview(leftLb)
        leftLb.sizeToFit()
        leftLb.frame = CGRect(x: imageView.center.x/2, y: imageView.center.y-leftLb.frame.size.height, width: leftLb.frame.size.width, height: leftLb.frame.size.height)
        
        topLb = UILabel()
        topLb.font = UIFont.systemFont(ofSize: 12)
        topLb.textColor = lineColor
        topLb.text = String(format: "%0.1f", imageView.center.y)
        self.addSubview(topLb)
        topLb.sizeToFit()
        topLb.frame = CGRect(x: imageView.center.x-topLb.frame.size.width, y: imageView.center.y/2, width: topLb.frame.size.width, height: topLb.frame.size.height)
        
        rightLb = UILabel()
        rightLb.font = UIFont.systemFont(ofSize: 12)
        rightLb.textColor = lineColor
        rightLb.text = String(format: "%0.1f", self.frame.size.width - imageView.center.x)
        self.addSubview(rightLb)
        rightLb.sizeToFit()
        rightLb.frame = CGRect(x: imageView.center.x + (self.frame.size.width-imageView.center.x)/2, y: imageView.center.y-rightLb.frame.size.height, width: rightLb.frame.size.width, height: rightLb.frame.size.height)
        
        bottomLb = UILabel()
        bottomLb.font = UIFont.systemFont(ofSize: 12)
        bottomLb.textColor = lineColor
        bottomLb.text = String(format: "%0.1f", self.frame.size.height - imageView.center.y)
        self.addSubview(bottomLb)
        bottomLb.sizeToFit()
        bottomLb.frame = CGRect(x: imageView.center.x - bottomLb.frame.size.width , y: imageView.center.y+(self.frame.size.height-imageView.center.y)/2, width: bottomLb.frame.size.width, height: bottomLb.frame.size.height)
        
        viewInfoWindow = DnpVisualWindow(frame: CGRect(x: screenScale(x: 30), y: statusbarHeight, width: screenwidth-2*screenScale(x: 30), height: screenScale(x: 100)))
        viewInfoWindow.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let closeWidth: CGFloat = screenScale(x: 44)
        closeBtn = UIButton(frame: CGRect(x: viewInfoWindow.bounds.size.width - closeWidth-screenScale(x: 10), y: (viewInfoWindow.bounds.size.height-closeWidth)/2.0, width: closeWidth, height: closeWidth))
        
        closeBtn.setBackgroundImage(UIImage.imageName(name: "dnptool_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked(sender:)), for: .touchUpInside)
        viewInfoWindow.addSubview(closeBtn)
        
        infoLb = UILabel(frame: CGRect(x: screenScale(x: 10), y: screenScale(x: 10), width: viewInfoWindow.bounds.size.width-screenScale(x: 20)-closeBtn.frame.size.width, height: viewInfoWindow.bounds.size.height-2*screenScale(x: 10)))
        infoLb.backgroundColor = UIColor.clear
        infoLb.numberOfLines = 0
        infoLb.textColor = lineColor
        infoLb.font = UIFont.systemFont(ofSize: screenScale(x: 24))
        self.configinfo()
        viewInfoWindow.addSubview(infoLb)

    }
    
    @objc func pangesture(sender:UIPanGestureRecognizer) {
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
        
        h_line.frame = CGRect(x: 0, y: imageView.center.y-0.25, width: self.frame.size.width, height: 0.5)
        v_line.frame = CGRect(x: imageView.center.x-0.25, y: 0, width: 0.5, height: self.frame.size.height)
        leftLb.text = String(format: "%0.1f", imageView.center.x)
        leftLb.sizeToFit()
        leftLb.frame = CGRect(x: imageView.center.x/2, y: imageView.center.y-leftLb.frame.size.height, width: leftLb.frame.size.width, height: leftLb.frame.size.height)
        
        topLb.text = String(format: "%0.1f", imageView.center.y)
        topLb.sizeToFit()
        topLb.frame = CGRect(x: imageView.center.x-topLb.frame.size.width, y: imageView.center.y/2, width: topLb.frame.size.width, height: topLb.frame.size.height)
        
        rightLb.text = String(format: "%0.1f",self.frame.size.width - imageView.center.x)
        rightLb.sizeToFit()
        rightLb.frame = CGRect(x: imageView.center.x+(self.frame.size.width-imageView.center.x)/2, y: imageView.center.y-rightLb.frame.size.height, width: rightLb.frame.size.width, height: rightLb.frame.size.height)
        
        bottomLb.text = String(format: "%0.1f",self.frame.size.height - imageView.center.y)
        bottomLb.sizeToFit()
        bottomLb.frame = CGRect(x: imageView.center.x-bottomLb.frame.size.width, y: imageView.center.y+(self.frame.size.height-imageView.center.y)/2, width: bottomLb.frame.size.width, height: bottomLb.frame.size.height)
        
        self.configinfo()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if imageView.frame.contains(point) {
            return true
        }
        return false
    }
    
    private func configinfo() {
        let infotext = "坐标: Top:\(topLb.text ?? "")  Left:\(leftLb.text ?? "")  Bottom:\(bottomLb.text ?? "")  Right:\(rightLb.text ?? "") "
        infoLb.text = infotext
        self.labelHeight(text: infotext)
    }
    
    func labelHeight(text: String?) {
        guard let str = text else {
            return
        }
        let string = str as NSString
        let size = string.calculateSize(limitSize: CGSize(width: viewInfoWindow.bounds.size.width - screenScale(x: 15) - screenScale(x: 44), height: CGFloat(MAXFLOAT)), font: UIFont.systemFont(ofSize: screenScale(x: 24)), lineSpace: screenScale(x: 12))
        
        var infoLabelFrame = infoLb.frame
        infoLabelFrame.size.height = size.height
        infoLb.frame = infoLabelFrame
        
        var infoWindowFrame = viewInfoWindow.frame
        let height = size.height < screenScale(x: 44) ? screenScale(x: 44) : size.height
        infoWindowFrame.size.height = height+2*screenScale(x: 10)
        viewInfoWindow.frame = infoWindowFrame
        
        
        var closeFrame = closeBtn.frame
        closeFrame.origin.y = screenScale(x: 10)
        closeBtn.frame = closeFrame
    }
    
    @objc func closeBtnClicked(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(DnpRulerView.self)"), object: nil, userInfo: nil)
    }
    
    
    internal func show() {
        viewInfoWindow.isHidden = false
        self.isHidden = false
    }
    
    internal func hide() {
        viewInfoWindow.isHidden = true
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
