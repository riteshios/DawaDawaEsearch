//
//  FilterVC.swift
//  Dawadawa
//
//  Created by Alekh on 28/07/22.
//

import UIKit
import RangeSeekSlider
import Alamofire
import SwiftyJSON

class FilterVC: UIViewController {
    
    @IBOutlet weak var PriceSlider: RangeSeekSlider!
    
    @IBOutlet weak var tblViewOpportunitytype: UITableView!
    @IBOutlet weak var highttblviewOpportunitytype: NSLayoutConstraint!
    
    @IBOutlet weak var tblViewServicetype: UITableView!
    
    
    @IBOutlet weak var txtfieldStartDate: UITextField!
    @IBOutlet weak var txtfieldEndDate: UITextField!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblLocality: UILabel!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnLocality: UIButton!
    
    
    @IBOutlet weak var viewMostLiked: UIView!
    @IBOutlet weak var lblMostLiked: UILabel!
    @IBOutlet weak var btnMostLiked: UIButton!
    
    @IBOutlet weak var viewLeastLiked: UIView!
    @IBOutlet weak var lblLeastLiked: UILabel!
    @IBOutlet weak var btnLeastLiked: UIButton!
    
    @IBOutlet weak var viewMostRated: UIView!
    @IBOutlet weak var lblMostrated: UILabel!
    @IBOutlet weak var btnmostrated: UIButton!
    
    @IBOutlet weak var viewLeastrated: UIView!
    @IBOutlet weak var lblLeastrated: UILabel!
    @IBOutlet weak var btnleastrated: UIButton!
    
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    
    @IBOutlet weak var viewAvailable: UIView!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var btnAvailable: UIButton!
    
    @IBOutlet weak var viewClosed: UIView!
    @IBOutlet weak var lblClosed: UILabel!
    @IBOutlet weak var btnClosed: UIButton!
    
    @IBOutlet weak var viewSold: UIView!
    @IBOutlet weak var lblSold: UILabel!
    @IBOutlet weak var btnSold: UIButton!
    
    
    var getCategoryarr         =      [getCartegoryModel]()
    var getfiltersubcatarr     =      [getfiltersubcategoryModel]()
    var getServiceTypearr      =      [getServicetypeModel]()
    var getstatelistarr        =      [getstateModel]()
    var getlocalitylist        =      [getLocalityModel]()
    var userTimeLine           =      [SocialPostData]()
    
    
    var selectedIds:[String] = []
    var stringcatid = ""
    var imgUrl = ""
    
    
    
