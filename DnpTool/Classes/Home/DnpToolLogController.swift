//
//  DnpToolLogController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/22.
//

import UIKit

class DnpToolLogController: DnpToolSwitchController {
    
    lazy var secondSwitchView: DnpToolSwitchView = {
        let m_switchView = DnpToolSwitchView()
        m_switchView.title = "开启Log快速启动"
        m_switchView.switchView.addTarget(self, action: #selector(secondSwitchAction(sender:)), for: .touchUpInside)
        return m_switchView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.layouts()
        self.descTitle = "开启Log监听"
        if UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)")
        }
        /// 快速开启Log
        if UserDefaults.standard.bool(forKey: DnpOpenLogModule) {
            self.secondSwitchView.isOn = UserDefaults.standard.bool(forKey: DnpOpenLogModule)
        }
    }
    
    override func switchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "\(DnpToolLogController.self)")
        if sender.isOn {
            DnpLogListController.addnotification()
        }else{
            DnpLogListController.closenotification()
        }
    }
    
    @objc private func secondSwitchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: DnpOpenLogModule)
    }
    
    private func layouts()  {
        self.view.addSubview(self.secondSwitchView)
        self.secondSwitchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.secondSwitchView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.secondSwitchView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.secondSwitchView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 110).isActive = true
        NSLayoutConstraint(item: self.secondSwitchView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100).isActive = true
    }

}
