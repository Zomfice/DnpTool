//
//  DnpLogListController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpLogModel {
    var url : String = ""
    var success : Bool = true
    var response : String = ""
    var time : TimeInterval = 0
}

class DnpLogListController: DnpToolBaseController {

    lazy var tableView: UITableView = {
        let m_tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenwidth, height: screenheight ), style: .plain)
        m_tableView.delegate = self
        m_tableView.dataSource = self
        m_tableView.backgroundColor = UIColor.white
        m_tableView.estimatedRowHeight = 70
        m_tableView.tableFooterView = UIView()
        m_tableView.separatorStyle = .none
        m_tableView.register(DnpLogCell.self, forCellReuseIdentifier: DnpLogCell.reuseIdentifier)
        return m_tableView
    }()
    
    static var dataArray = [DnpLogModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(rightAction))
        self.layout()
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
        logmodel.success = !content.contains("Error Domain")
        logmodel.time = Date.timeInterval()
        if DnpLogListController.dataArray.count > 99 {
            DnpLogListController.dataArray.removeFirst()
        }
        DnpLogListController.dataArray.insert(logmodel, at: 0)
    }
    
    /// 处理Log字符串：获取URL
    static func dealLog(content: String) -> String  {
        let pattern0 = "URL:\\s(.*?)\\s"
        let contentRange0 = NSRange(location: 0, length: content.count)
        let express0 = try? NSRegularExpression.init(pattern: pattern0, options: .caseInsensitive)
        let expressResults0 = express0?.matches(in: content, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: contentRange0)
        if let result = expressResults0{
            for check in result {
                let range = NSRange(location: check.range.location + 5, length: check.range.length > 5 ? check.range.length - 6 : check.range.length)
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
        let prefix = logmodel.success ? "✅  " : "❌  "
        logcell.title.text = prefix + logmodel.url
        logcell.date.text = Date.currentDate(time: logmodel.time)
        return logcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let logmodel = DnpLogListController.dataArray[indexPath.row]
        let logdetail = DnpLogDetailController()
        logdetail.title = logmodel.url
        logdetail.content = logmodel.response
        self.navigationController?.pushViewController(logdetail, animated: true)
    }
    
    @objc func rightAction() {
        DnpLogListController.dataArray.removeAll()
        self.tableView.reloadData()
    }
    
    func layout() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
