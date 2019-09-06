//
//  DnpToolHomeController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/30.
//

import UIKit

/*
 * 规则:
 * 1. DnpTool内部
 * jump: 对应控制器类名
 * type: 用于面板列表点击跳转跳转不同类型,默认为0跳转到内部类名对应控制器,1,关闭面板,jump和type可以空,默认不跳转
 * 2. DnpTool外部
 * jump: 传入UIViewController.Type类型的类
 * type: 自定义跳转类型，type需要保持与配置的Module对应，才可以跳转成功
 * type: 0,默认内部页面跳转 1, 关闭面板 ....用于自定义跳转
 * 3. 显示DataSouce: [["title": "关闭面板","icon":"dnptool_img","jump":"","type": "1"]]
 * 4. 跳转DataSouce: [["type": "2","class": SecondController.self]]
 */

class DnpToolHomeController: DnpToolBaseController {
    
    private lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        var collectView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: screenwidth, height: screenheight), collectionViewLayout: flowLayout)
        collectView.backgroundColor = UIColor.white
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.alwaysBounceVertical = true
        collectView.delegate = self
        collectView.dataSource = self
        collectView.register(DnpHomeCollectCell.self, forCellWithReuseIdentifier: DnpHomeCollectCell.reuseIdentifier)
        collectView.register(DnpHomeHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DnpHomeHeadView.reuseIdentifier)
        return collectView
    }()
    
    fileprivate var titleData = [String]()
    fileprivate var homeData = [[DnpHomeModel]]()
    fileprivate var dataArray = [
        
        [
            "head":"工具",
            "data":[
                ["title": "Log","icon":"dnptool_img","jump":"DnpLogListController"],
                ["title": "元素","icon":"dnptool_img","jump":"DnpMetricsController"],
                ["title": "控件","icon":"dnptool_img","jump":"DnpCheckController"],
                ["title": "标尺","icon":"dnptool_img","jump":"DnpRulerController"],
                ["title": "FPS","icon":"dnptool_img","jump":"DnpFPSController"]
            ]
        ],
        /*[
            "head":"组件",
            "data":[
                ["title": "内存泄露","icon":"dnptool_img","jump":""],
                ["title": "开发中","icon":"dnptool_img","jump":""],
                ["title": "开发中","icon":"dnptool_img","jump":""]
            ]
        ],*/
        [
            "head":"其他",
            "data":[
                ["title": "开启Log","icon":"dnptool_img","jump":"DnpToolLogController"],
                ["title": "关闭面板","icon":"dnptool_img","jump":"","type": "1"]
            ]
        ]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(self.collectionView)
        self.initData()
    }
    
    /// Jump Action Target
    ///
    /// - Parameter indexPath: didselect Item
    func jumpto(indexPath: IndexPath) {
        let homeModel = self.homeData[indexPath.section][indexPath.item]
        if homeModel.type == 1{
            self.close()
            return
        }else if homeModel.type != 0{
            self.customModule(homeType: homeModel.type)
            return
        }
        
        if homeModel.jump.count > 0,let clsName = Bundle(for: DnpToolCommon.self).infoDictionary!["CFBundleExecutable"] as? String{
            let className = clsName + "." + homeModel.jump
            if let m_className = NSClassFromString(className) as? UIViewController.Type {
                let vc = m_className.init()
                vc.title = homeModel.title
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    /// 初始化数据
    func initData() {
        for dataDic in self.dataArray {
            self.titleData.append("\(dataDic["head"] ?? "")")
            var tempArr = [DnpHomeModel]()
            if let m_data = dataDic["data"],let data = m_data as? [[String:String]]{
                for item in data{
                    tempArr.append(initHomeModel(item: item))
                }
            }
            if tempArr.count > 0{
                self.homeData.append(tempArr)
            }
        }
        
        if let m_configModule = DnpTool.shareInstance.configModule{
            var tempArr = [DnpHomeModel]()
            for item in m_configModule(){
                tempArr.append(initHomeModel(item: item))
            }
            self.homeData[1].append(contentsOf: tempArr)
        }
    }
    /// 解析数据Model
    fileprivate func initHomeModel(item: [String:String]) -> DnpHomeModel {
        let homeModel = DnpHomeModel()
        homeModel.title = "\(item["title"] ?? "")"
        homeModel.icon = "\(item["icon"] ?? "dnptool_img")"
        homeModel.jump = "\(item["jump"] ?? "")"
        homeModel.type = Int(item["type"] ?? "0") ?? 0
        return homeModel
    }
    /// 自定义模块跳转
    fileprivate func customModule(homeType: Int) {
        if let m_jumpModule = DnpTool.shareInstance.jumpModule{
            let jumpArray = m_jumpModule()
            for dic in jumpArray{
                var type = 0
                if let m_type = dic["type"] as? String{
                    type = Int(m_type) ?? 0
                }
                if type != 0,homeType == type{
                    if let m_class = dic["class"],let classType = m_class as? UIViewController.Type{
                        let vc = classType.init()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    /// 关闭面板
    fileprivate func close() {
        let alertController = UIAlertController(title: "提示", message: "关闭当前工具面板", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            DnpTool.shareInstance.hidden()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        if let window = UIApplication.shared.delegate?.window,let vc = window?.rootViewController {
            vc.present(alertController, animated: true, completion: nil)
        }
        DnpToolHomeWindow.shareInstance.hide()
    }
}


extension DnpToolHomeController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.homeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: DnpHomeCollectCell.reuseIdentifier, for: indexPath) as! DnpHomeCollectCell
        homeCell.setModel(model: self.homeData[indexPath.section][indexPath.row])
        return homeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DnpHomeHeadView.reuseIdentifier, for: indexPath) as! DnpHomeHeadView
        headView.setHead(title: self.titleData[indexPath.section])
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenwidth / 4.0, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenwidth, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.jumpto(indexPath: indexPath)
    }
    
}


// MARK: - DnpHomeCollectCell
internal class DnpHomeCollectCell: UICollectionViewCell {
    
    lazy var icon: UIImageView = {
        let m_icon = UIImageView(frame: CGRect(x: 0, y: 10, width: 60, height: 60))
        m_icon.image = UIImage.imageName(name: "dnptool_img")
        return m_icon
    }()
    
    lazy var title: UILabel = {
        let m_title = UILabel(frame: CGRect(x: 0, y: 80, width: 80, height: 20))
        m_title.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        m_title.font = UIFont.systemFont(ofSize: 15)
        m_title.textAlignment = .center
        return m_title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.title)
        self.icon.center.x = self.contentView.center.x
        self.title.center.x = self.contentView.center.x
        
    }
    
    func setModel(model: DnpHomeModel){
        self.title.text = model.title
        self.icon.image = UIImage.imageName(name: model.icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DnpHomeHeadView
class DnpHomeHeadView: UICollectionReusableView {
    
    lazy var title: UILabel = {
        let m_title = UILabel(frame: CGRect(x: 15, y: 25, width: 100, height: 20))
        m_title.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        m_title.font = UIFont.boldSystemFont(ofSize: 24)
        m_title.textAlignment = .left
        return m_title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.title)
    }
    
    func setHead(title: String) {
        self.title.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: DnpHomeModel
class DnpHomeModel {
    var title : String = ""//title
    var icon : String = ""//icon
    var jump : String = ""//jump controller
    var type : Int = 0//use for special page
}
