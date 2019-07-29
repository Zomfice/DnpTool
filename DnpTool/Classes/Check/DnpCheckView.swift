//
//  DnpCheckView.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/27.
//

import UIKit
import CoreGraphics

class DnpCheckView: UIView {

    let viewCheckSize: CGFloat = 62
    var viewBound : UIView!
    var viewInfoWindow: DnpVisualWindow!
    var viewInfoLabel: UILabel!
    var closeBtn: UIButton!
    var left : CGFloat = 0
    var top : CGFloat = 0
    var arrViewHit = [UIView]()
    

    override init(frame: CGRect) {
        let m_frame = CGRect(x: screenwidth/2 - viewCheckSize/2, y: screenheight/2 - viewCheckSize/2, width: viewCheckSize, height: viewCheckSize)
        super.init(frame: m_frame)
        self.frame = m_frame
        self.backgroundColor = UIColor.clear
        self.layer.zPosition = CGFloat.greatestFiniteMagnitude
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage.imageName(name: "doraemon_visual")
        self.addSubview(imageView)
        
        viewBound = UIView()
        viewBound.layer.masksToBounds = true
        viewBound.layer.borderWidth = 2
        viewBound.layer.borderColor = UIColor.dnp_colorWithHex(hex: 0xCC3A4B, alpha: 1).cgColor
        viewBound.layer.zPosition = CGFloat.greatestFiniteMagnitude
        
        viewInfoWindow = DnpVisualWindow(frame: CGRect(x: screenScale(x: 30), y: screenheight - screenScale(x: 210) - screenScale(x: 30), width: screenwidth - 2*screenScale(x: 30), height: screenScale(x: 210)))
        
        viewInfoWindow.makeKeyAndVisible()
        viewInfoWindow.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.window?.makeKeyAndVisible()
        }
        
