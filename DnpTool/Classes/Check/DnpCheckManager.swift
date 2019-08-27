//
//  DnpCheckManager.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/27.
//

import UIKit

public class DnpCheckManager: NSObject {
    public static let shareInstance = DnpCheckManager()
    private var checkView: DnpCheckView?
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(closePlugin(notification:)), name: NSNotification.Name(rawValue: "\(DnpCheckView.self)"), object: nil)
    }
    
    var isShowing : Bool {
        return !(self.checkView?.isHidden ?? true)
    }
    
    public func show() {
        if self.checkView == nil {
            self.checkView = DnpCheckView()
            self.checkView?.isHidden = true
            let delegateWindow = UIApplication.shared.delegate?.window
            if let window = delegateWindow,let m_checkView = self.checkView {
                window?.addSubview(m_checkView)
            }
        }
        self.checkView?.show()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowNotification), object: self, userInfo: nil)
    }
    
    public func hidden() {
        self.checkView?.hide()
    }
    
    @objc func closePlugin(notification: Notification) {
        let close = UserDefaults.standard.bool(forKey: "DnpCheckController")
        UserDefaults.standard.set(!close, forKey: "DnpCheckController")
        self.hidden()
    }
}
