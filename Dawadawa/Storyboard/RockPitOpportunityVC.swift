//
//  RockPitOpportunityVC.swift
//  Dawadawa
//
//  Created by Alekh on 07/07/22.
//

import UIKit
import SKFloatingTextField
import Alamofire
import SwiftyJSON

class RockPitOpportunityVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //   MARK: - Properties
    @IBOutlet weak var txtFieldTitle: SKFloatingTextField!
    @IBOutlet weak var txtFieldLocationName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLocationOnMap: SKFloatingTextField!
    @IBOutlet weak var txtFieldMobileNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldWhatsappNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldPricing: SKFloatingTextField!
    
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var lblLocality: UILabel!
    @IBOutlet weak var btnLocality: UIButton!
    
    
    @IBOutlet weak var viewCreateOpportunity: UIView!
    @IBOutlet weak var viewSelectCategoryTop: NSLayoutConstraint!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var btnSelectDocument: UIButton!
    
    @IBOutlet weak var viewselectcategorybottom: NSLayoutConstraint!
    @IBOutlet weak var UploadimageCollectionView: UICollectionView!
    @IBOutlet weak var UploaddocumentCollectionView: UICollectionView!
    var stateid:Int?
    var subcatid:Int?
    var imagearr = [UIImage]()
    var documentarr = [UIImage]()
    
    var getCategorylist    = [getCartegoryModel]()
    var getSubCategorylist = [getSubCartegoryModel]()
    var getstatelist       = [getStateModel]()
    var getlocalitylist    = [getLocalityModel]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getsubcategoryapi()
        self.getstateapi()

        self.setup()
        
    }
    
    func setup(){
        self.viewCreateOpportunity.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.setTextFieldUI(textField: txtFieldTitle, place: "Title", floatingText: "Title")
        self.setTextFieldUI(textField: txtFieldLocationName, place: "Location name", floatingText: "Location name")
        self.setTextFieldUI(textField: txtFieldLocationOnMap, place: "Location on map ( optional )", floatingText: "Location on map ( optional )")
        self.setTextFieldUI(textField: txtFieldMobileNumber, place: "Mobile number", floatingText: "Mobile number")
        self.setTextFieldUI(textField: txtFieldWhatsappNumber, place: "WhatsApp number", floatingText: "WhatsApp number")
        self.setTextFieldUI(textField: txtFieldPricing, place: "Pricing ( optional )", floatingText: "Pricing ( optional )")
       
    }
    
    // MARK: - @IBActions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: QuitVCViewController.getStoryboardID()) as! QuitVCViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.callbackquit =  { txt in
            if txt == "Cancel"{
                vc.dismiss(animated: false){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: RockPitOpportunityVC.getStoryboardID()) as! RockPitOpportunityVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            }
            if txt == "Quit"{
                vc.dismiss(animated: false){
                    kSharedAppDelegate?.makeRootViewController()
                }
            }
        }
        self.present(vc, animated: false)
    }
    @IBAction func btnSelectImageTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSelectImage.isSelected == true{
            if imagearr.count <= 5{
                ImagePickerHelper.shared.showPickerController {
                    image, url in
                    self.imagearr.append(image ?? UIImage())
                    self.UploadimageCollectionView.reloadData()
                }
            }
            self.viewSelectCategoryTop.constant = 310
            if imagearr.count == 0{
                btnSelectImage.isEnabled = true
            }
            else{
            btnSelectImage.isEnabled = false
            }
        }
        
    }
    
    @IBAction func btnAddmoreImageTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnSelectDocument.isSelected == true{
            if imagearr.count <= 5{
                ImagePickerHelper.shared.showPickerController {
                    image, url in
                    self.imagearr.append(image ?? UIImage())
                    self.UploadimageCollectionView.reloadData()
                }
            }
    }
    }
    
    @IBAction func btnSelectDocumentTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnSelectDocument.isSelected == true{
            if documentarr.count <= 5{
                ImagePickerHelper.shared.showPickerController { image, url in
                    self.documentarr.append(image ?? UIImage())
                    self.UploaddocumentCollectionView.reloadData()
                }
            }
            self.viewSelectCategoryTop.constant = 420
            btnSelectDocument.isEnabled = false
          
        }
    }
    @IBAction func btnAddMoreDocumentTapped(_ sender: UIButton) {
        if documentarr.count <= 5{
            ImagePickerHelper.shared.showPickerController { image, url in
                self.documentarr.append(image ?? UIImage())
                self.UploaddocumentCollectionView.reloadData()
            }
        }
    }
    
    
    @IBAction func btnSelectSubCategoryTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getSubCategorylist.map{String.getString($0.sub_cat_name)}, text: btnSubCategory) { (index, item) in
            self.lblSubCategory.text = item
            let subcatid = self.getSubCategorylist[index].id
            self.subcatid = subcatid
            debugPrint("subcatid........",subcatid)
        }
    }
    
    @IBAction func btnSelectStateTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getstatelist.map{String.getString($0.state_name)}, text: btnState){
            (index,item) in
            self.lblState.text = item
            let id = self.getstatelist[index].id
            self.stateid = id
            debugPrint("State idddd.....btnnnnt",  self.stateid = id)
            self.getlocalityapi(id: self.stateid ?? 0 )
           
        }
        
    }
    @IBAction func btnLocalityTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getlocalitylist.map{String.getString($0.local_name)}, text: btnLocality){
            (index,item) in
            self.lblLocality.text = item
           
        }
    }
    
    @IBAction func btnCreateOppTapped(_ sender: UIButton) {
        self.createopportunityapi()
    }
    
    // Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.UploadimageCollectionView:
            return self.imagearr.count
            
        case self.UploaddocumentCollectionView:
            return self.documentarr.count
            
        default: return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case self.UploadimageCollectionView:
            let cell = UploadimageCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCollectionViewCell", for: indexPath) as! UploadImageCollectionViewCell
            cell.image.image = imagearr[indexPath.row]
            cell.callback = {
                self.imagearr.remove(at: indexPath.row)
                self.UploadimageCollectionView.reloadData()
//                if self.imagearr == []{
//                    self.viewSelectCategoryTop.constant = 10
//                }
            }
            return cell
        case self.UploaddocumentCollectionView:
            let cell = UploaddocumentCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadDocumentCollectionViewCell", for: indexPath) as! UploadDocumentCollectionViewCell
            cell.imagedocument.image = documentarr[indexPath.row]
            cell.callbackclose = {
                self.documentarr.remove(at: indexPath.row)
                self.UploaddocumentCollectionView.reloadData()
//                if self.imagearr == []{
//                    self.viewSelectCategoryTop.constant = 310
//                }
            }
            return cell
            
        default: return UICollectionViewCell()
            
        }
        return UICollectionViewCell()
    }
    
}

