//
//  DnpCheckController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpCheckController: DnpToolSwitchController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTitle = "开启检测元素"
        if UserDefaults.standard.bool(forKey: "\(DnpCheckController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpCheckController.self)")
        }
    }

    override func switchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "\(DnpCheckController.self)")
        if sender.isOn{
           DnpCheckManager.shareInstance.show()
        }else{
            DnpCheckManager.shareInstance.hidden()
        }
        DnpToolHomeWindow.shareInstance.hide()
    }
    
}