    var timePicker = UIDatePicker()
    var stateid:Int?
    var localityid:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slidersetup()
        self.setup()
        self.getCartListApi()
        self.getservicetypeapi()
        self.setupstartdate()
        self.setupendtdate()
        self.getstateapi()
    }
    
    private func setup(){
        tblViewOpportunitytype.register(UINib(nibName: "OpportunityTypeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OpportunityTypeTableViewCell")
        tblViewOpportunitytype.register(UINib(nibName: "SubCategorylabelTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubCategorylabelTableViewCell")
        tblViewOpportunitytype.register(UINib(nibName: "SubcategoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubcategoryTableViewCell")
    }
    
    private func slidersetup() {
        
        PriceSlider.delegate = self
        PriceSlider.minValue = 0.0
        PriceSlider.maxValue = 100.0
        PriceSlider.selectedMinValue = 40.0
        PriceSlider.selectedMaxValue = 60.0
        PriceSlider.handleImage = #imageLiteral(resourceName: "darkcircle")
        PriceSlider.selectedHandleDiameterMultiplier = 1.0
        PriceSlider.colorBetweenHandles = .systemBlue
        PriceSlider.lineHeight = 10.0
        PriceSlider.numberFormatter.positivePrefix = "$"
        PriceSlider.numberFormatter.positiveSuffix = "M"
    }
    
    //    MARK: - @IBActions
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnMostLikedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnMostLiked.isSelected == true{
            self.viewMostLiked.backgroundColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lblMostLiked.textColor = .white
            self.viewLeastLiked.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLeastLiked.textColor = UIColor(red: 21, green: 114, blue: 161)
            
        }
        
    }
    
    @IBAction func btnLeasttikedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnLeastLiked.isSelected == true{
            self.viewLeastLiked.backgroundColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lblLeastLiked.textColor = .white
            self.viewMostLiked.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblMostLiked.textColor = UIColor(red: 21, green: 114, blue: 161)
        }
    }
    
    @IBAction func btnmostratedTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if self.btnmostrated.isSelected == true{
            self.viewMostRated.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblMostrated.textColor = .white
            self.viewLeastrated.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLeastrated.textColor = UIColor(red: 21, green: 114, blue: 161)

        }
    }
    
    @IBAction func btnleastratedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnleastrated.isSelected == true{
            self.viewLeastrated.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblLeastrated.textColor = .white
            self.viewMostRated.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblMostrated.textColor = UIColor(red: 21, green: 114, blue: 161)
        }
    }
    
    @IBAction func btnAllTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnAll.isSelected == true{
            self.viewAll.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblAll.textColor = .white
            self.viewAvailable.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAvailable.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewClosed.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblClosed.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewSold.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblSold.textColor = UIColor(red: 21, green: 114, blue: 161)
        }
    }
    
    @IBAction func btnAvailableTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnAll.isSelected == true{
            self.viewAvailable.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblAvailable.textColor = .white
            self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewClosed.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblClosed.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewSold.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblSold.textColor = UIColor(red: 21, green: 114, blue: 161)
        }

    }
    
    @IBAction func btnClosedTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnAll.isSelected == true{
            self.viewClosed.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblClosed.textColor = .white
            self.viewAvailable.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAvailable.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewSold.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblSold.textColor = UIColor(red: 21, green: 114, blue: 161)
        }

    }
    
    @IBAction func btnSoldTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnAll.isSelected == true{
            self.viewSold.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblSold.textColor = .white
            self.viewAvailable.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAvailable.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewClosed.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblClosed.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
        }

    }
    
    
    @IBAction func btnSelectStateTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getstatelistarr.map{String.getString($0.state_name)}, text: btnState){
            (index,item) in
            self.lblState.text = item
            let id = self.getstatelistarr[index].id
            self.stateid = id
            debugPrint("State idddd.....btnnnnt",  self.stateid = id)
            self.getlocalityapi(id: self.stateid ?? 0 )
        }
        
    }
    
    @IBAction func btnLocalityTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getlocalitylist.map{String.getString($0.local_name)}, text: btnLocality){
            (index,item) in
            self.lblLocality.text = item
            let id  = self.getlocalitylist[index].id
            self.localityid = id
            debugPrint("localityid....",self.localityid)
            
        }
        
        
    }
    @IBAction func btnApplyfilterTapped(_ sender: UIButton) {
        self.filterdataapi()
    }
    
    
    
    //   MARK: - APICALL
    func getlocalityapi(id:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        localityapi(language: "en"){ sucess, localdata, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if sucess == 200 {
                if let localdata = localdata {
                    self.getlocalitylist = localdata
                }
            }
            else{
                CommonUtils.showError(.error, String.getString(message))
            }
        }
    }
    
}

// MARK: - Table View Delegate
extension FilterVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView{
        case tblViewOpportunitytype:
            return 3
        case tblViewServicetype:
            return 1
            
        default: return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView{
        case tblViewOpportunitytype:
            self.highttblviewOpportunitytype.constant = CGFloat(60 * (self.getCategoryarr.count + self.getfiltersubcatarr.count + 1))
            switch section{
            case 0:
                return self.getCategoryarr.count
                
            case 1:
                return 1
                
            case 2:
                return self.getfiltersubcatarr.count
                
                
            default:
                return 0
            }
        case tblViewServicetype:
            return self.getServiceTypearr.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case tblViewOpportunitytype:
            switch indexPath.section{
            case 0:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "OpportunityTypeTableViewCell") as! OpportunityTypeTableViewCell
                let obj = self.getCategoryarr[indexPath.row]
                cell.lblCategory.text = obj.category_name
                cell.btnSelectOpptype.addTarget(self, action: #selector(buttonTappedCat), for: .touchUpInside)
                cell.btnSelectOpptype.tag = indexPath.row
                cell.imgradio.image = obj.isselection == true ? UIImage(named: "darkcircle") : UIImage(named: "radiouncheck")
               
                
                
//                cell.callback = {
//                    let catid = Int.getInt(self.getCategoryarr[indexPath.row].id)
//                    debugPrint(" self.catid", catid)

//                    debugPrint(" self.selectedIds.count", self.selectedIds.count)
//                    debugPrint(" self.selectedIds", self.selectedIds)
//
//                    //                    self.filtersubcategoryapi(catid:)
//                }
//
                
                return cell
                
            case 1:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "SubCategorylabelTableViewCell") as! SubCategorylabelTableViewCell
                return cell
                
            case 2:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "SubcategoryTableViewCell") as! SubcategoryTableViewCell
                
