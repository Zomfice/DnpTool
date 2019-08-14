//
//  DnpToolHomeWindow.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/30.
//

import UIKit

class DnpToolHomeWindow: UIWindow {
    
    var nav : UINavigationController?
    
    public static let shareInstance = DnpToolHomeWindow(frame: CGRect(x: 0, y: 0, width: screenwidth, height: screenheight))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = UIWindow.Level.statusBar + 50.0
        self.backgroundColor = UIColor.clear
        self.isHidden = true
    }
    
    func openPlugin(vc: UIViewController) {
        self.setRootVc(rootVc: vc)
        self.isHidden = false
    }
    
    func show() {
        let vc = DnpToolHomeController()
        self.setRootVc(rootVc: vc)
        self.isHidden = false
    }
    
    func hide() {
        self.setRootVc(rootVc: nil)
        self.isHidden = true
    }
    
    func setRootVc(rootVc: UIViewController?) {
        if let rootvc = rootVc{
            let m_nav = UINavigationController(rootViewController: rootvc)
            let attributesDic = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            m_nav.navigationBar.titleTextAttributes = attributesDic
            nav = m_nav
            self.rootViewController = nav
        }else{
            self.rootViewController = nil
            nav = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