extension RockPitOpportunityVC{
    
    func setTextFieldUI(textField:SKFloatingTextField,place:String ,floatingText:String){
        
        textField.placeholder = place
        textField.activeBorderColor = .init(red: 21, green: 114, blue: 161)
        textField.floatingLabelText = floatingText
        textField.floatingLabelColor = .init(red: 21, green: 114, blue: 161)
        //floatingTextField.setRectTFUI()
        //floatingTextField.setRoundTFUI()
        //floatingTextField.setOnlyBottomBorderTFUI()
        //        textField.setCircularTFUI()
        textField.setRoundTFUI()
        textField.delegate = self
        //floatingTextField.errorLabelText = "Error"
        
    }
}
extension RockPitOpportunityVC : SKFlaotingTextFieldDelegate {
    
    func textFieldDidEndEditing(textField: SKFloatingTextField) {
        print("end editing")
    }
    
    func textFieldDidChangeSelection(textField: SKFloatingTextField) {
        print("changing text")
    }
    
    func textFieldDidBeginEditing(textField: SKFloatingTextField) {
        print("begin editing")
    }
}

//MARK: - API Call
extension RockPitOpportunityVC{
    //
    func getsubcategoryapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        subcategoryapi(language: "en") { success, catdata, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if success == 200{
                if let catdata = catdata {
                    self.getSubCategorylist = catdata
                }
            }
            else {
                CommonUtils.showError(.error, String.getString(message))
            }
        }
    }
    
    func getstateapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        stateapi(language: "en") { sucess, statedata, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if sucess == 200 {
                if let statedata = statedata {
                    self.getstatelist = statedata
                }
            }
            else {
                CommonUtils.showError(.error, String.getString(message))
            }
        }
        
    }
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
    func createopportunityapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        createopportunity(language: "en",user_id:UserData.shared.id ?? 0,category_id:1,sub_category:self.subcatid ?? 0,title:"",opp_state:"",opp_locality:"",location_name:"",location_map:"",description:"", mobile_num:Int.getInt(self.txtFieldMobileNumber.text),whatsaap_num:Int.getInt(self.txtFieldWhatsappNumber.text),pricing:"",looking_for:"", plan:"",cat_type_id:0,filenames: self.imagearr,opportunity_documents:self.imagearr){ sucess, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if sucess == 200{
                kSharedAppDelegate?.makeRootViewController()
            }
            else{
                CommonUtils.showError(.error, String.getString(message))
            }
        }
    }
    
}
extension RockPitOpportunityVC{
    //    Sub-Category API
    func subcategoryapi(language:String, completionBlock: @escaping (_ success: Int, _ catdata : [getSubCartegoryModel]?, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
        params.updateValue("1", forKey: "category_id")
        
        
        
        //
        let url = kBASEURL + ServiceName.ksubcategory
        //
        //        print("============\(params)")
        print(url)
        
        Alamofire.request(url,method: .post, parameters : params, headers: headers).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print("Sub-Category Details json is:\n\(json)")
                    
                    let parser = getSubCategoryParser(json: json)
                    
                    
                    completionBlock(parser.status,parser.Subcategories,parser.message)
                }else{
                    completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
                
            case .failure(let error):
                completionBlock(0,nil,error.localizedDescription)
            }
            
        }
    }
    //    parser
    class getSubCategoryParser : NSObject{
        
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
        let kCategories = "Categories"
        
        
        
        var responsecode = 0
        var status = 0
        var message = ""
        var Subcategories =  [getSubCartegoryModel]()
        
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
            
            if let passingData = json[kCategories].arrayObject as? Array<Dictionary<String, AnyObject>>{
                
                for item in passingData {
                    let Faq = getSubCartegoryModel(dictionary: item)
                    self.Subcategories.append(Faq)
                }
            }
            super.init()
        }
    }
    
    // State API
    func stateapi(language:String, completionBlock: @escaping (_ success: Int, _ statedata : [getStateModel]?, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
    
        
        let url = kBASEURL + ServiceName.kgetstate
        //
        //        print("============\(params)")
        print(url)
        
        Alamofire.request(url,method: .get, parameters : params, headers: headers).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print(" State Details json is:\n\(json)")
                    
                    let parser = getstateParser(json: json)
                    
                    
                    completionBlock(parser.status,parser.State,parser.message)
                }else{
                    completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
                
            case .failure(let error):
                completionBlock(0,nil,error.localizedDescription)
            }
            
        }
    }
    
    //    parser
    class getstateParser : NSObject{
        
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
        let kState = "state"
        
        
        
        var responsecode = 0
        var status = 0
        var message = ""
        var State =  [getStateModel]()
        
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
            
            if let passingData = json[kState].arrayObject as? Array<Dictionary<String, AnyObject>>{
                
                for item in passingData {
                    let Faq = getStateModel(dictionary: item)
                    self.State.append(Faq)
                }
            }
            super.init()
        }
    }
    
    //     Locality Api
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
    