                let obj = self.getfiltersubcatarr[indexPath.row]
                cell.lblSubcategory.text = obj.sub_cat_name
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case tblViewServicetype:
            let cell = self.tblViewServicetype.dequeueReusableCell(withIdentifier: "ServiceTypeTableViewCell", for: indexPath) as! ServiceTypeTableViewCell
            let obj = self.getServiceTypearr[indexPath.row]
            cell.lblServicetype.text = obj.services_type
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
        case tblViewOpportunitytype:
            switch indexPath.section{
                
            case 0:
                return 60
                
            case 1:
                return 60
                
            case 2:
                return 60
                
            default:
                return 0
            }
        case tblViewServicetype:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
        
        
    }
    
    
    @objc func buttonTappedCat(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let obj = self.getCategoryarr[sender.tag]
        if sender.isSelected {
            obj.isselection = true
            self.selectedIds.append(String.getString(obj.id))
            print(" selectedIds---\(self.selectedIds)")
            let ids = self.selectedIds.joined(separator: ",")
            print(" selected   -ids---\(ids)")
            self.filtersubcategoryapi(catid: ids)
            
        }else if sender.isSelected == false{
            for i in 0 ..< self.selectedIds.count{
                if String.getString(obj.id) == self.selectedIds[i]{
                    self.selectedIds.remove(at: i)
                    print(" RemoveselectedIds---\(self.selectedIds)")
                    obj.isselection = false
                    let ids = self.selectedIds.joined(separator: ",")
                    print(" selected   -ids---\(ids)")
                    self.filtersubcategoryapi(catid: ids)
                    break
                }
            }
            
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    //        switch tableView{
    //        case tblViewOpportunitytype:
    //            switch indexPath.section{
    //            case 0:
    //                let catid = Int.getInt(self.getCategoryarr[indexPath.row].id)
    //
    //                debugPrint("catid=-=-=-=-=-=",catid)
    //                self.filtersubcategoryapi(catid: catid)
    //            default: break
    //            }
    //        default: break
    //        }
    //
    //
    //
    //    }
    
    
}
// MARK: - RangeSeekSliderDelegate

extension FilterVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === PriceSlider {
            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

// MARK: - DatePicker

extension FilterVC{
    func setupstartdate(){
        if #available(iOS 13.4, *) {
            timePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            timePicker.preferredDatePickerStyle = .wheels
        }
        self.timePicker.datePickerMode = .date
        timePicker.minuteInterval = 30
        //
        //        var components = Calendar.current.dateComponents([.hour, .minute, .month, .year, .day], from: timePicker.date)
        //        components.hour = 1
        //        components.minute = 30
        //        timePicker.setDate(Calendar.current.date(from: components)!, animated: true)
        
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 0
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        timePicker.maximumDate = maxDate
        timePicker.minimumDate = minDate
        self.txtfieldStartDate.inputView = self.timePicker
        self.txtfieldStartDate.inputAccessoryView = self.getToolBar()
        //       self.txtFieldDOB.inputView = self.getToolBar()
    }
    
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        self.txtfieldStartDate.text = dateFormatter.string(from: self.timePicker.date)
        
        
        
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    
    func setupendtdate(){
        if #available(iOS 13.4, *) {
            timePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            timePicker.preferredDatePickerStyle = .wheels
        }
        self.timePicker.datePickerMode = .date
        timePicker.minuteInterval = 30
        //
        //        var components = Calendar.current.dateComponents([.hour, .minute, .month, .year, .day], from: timePicker.date)
        //        components.hour = 1
        //        components.minute = 30
        //        timePicker.setDate(Calendar.current.date(from: components)!, animated: true)
        
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 0
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        timePicker.maximumDate = maxDate
        timePicker.minimumDate = minDate
        self.txtfieldEndDate.inputView = self.timePicker
        self.txtfieldEndDate.inputAccessoryView = self.getToolBare()
        //       self.txtFieldDOB.inputView = self.getToolBar()
    }
    
    func getToolBare() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicke))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicke))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func doneClicke() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        self.txtfieldEndDate.text = dateFormatter.string(from: self.timePicker.date)
        
        
        
    }
    
    @objc func cancelClicke() {
        self.view.endEditing(true)
    }
    
}



// MARK: - Api call


extension FilterVC{
    
    //    APi category list
    
    func getCartListApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetcategory, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let Categories = kSharedInstance.getArray(withDictionary: dictResult["Categories"])
                        self.getCategoryarr = Categories.map{getCartegoryModel(data: $0)}
                        DispatchQueue.main.async {
                            self.tblViewOpportunitytype.reloadData()
                        }
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    
    //   Api Service Type
    
