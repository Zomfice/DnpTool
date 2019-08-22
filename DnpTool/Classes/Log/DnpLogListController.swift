//
//  DnpLogListController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpLogListController: DnpToolBaseController {

    lazy var tableView: UITableView = {
        let m_tableView = UITableView(frame: CGRect(x: 0, y: navigationHeight, width: screenwidth, height: screenheight - navigationHeight), style: .plain)
        m_tableView.delegate = self
        m_tableView.dataSource = self
        m_tableView.backgroundColor = UIColor.white
        m_tableView.estimatedRowHeight = 70
        m_tableView.tableFooterView = UIView()
        m_tableView.register(DnpLogCell.self, forCellReuseIdentifier: DnpLogCell.reuseIdentifier)
        return m_tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.addnotification()
    }
    
    
    @objc func notification(sender: Notification) {
        if let userinfo = sender.userInfo,let log = userinfo["log"]{
            print("----\(log)")
        }
    }
    
    func addnotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notification(sender:)), name: NSNotification.Name(rawValue: DnpLogNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DnpLogListController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logcell = tableView.dequeueReusableCell(withIdentifier: DnpLogCell.reuseIdentifier, for: indexPath) as! DnpLogCell
        logcell.textLabel?.text = "let logcell = tableView.dequeueReusableCell(withIdentifier: DnpLogCell.reuseIdentifier, for: indexPath) as! DnpLogCell"
        return logcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
