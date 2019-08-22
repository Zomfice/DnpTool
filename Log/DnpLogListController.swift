//
//  DnpLogListController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/22.
//

import UIKit

class DnpLogListController: DnpToolBaseController {

    lazy var tableView: UITableView = {
        let m_tableView = UITableView(frame: CGRect(x: 0, y: navigationHeight, width: screenwidth, height: screenheight - navigationHeight), style: .plain)
        m_tableView.delegate = self
        m_tableView.dataSource = self
        m_tableView.backgroundColor = UIColor.white
        m_tableView.separatorStyle = .none
        m_tableView.estimatedRowHeight = 70
        m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        return m_tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }

}


extension DnpLogListController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Hello"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
