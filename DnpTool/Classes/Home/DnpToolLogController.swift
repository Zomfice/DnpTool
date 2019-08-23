//
//  DnpToolLogController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/22.
//

import UIKit

class DnpToolLogController: DnpToolSwitchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTitle = "开启Log监听"
        if UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpToolLogController.self)")
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

}