//   Post opportunity Api
    
    
    func createopportunity(language:String,user_id:Int,category_id:Int,sub_category:Int,title:String,opp_state:String,opp_locality:String,location_name:String,location_map:String,description:String,mobile_num:Int,whatsaap_num:Int,pricing:String,looking_for:String,plan:String,cat_type_id:Int,filenames:[UIImage],opportunity_documents:[UIImage],completionBlock: @escaping (_ success: Int, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
        params.updateValue("\(UserData.shared.id)", forKey: "user_id")
        params.updateValue("\(1)", forKey: "category_id")
        params.updateValue("\(self.subcatid)", forKey: "sub_category")
        params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "title")
        params.updateValue(self.lblState.text ?? "", forKey: "opp_state")
        params.updateValue(self.lblLocality.text ?? "", forKey: "opp_locality")
        params.updateValue(String.getString(self.txtFieldLocationName.text), forKey: "location_name")
        params.updateValue(String.getString(self.txtFieldLocationOnMap.text), forKey: "location_map")
        params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "description")
        params.updateValue(String.getString(self.txtFieldMobileNumber.text), forKey: "mobile_num")
        params.updateValue(String.getString(self.txtFieldWhatsappNumber.text), forKey: "whatsaap_num")
        params.updateValue(String.getString(self.txtFieldPricing.text), forKey: "pricing")
        params.updateValue("Investor", forKey: "looking_for")
        params.updateValue("Basic", forKey: "plan")
        params.updateValue("gggg", forKey: "filenames")
        params.updateValue("gggg", forKey: "opportunity_documents")
        params.updateValue("\(0)", forKey: "cat_type_id")
        
        

        let url = kBASEURL + ServiceName.kcreateopportunity
        //
        //        print("============\(params)")
        print(url)
        
        Alamofire.request(url,method: .post, parameters : params, headers: headers).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print("Create Opportunity Details json is:\n\(json)")
                    
                    let parser = createOpportunityParser(json: json)
                    
                    
                    completionBlock(parser.status,parser.message)
                }else{
                    completionBlock(0,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
                
            case .failure(let error):
                completionBlock(0,error.localizedDescription)
            }
            
        }
    }
    //    parser
    class createOpportunityParser : NSObject{
        
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
//        let kCategories = "Categories"
        
        
        
        var responsecode = 0
        var status = 0
        var message = ""
        var opportunity =  opportunityydataModel()
        
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
//            self.opportunity = opportunityydataModel(json: json)
            super.init()

        }
    }
    
    
}
