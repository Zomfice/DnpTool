//
//  DnpLogListController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpLogModel {
    var url : String = ""
    var response : String = ""
}

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
    
    static var dataArray = [DnpLogModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(sender:)), name: NSNotification.Name(rawValue: "DnpLogListReload"), object: nil)
    }
    
    @objc func reload(sender: Notification){
        self.tableView.reloadData()
    }
    
    @objc static func notification(sender: Notification) {
        if let userinfo = sender.userInfo,let log = userinfo[DnpLog] as? String{
            //print("--log--\(log)")
            self.dealData(content: log)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DnpLogListReload"), object: nil)
        }
    }
    
    /// 处理Log成DnpLogModel
    static func dealData(content: String) {
        let logmodel = DnpLogModel()
        logmodel.url = self.dealLog(content: content)
        logmodel.response = content
        DnpLogListController.dataArray.append(logmodel)
    }
    
    /// 处理Log字符串：获取URL
    static func dealLog(content: String) -> String  {
        let pattern0 = "URL:\\s(.*?)\\s"
        let contentRange0 = NSRange(location: 0, length: content.count)
        let express0 = try? NSRegularExpression.init(pattern: pattern0, options: .caseInsensitive)
        let expressResults0 = express0?.matches(in: content, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: contentRange0)
        if let result = expressResults0{
            for check in result {
                let range = NSRange(location: check.range.location + 5, length: check.range.length > 5 ? check.range.length - 5 : check.range.length)
                let subStr = (content as NSString).substring(with: range)
                return subStr
            }
        }
        return ""
    }
    
    /// 添加通知
    internal static func addnotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notification(sender:)), name: NSNotification.Name(rawValue: DnpLogNotification), object: nil)
    }
    /// 移除通知
    internal static func closenotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: DnpLogNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DnpLogListController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DnpLogListController.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logcell = tableView.dequeueReusableCell(withIdentifier: DnpLogCell.reuseIdentifier, for: indexPath) as! DnpLogCell
        let logmodel = DnpLogListController.dataArray[indexPath.row]
        logcell.textLabel?.text = logmodel.url
        return logcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let logmodel = DnpLogListController.dataArray[indexPath.row]
        let logdetail = DnpLogDetailController()
        logdetail.content = logmodel.response
        self.navigationController?.pushViewController(logdetail, animated: true)
    }
}
