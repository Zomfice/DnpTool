//
//  DnpMetricsController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpMetricsController: DnpToolSwitchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTitle = "开启元素线"
        UserDefaults.standard.set(MetricsConfig.shared.enable, forKey: "\(DnpMetricsController.self)")
        if UserDefaults.standard.bool(forKey: "\(DnpMetricsController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpMetricsController.self)")
        }
    }
    
    override func switchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "\(DnpMetricsController.self)")
        MetricsConfig.shared.setEnable(sender.isOn)
        MetricsConfig.shared.borderColor = UIColor.magenta
        DnpToolHomeWindow.shareInstance.hide()
    }
    
}
