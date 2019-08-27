//
//  DnpToolRulerManager.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/27.
//

import UIKit


public class DnpRulerManager: NSObject {
    public static let shareInstance = DnpRulerManager()
    private var rulerView: DnpRulerView?
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(closePlugin(notification:)), name: NSNotification.Name(rawValue: "\(DnpRulerView.self)"), object: nil)
    }
    
    var isShowing : Bool {
        return !(self.rulerView?.isHidden ?? true)
    }
    
    public func show() {
        if self.rulerView == nil {
            self.rulerView = DnpRulerView()
            self.rulerView?.hide()
            let delegateWindow = UIApplication.shared.delegate?.window
            if let window = delegateWindow,let m_rulerView = self.rulerView {
                window?.addSubview(m_rulerView)
            }
        }
        self.rulerView?.show()
    }
    
    public func hidden() {
        self.rulerView?.hide()
    }
    
    @objc func closePlugin(notification: Notification) {
        let close = UserDefaults.standard.bool(forKey: "DnpRulerController")
        UserDefaults.standard.set(!close, forKey: "DnpRulerController")
        self.hidden()
    }
}