        let closeWidth = screenScale(x: 44)
        let closeHeight = screenScale(x: 44)
        closeBtn = UIButton(frame: CGRect(x: viewInfoWindow.bounds.size.width - closeWidth - screenScale(x: 32), y: screenScale(x: 18), width: closeWidth, height: closeHeight))
        closeBtn.setBackgroundImage(UIImage.imageName(name: "doraemon_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked(sender:)), for: .touchUpInside)
        viewInfoWindow.addSubview(closeBtn)
        
        viewInfoLabel = UILabel(frame: CGRect(x: screenScale(x: 32), y: screenScale(x: 10), width: viewInfoWindow.bounds.size.width - 2*screenScale(x: 32) - closeBtn.bounds.size.width, height: viewInfoWindow.bounds.size.height - 2*screenScale(x: 10)))
        viewInfoLabel.numberOfLines = 0
        viewInfoLabel.backgroundColor = UIColor.clear
        viewInfoLabel.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        viewInfoLabel.font = UIFont.systemFont(ofSize: screenScale(x: 24))
        viewInfoWindow.addSubview(viewInfoLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        
        left = point?.x ?? 0
        top = point?.y ?? 0
        let topPoint = touch?.location(in: self.window)
        if let view = self.topView(view: self.window, point: topPoint ?? .zero),let frame = self.window?.convert(view.bounds, from: view){
            viewBound.frame = frame
            self.window?.addSubview(viewBound)
            viewInfoLabel.attributedText = viewInfo(view: view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self.window) ?? .zero
        self.frame = CGRect(x: point.x - left, y: point.y - top, width: self.frame.size.width, height: self.frame.size.height)
        
        let topPoint = touch?.location(in: self.window) ?? .zero
        let view = self.topView(view: self.window, point: topPoint)
        let frame = self.window?.convert(view?.bounds ?? .zero, from: view) ?? .zero
        viewBound.frame = frame
        viewInfoLabel.attributedText = self.viewInfo(view: view)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewBound.removeFromSuperview()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewBound.removeFromSuperview()
    }
    
    
    func topView(view: UIView?,point: CGPoint) -> UIView? {
        guard let m_view = view else {
            return nil
        }
        arrViewHit.removeAll()
        self.hitTest(view: m_view, point: point)
        let viewTop = arrViewHit.last
        arrViewHit.removeAll()
        return viewTop
    }
    
    func hitTest(view: UIView?,point: CGPoint) {
        guard let m_view = view else {
            return
        }
        var m_point = point
        if m_view.isKind(of: UIScrollView.self),let scrollView = m_view as? UIScrollView{
            m_point.x += scrollView.contentOffset.x
            m_point.y += scrollView.contentOffset.y
        }
        if m_view.point(inside: m_point, with: nil),m_view.isHidden == false,m_view.alpha >= 0.01,m_view != viewBound,!m_view.isDescendant(of: self){
            arrViewHit.append(m_view)
            for subView in m_view.subviews{
                let subPoint = CGPoint(x: point.x - subView.frame.origin.x, y: point.y - subView.frame.origin.y)
                self.hitTest(view: subView, point: subPoint)
            }
        }
    }
    
    func viewInfo(view: UIView?) -> NSMutableAttributedString? {
        guard let m_view = view else {
            return nil
        }
        let showString = NSMutableString()
        var tempString = "控件名称:" + "\(m_view.classname)"
        showString.append(tempString)
        
        tempString = "\n控件位置: " + "左\(m_view.frame.origin.x.format())" + "上\(m_view.frame.origin.y.format())" + "宽\(m_view.frame.size.width.format())" + "高\(m_view.frame.size.height.format())"
        showString.append(tempString)
        
        if m_view.isKind(of: UILabel.self){
            if let label = m_view as? UILabel{
                tempString = "\n背景颜色: \(hexFromUIColor(color: label.backgroundColor))" + "字体颜色: \(hexFromUIColor(color: label.textColor))" + "字体大小: \(label.font.pointSize.format())"
                showString.append(tempString)
            }
        }else if m_view.isMember(of: UIView.self){
            tempString = "\n背景颜色: \(hexFromUIColor(color: m_view.backgroundColor))" + "\(rgbFromUIColor(color: m_view.backgroundColor))"
            showString.append(tempString)
        }
        
        let string: String = showString as String
        let style = NSMutableParagraphStyle()
        style.lineSpacing = screenScale(x: 12)
        style.lineBreakMode = .byTruncatingTail
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttributes([NSMutableAttributedString.Key.paragraphStyle : style,
                                  NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: screenScale(x: 24)),
                                  NSMutableAttributedString.Key.foregroundColor : UIColor.rgb(red: 51, green: 51, blue: 51)
                                 ], range: NSRange(location: 0, length: string.count))
        return attrString
    }
    
    func hexFromUIColor(color: UIColor?) -> String {
        guard var m_color = color else {
            return "nil"
        }
        
        if m_color == UIColor.clear{
            return "clear"
        }
        if m_color.cgColor.numberOfComponents < 4 {
            let components = m_color.cgColor.components
            if let m_components = components{
                m_color = UIColor(red: m_components[0], green: m_components[0], blue: m_components[0], alpha: m_components[1])
            }
        }
        
        if let colorspace = m_color.cgColor.colorSpace, colorspace.model != .rgb{
            return "单色色彩空间模式"
        }
        
        var hex = String()
        if let components = m_color.cgColor.components{
            let red = Int(components[0]*255.0)
            let green = Int(components[1]*255.0)
            let blue = Int(components[2]*255.0)
            let alpha = Int(components[3]*255.0)
    
            hex = "#\(red.hex())" + "\(green.hex())" + "\(blue.hex())"
            if alpha < 255{
                hex = hex + " alpha:\(components[3].format(f: ".2"))"
            }
        }
        return hex
    }
    
    func rgbFromUIColor(color: UIColor?) -> String {
        guard var m_color = color else {
            return ""
        }
        
        if m_color == UIColor.clear{
            return ""
        }
        if m_color.cgColor.numberOfComponents < 4 {
            let components = m_color.cgColor.components
            if let m_components = components{
                m_color = UIColor(red: m_components[0], green: m_components[0], blue: m_components[0], alpha: m_components[1])
            }
        }
        
        if let colorspace = m_color.cgColor.colorSpace, colorspace.model != .rgb{
            return ""
        }
        
        var rgb = String()
        if let components = m_color.cgColor.components{
            let red = Int(components[0]*255.0)
            let green = Int(components[1]*255.0)
            let blue = Int(components[2]*255.0)
            let alpha = Int(components[3]*255.0)
            
            rgb = "      RGB:\(red)," + "\(green)," + "\(blue)"
            if alpha < 255{
                rgb = rgb + " ,\(components[3].format(f: ".2"))"
            }
        }
        return rgb
    }
    
    @objc func closeBtnClicked(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CloseNotification), object: nil, userInfo: nil)
    }
    
    func show() {
        viewInfoWindow.isHidden = false
        self.isHidden = false
    }
    
    func hide() {
        viewBound.removeFromSuperview()
        viewInfoWindow.isHidden = true
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}