    func getservicetypeapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetSerivetype, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let bmy = kSharedInstance.getArray(withDictionary: dictResult["bmy"])
                        self.getServiceTypearr = bmy.map{getServicetypeModel(data: $0)}
                        DispatchQueue.main.async {
                            self.tblViewServicetype.reloadData()
                        }
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
    //    Api State Type
    
    func getstateapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName: ServiceName.kgetstate, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let state = kSharedInstance.getArray(withDictionary: dictResult["state"])
                        self.getstatelistarr = state.map{getstateModel(data: $0)}
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //    Api Locality
    
    func localityapi(language:String, completionBlock: @escaping (_ success: Int, _ localdata : [getLocalityModel]?, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
        params.updateValue("\(self.stateid ?? 0)", forKey: "localitys_id")
        debugPrint("stateiddddddd.....",   params.updateValue("\(self.stateid ?? 0)", forKey: "localitys_id"))
        
        
        
        let url = kBASEURL + ServiceName.kgetlocality
        //
        //        print("============\(params)")
        print(url)
        
        Alamofire.request(url,method: .post, parameters : params, headers: headers).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print(" locality Details json is:\n\(json)")
                    
                    let parser = getlocalityParser(json: json)
                    completionBlock(parser.status,parser.local,parser.message)
                    
                }else{
                    completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
                
            case .failure(let error):
                completionBlock(0,nil,error.localizedDescription)
            }
            
        }
        
    }
    
    //    parser
    class getlocalityParser : NSObject{
        
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
        let klocalitys = "localitys"
        
        
        
        var responsecode = 0
        var status = 0
        var message = ""
        var local =  [getLocalityModel]()
        
        override init() {
            super.init()
        }
        init(json: JSON) {
            if let responsecode = json[KResponsecode].int as Int?{
                self.responsecode = responsecode
            }
            if let status = json[kStatus].int as Int?{
                self.status = status
            }
            if let message = json[kMessage].string as String?{
                self.message = message
            }
            
            if let passingData = json[klocalitys].arrayObject as? Array<Dictionary<String, AnyObject>>{
                
                for item in passingData {
                    let Faq = getLocalityModel(dictionary: item)
                    self.local.append(Faq)
                }
            }
            super.init()
        }
    }
    
    //    Api filter-subcategory
    
    func filtersubcategoryapi(catid:String){
        CommonUtils.showHud(show: true)
        
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
        }
        
        
        let params:[String : Any] = [
            "category_id":catid
        ]
        
        //        debugPrint("SearchTextfield=-=-=-=-",String.getString(self.txtfieldSearch.text))
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kfiltersubcategory, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        let Categories = kSharedInstance.getArray(withDictionary: dictResult["Categories"])
                        self?.getfiltersubcatarr = Categories.map{getfiltersubcategoryModel(data: $0)}
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        DispatchQueue.main.async {
                            self?.tblViewOpportunitytype.reloadData()
                        }
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.getfiltersubcatarr.removeAll()
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        DispatchQueue.main.async {
                            self?.tblViewOpportunitytype.reloadData()
                        }
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
            
        }
    }
    
    // API Filter DATA
    
    
    func filterdataapi(){
        CommonUtils.showHud(show: true)
        
        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
            let septoken = endToken.components(separatedBy: " ")
            if septoken[0] != "Bearer"{
                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
            }
            //            headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
        }
        
        
        
        
        let stateids = Int(self.stateid ?? 0) // remove optional
        debugPrint("checkstateids",stateids)
        
        let localityid = Int(self.localityid ?? 0)
        debugPrint("checklocalityid",localityid)
        
        
        
        let params:[String : Any] = [
            "most_like":"DESC",
//            "rating":"1",
//            "opr_type":"1",
//            "opr_subtype":"1",
//            "date":"",
//            "lastweek":"",
//            "lastmonth":"",
//            "state":"\(String(describing: stateids))",
//            "locality":"\(String(describing: localityid))",
//            "services_type":"",
//            "sort_by":"",
//            "start_date":"",
//            "end_date":"",
            
        ]
        
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kfilter, requestMethod: .POST,
                                                               requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        
                        self?.imgUrl = String.getString(dictResult["oprbase_url"])
                        let Opportunity = kSharedInstance.getArray(withDictionary: dictResult["Opportunity"])
                        self?.userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(self?.userTimeLine)")
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: HomeVC.getStoryboardID()) as! HomeVC
                        vc.cameFrom = "FilterData"
                        vc.userTimeLine = self!.userTimeLine
                        self?.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                CommonUtils.showToastForDefaultError()
            }
            
        }
        
        
        
        
    }
}


