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
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var btnLookingFor: UIButton!
    
    
    
    @IBOutlet weak var viewCreateOpportunity: UIView!
    @IBOutlet weak var viewSelectCategoryTop: NSLayoutConstraint!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var btnSelectDocument: UIButton!
    
    @IBOutlet weak var viewselectcategorybottom: NSLayoutConstraint!
    @IBOutlet weak var UploadimageCollectionView: UICollectionView!
    @IBOutlet weak var UploaddocumentCollectionView: UICollectionView!
    var stateid:Int?
    var subcatid:Int?
    var lookingforid:Int?
    var imagearr = [UIImage]()
    var documentarr = [String]()
 
    var imagess = [UIImage(named: "IND")]
    var imagedd = [UIImage(named: "Crown")]
    
    var getCategorylist    = [getCartegoryModel]()
    var getSubCategorylist = [getSubCartegoryModel]()
    var getstatelist       = [getStateModel]()
    var getlocalitylist    = [getLocalityModel]()
    var getlookingForList  = [getLookingForModel]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getsubcategoryapi()
        self.getstateapi()
        self.getlookingforapi(id: self.lookingforid ?? 0)
    
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
                
                debugPrint("imageararty..........",self.imagearr.count)
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
        if imagearr.count == 0{
            showSimpleAlert(message: "First upload Select Image")
        }
        else{
            btnSelectDocument.isEnabled = true
        sender.isSelected = !sender.isSelected
        if self.btnSelectDocument.isSelected == true{
            if documentarr.count <= 5{
                ImagePickerHelper.shared.showPickerController { image, url in
                   
                    self.UploaddocumentCollectionView.reloadData()
                }
            }
            self.viewSelectCategoryTop.constant = 420
//            btnSelectDocument.isEnabled = false
          
        }
    }
}
    @IBAction func btnAddMoreDocumentTapped(_ sender: UIButton) {
        if documentarr.count <= 5{
            ImagePickerHelper.shared.showPickerController { image, url in
//                self.documentarr.append(image ?? UIImage())
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
    
    @IBAction func btnLookingForTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getlookingForList.map{String.getString($0.looking_for)}, text: btnLookingFor){
            (index,item) in
            self.lblLookingFor.text = item
            let id = self.getlookingForList[index].id
            self.lookingforid = id
            debugPrint("looking idddddd.....",self.lookingforid = id)
            self.getlookingforapi(id: self.lookingforid ?? 0)
            
        }
    }
    
    @IBAction func btnCreateOppTapped(_ sender: UIButton) {
//        self.createopportunityapi()
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
//                if self.imagearr.count == 0{
//                    self.viewSelectCategoryTop.constant = 10
//                }
            }
            return cell
        case self.UploaddocumentCollectionView:
            let cell = UploaddocumentCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadDocumentCollectionViewCell", for: indexPath) as! UploadDocumentCollectionViewCell
            cell.lbldocument.text = documentarr[indexPath.row]
            cell.callbackclose = {
                self.documentarr.remove(at: indexPath.row)
                self.UploaddocumentCollectionView.reloadData()
//                if self.documentarr.count == 0{
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
    
    func getlookingforapi(id:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        LookingForapi(language: "en"){ sucess , lookingfordata, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if sucess == 200 {
                if let lookingfordata = lookingfordata {
                    self.getlookingForList = lookingfordata
                }
            }
         }
    }
    
    
//    func createopportunityapi(){
//        CommonUtils.showHudWithNoInteraction(show: true)
//        createopportunity(language: "en",user_id:UserData.shared.id ?? 0,category_id:1,sub_category:self.subcatid ?? 0,title:self.txtFieldTitle.text ?? "",opp_state:self.lblState.text ?? "",opp_locality:self.lblLocality.text ?? "",location_name:self.txtFieldLocationName.text ?? "",location_map:self.txtFieldLocationOnMap.text ?? "",description:"Ritesh", mobile_num:Int.getInt(self.txtFieldMobileNumber.text),whatsaap_num:Int.getInt(self.txtFieldWhatsappNumber.text),pricing:22,looking_for:self.lookingforid ?? 0, plan:"Basic",filenames:self.imagess,opportunity_documents: self.imagedd,cat_type_id:0){ sucess, message in
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if sucess == 200{
//                kSharedAppDelegate?.makeRootViewController()
//            }
//            if sucess == 400{
//                CommonUtils.showError(.error, String.getString(message))
//            }
//        }
//    }
    
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
    
//  Looking For Api
    
    func LookingForapi(language:String, completionBlock: @escaping (_ success: Int, _ lookingfordata : [getLookingForModel]?, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
    
        
        let url = kBASEURL + ServiceName.kgetlookingfor
        //
        //        print("============\(params)")
        print(url)
        
        Alamofire.request(url,method: .get, parameters : params, headers: headers).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print(" Looking For json is:\n\(json)")
                    
                    let parser = getLookingforParser(json: json)
                    
                    
                    completionBlock(parser.status,parser.bmy,parser.message)
                }else{
                    completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
                
            case .failure(let error):
                completionBlock(0,nil,error.localizedDescription)
            }
            
        }
    }
    
    //    parser
    class getLookingforParser : NSObject{
        
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
        let kbmy = "bmy"
        
        
        
        var responsecode = 0
        var status = 0
        var message = ""
        var bmy =  [getLookingForModel]()
        
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
            
            if let passingData = json[kbmy].arrayObject as? Array<Dictionary<String, AnyObject>>{
                
                for item in passingData {
                    let Faq = getLookingForModel(dictionary: item)
                    self.bmy.append(Faq)
                }
            }
            super.init()
        }
    }
    
    
    
//   Post opportunity Api
    
    
    
    
    
    
    
//    func createopportunity(language:String,user_id:Int,category_id:Int,sub_category:Int,title:String,opp_state:String,opp_locality:String,location_name:String,location_map:String,description:String,mobile_num:Int,whatsaap_num:Int,pricing:Int,looking_for:Int,plan:String,filenames:[UIImage?],opportunity_documents:[UIImage?],cat_type_id:Int,completionBlock: @escaping (_ success: Int, _ message: String) -> Void) {
//
//
//        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
//        debugPrint("headers......\(headers)")
//
//        var params = Dictionary<String, String>()
////        params.updateValue("\(UserData.shared.id)", forKey: "user_id")
//////        params.updateValue(String(describing: UserData.shared.id), forKey: "user_id")
////        params.updateValue("\(Int(1))", forKey: "category_id")
////        params.updateValue("\(self.subcatid)", forKey: "sub_category")
////        params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "title")
////        params.updateValue(self.lblState.text ?? "", forKey: "opp_state")
////        params.updateValue(self.lblLocality.text ?? "", forKey: "opp_locality")
////        params.updateValue(String.getString(self.txtFieldLocationName.text), forKey: "location_name")
////        params.updateValue(String.getString(self.txtFieldLocationOnMap.text), forKey: "location_map")
////        params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "description")
////        params.updateValue(String.getString(self.txtFieldMobileNumber.text), forKey: "mobile_num")
////        params.updateValue(String.getString(self.txtFieldWhatsappNumber.text), forKey: "whatsaap_num")
////        params.updateValue("\(22)", forKey: "pricing")
////        params.updateValue("\(self.lookingforid)", forKey: "looking_for")
////        params.updateValue("Basic", forKey: "plan")
////        params.updateValue("\(0)", forKey: "cat_type_id")
//
//        params.updateValue("\(user_id)", forKey: "user_id")
////        params.updateValue(String(describing: UserData.shared.id), forKey: "user_id")
//        params.updateValue("\(category_id)", forKey: "category_id")
//        params.updateValue("\(sub_category)", forKey: "sub_category")
//        params.updateValue(title, forKey: "title")
//        params.updateValue(opp_state, forKey: "opp_state")
//        params.updateValue(opp_locality, forKey: "opp_locality")
//        params.updateValue(location_name, forKey: "location_name")
//        params.updateValue(location_map, forKey: "location_map")
//        params.updateValue(description, forKey: "description")
//        params.updateValue("\(mobile_num)", forKey: "mobile_num")
//        params.updateValue("\(whatsaap_num)", forKey: "whatsaap_num")
//        params.updateValue("\(pricing)", forKey: "pricing")
//        params.updateValue("\(looking_for)", forKey: "looking_for")
//        params.updateValue(plan, forKey: "plan")
//        params.updateValue("\(cat_type_id)", forKey: "cat_type_id")
//
//
//        debugPrint("userid........",  params.updateValue("\(user_id)", forKey: "user_id"))
//        debugPrint("category_id......", params.updateValue("\(category_id)", forKey: "category_id") )
//        debugPrint("sub_category.......",   params.updateValue("\(sub_category)", forKey: "sub_category"))
//        debugPrint("title........",        params.updateValue(title, forKey: "title"))
//        debugPrint("opp_state......",         params.updateValue(opp_state, forKey: "opp_state"))
//        debugPrint("opp_locality.....",     params.updateValue(self.lblLocality.text ?? "", forKey: "opp_locality"))
//        debugPrint("location_name.....",      params.updateValue(String.getString(self.txtFieldLocationName.text), forKey: "location_name"))
//        debugPrint("location_map.......",  params.updateValue(String.getString(self.txtFieldLocationOnMap.text), forKey: "location_map"))
//        debugPrint("description........",      params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "description"))
//        debugPrint("mobile_num....",    params.updateValue(String.getString(self.txtFieldMobileNumber.text), forKey: "mobile_num"))
//        debugPrint("whatsaap_num.....",          params.updateValue(String.getString(self.txtFieldWhatsappNumber.text), forKey: "whatsaap_num"))
//        debugPrint("pricing.....",    params.updateValue(String.getString(self.txtFieldPricing.text), forKey: "pricing"))
//        debugPrint("looking_for....." ,   params.updateValue("\(self.lookingforid)", forKey: "looking_for"))
//        debugPrint("plan.....",    params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "title"))
//        debugPrint("cat_typer_id.........",params.updateValue("\(0)", forKey: "cat_type_id"))
//
////        debugPrint("userid........", params.updateValue("\(UserData.shared.id)", forKey: "user_id"))
////        debugPrint("category_id......",params.updateValue("\(1)", forKey: "category_id") )
////        debugPrint("sub_category.......",  params.updateValue("\(self.subcatid)", forKey: "sub_category"))
////        debugPrint("title........",    params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "title"))
////        debugPrint("opp_state......",    params.updateValue(self.lblState.text ?? "", forKey: "opp_state"))
////        debugPrint("opp_locality.....",     params.updateValue(self.lblLocality.text ?? "", forKey: "opp_locality"))
////        debugPrint("location_name.....",      params.updateValue(String.getString(self.txtFieldLocationName.text), forKey: "location_name"))
////        debugPrint("location_map.......",  params.updateValue(String.getString(self.txtFieldLocationOnMap.text), forKey: "location_map"))
////        debugPrint("description........",      params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "description"))
////        debugPrint("mobile_num....",    params.updateValue(String.getString(self.txtFieldMobileNumber.text), forKey: "mobile_num"))
////        debugPrint("whatsaap_num.....",          params.updateValue(String.getString(self.txtFieldWhatsappNumber.text), forKey: "whatsaap_num"))
////        debugPrint("pricing.....",    params.updateValue(String.getString(self.txtFieldPricing.text), forKey: "pricing"))
////        debugPrint("looking_for....." ,   params.updateValue("\(self.lookingforid)", forKey: "looking_for"))
////        debugPrint("plan.....",    params.updateValue(String.getString(self.txtFieldTitle.text), forKey: "title"))
////        debugPrint("cat_typer_id.........",params.updateValue("\(0)", forKey: "cat_type_id"))
//
//
//
//        let url = kBASEURL + ServiceName.kcreateopportunity
//        //
//        //        print("============\(params)")
//        print(url)
//
//        Alamofire.upload(
//
//                 multipartFormData: { multipartFormData in
//
//
//                     for img in  filenames{
//
//                   ///  if let pimage = img {
//
//                         if let data = img?.jpegData(compressionQuality: 0.3), let imageName = img?.jpegData(compressionQuality: 0.3) as? String {
//
//                             multipartFormData.append(data, withName: "filenames[]", fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
//
//                             print("==========image=========\(data)")
//
//                         }
//
//                  //   }
//                     }
//
////                     let imageData:Data = filenames.fixedOrientation().jpegData(compressionQuality: 0.4) ?? Data()
////                     debugPrint("imageData=",imageData)
////
////                     var cri: Data
////
////                     cri = imageData
////                     if let jpegData = filenames.jpegData(compressionQuality: 0.4)
////                     {
////                         multipartFormData.append(jpegData, withName: "filenames[]", fileName: "\(jpegData).png", mimeType: "image/png")
////                     }
//
//                     for img in  opportunity_documents
//                     {
//
//                   ///  if let pimage = img {
//
//                if let data = img?.jpegData(compressionQuality: 0.3), let imageName = img?.jpegData(compressionQuality: 0.3) as? String {
//
//                             multipartFormData.append(data, withName: "opportunity_documents[]", fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
//
//                             print("==========image=========\(data)")
//
//                         }
//
//                  //   }
//
//                     }
//
//
//
////                     let documentdata:Data = opportunity_documents.fixedOrientation().jpegData(compressionQuality: 0.4) ?? Data()
////                     debugPrint("imageData=",documentdata)
////
////                     var doc: Data
////
////                     doc = documentdata
////                     if let jpegData = opportunity_documents.jpegData(compressionQuality: 0.4)
////                     {
////                         multipartFormData.append(jpegData, withName: "opportunity_documents[]", fileName: "\(jpegData).png", mimeType: "image/png")
////                     }
//
//
//                     for (key, value) in params {
//
//                         multipartFormData.append((value).data(using: .utf8)!, withName: key)
//
//                         debugPrint("key.........",key)
//
//                     }
//
//
//
//                 },to: url,method:.post, headers: headers ,encodingCompletion: { encodingResult in
//
//                     switch encodingResult {
//
//                     case .success(let upload, _, _):
//
//                         upload.responseJSON { response in
//
//
//
//                             switch response.result {
//
//                             case .success:
//
//                                 if let value = response.result.value {
//
//                                     let json = JSON(value)
//
//                                     print("\(json)")
//
//
//                                     guard let message = json["message"].string as String? else{
//
//                                         return
//
//                                     }
//                                     completionBlock(0,message)
//
//                                 }else{
//
//                                     completionBlock(0,response.result.error?.localizedDescription ?? "Some thing went wrong")
//
//                                 }
//
//                             case .failure(let error):
//
//                                 completionBlock(0,error.localizedDescription)
//
//                             }
//
//                         }
//
//                     case .failure(let encodingError):
//
//                         print(encodingError)
//
//                     }
//
//                 })
//
//
//
//         }
//
//    //    parser
//    class createOpportunityParser : NSObject{
//
//        let KResponsecode = "responsecode"
//        let kStatus = "status"
//        let kMessage = "message"
////        let kCategories = "Categories"
//
//
//
//        var responsecode = 0
//        var status = 0
//        var message = ""
//        var opportunity =  opportunityydataModel()
//
//        override init() {
//            super.init()
//        }
//        init(json: JSON) {
//            if let responsecode = json[KResponsecode].int as Int?{
//                self.responsecode = responsecode
//            }
//            if let status = json[kStatus].int as Int?{
//                self.status = status
//            }
//            if let message = json[kMessage].string as String?{
//                self.message = message
//            }
////            self.opportunity = opportunityydataModel(json: json)
//            super.init()
//
//        }
//    }
//
    
    
//    func createopportunityapi(image:UIImage?){
//        CommonUtils.showHud(show: true)
//
//        if String.getString(kSharedUserDefaults.getLoggedInAccessToken()) != "" {
//            let endToken = kSharedUserDefaults.getLoggedInAccessToken()
//            let septoken = endToken.components(separatedBy: " ")
//            if septoken[0] != "Bearer"{
//                let token = "Bearer " + kSharedUserDefaults.getLoggedInAccessToken()
//                kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: token)
//            }
//            //            headers["token"] = kSharedUserDefaults.getLoggedInAccessToken()
//        }
//        let params:[String : Any] = [
//            "user_id":UserData.shared.id
//        ]
//
//        let uploadimage:[String:Any] = ["profile_image":self.ImageProfile.image ?? UIImage()]
//        TANetworkManager.sharedInstance.requestMultiPart(withServiceName:ServiceName.keditprofileimage , requestMethod: .post, requestImages: [uploadimage], requestVideos: [:], requestData:params, req : self.ImageProfile.image! )
//        { (result:Any?, error:Error?, errortype:ErrorType?, statusCode:Int?) in
//            CommonUtils.showHudWithNoInteraction(show: false)
//            if errortype == .requestSuccess {
//                debugPrint("result=====",result)
//                let dictResult = kSharedInstance.getDictionary(result)
//                debugPrint("dictResult====",dictResult)
//                switch Int.getInt(statusCode) {
//                case 200:
//                    if Int.getInt(dictResult["status"]) == 200{
//                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
//                        let septoken = endToken.components(separatedBy: " ")
//                        if septoken[0] == "Bearer"{
//                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
//                        }
//                        let data =  kSharedInstance.getDictionary(dictResult["data"])
//                        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
//                        UserData.shared.saveData(data:data, token: String.getString(kSharedUserDefaults.getLoggedInAccessToken()))
//
//                        let obj = kSharedInstance.getDictionary(data["social_profile"])
//                        self.userImage = String.getString(obj.first)
//                    }
//                    else if  Int.getInt(dictResult["status"]) == 401{
//                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
//                    }
//
//                default:
//                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
//                }
//            } else if errortype == .noNetwork {
//                CommonUtils.showToastForInternetUnavailable()
//            } else {
//                CommonUtils.showToastForDefaultError()
//            }
//        }
//    }
}
