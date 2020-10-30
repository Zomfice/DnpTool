//
//  DnpFpsManager.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/28.
//

import Foundation

public class DnpFpsManager: NSObject {
    public static let shareInstance = DnpFpsManager()
    private var fpsView: DnpFpsView?
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(closePlugin(notification:)), name: NSNotification.Name(rawValue: "\(DnpFpsView.self)"), object: nil)
    }
    
    var isShowing : Bool {
        return !(self.fpsView?.isHidden ?? true)
    }
    
    public func show() {
        if self.fpsView == nil {
            self.fpsView = DnpFpsView()
            self.fpsView?.hide()
            /*let delegateWindow = UIApplication.shared.delegate?.window
            if let window = delegateWindow,let m_rulerView = self.fpsView {
                window?.addSubview(m_rulerView)
            }*/
            if let m_rulerView = self.fpsView {
                DnpToolCommon.getKeyWindow()?.addSubview(m_rulerView)
            }
        }
        self.fpsView?.show()
    }
    
    public func hidden() {
        self.fpsView?.hide()
    }
    
    @objc func closePlugin(notification: Notification) {
        let close = UserDefaults.standard.bool(forKey: "DnpFPSController")
        UserDefaults.standard.set(!close, forKey: "DnpFPSController")
        self.hidden()
    }
}
