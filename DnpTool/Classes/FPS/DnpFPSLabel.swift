//
//  DnpFPSLabel.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/28.
//

import UIKit

class DnpFPSLabel: UILabel {
    var link : CADisplayLink?
    var count: Int = 0
    var lastTime : TimeInterval = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.textAlignment = .center
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
    }
    
    func start() {
        if let m_link = self.link {
            m_link.isPaused = false
        }else{
            link = CADisplayLink(target: self, selector: #selector(linkAction(link:)))
            self.link?.add(to: RunLoop.main, forMode: .common)
        }
    }
    
    func end() {
        if let m_link = self.link{
            m_link.isPaused = true
            m_link.invalidate()
            self.link = nil
            lastTime = 0.0
            count = 0
        }
    }
    
    @objc func linkAction(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count = count + 1
        let delta = link.timestamp - lastTime
        if delta < 1{
            return
        }
        lastTime = link.timestamp
        let fps: CGFloat = CGFloat(Double(count) / delta)
        count = 0
        let progress = fps / 60.0
        let color = UIColor(hue: 0.27 * (progress - 0.2), saturation: 1, brightness: 0.9, alpha: 1)
        
        let fpsstr = "\(Int(round(fps)))"
        let fpsdesc = " FPS"
        let commonString = fpsstr + fpsdesc
        let attribute = NSMutableAttributedString(string: commonString)
        let fpstrRange = NSString(string: commonString).range(of: fpsstr)
        let fpsdescRange = NSString(string: commonString).range(of: fpsdesc)
        attribute.addAttributes([NSAttributedString.Key.foregroundColor : color,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], range: fpstrRange)
        attribute.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], range: fpsdescRange)
        self.attributedText = attribute
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
