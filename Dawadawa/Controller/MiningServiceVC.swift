//
//  MiningServiceVC.swift
//  Dawadawa
//
//  Created by Alekh on 12/07/22.
//

import UIKit
import SKFloatingTextField
import Alamofire
import SwiftyJSON

class MiningServiceVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIDocumentPickerDelegate {

    //   MARK: - Properties
    @IBOutlet weak var txtFieldTitle: SKFloatingTextField!
    @IBOutlet weak var txtFieldLocationName: SKFloatingTextField!
    @IBOutlet weak var txtFieldLocationOnMap: SKFloatingTextField!
    @IBOutlet weak var txtFieldMobileNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldWhatsappNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldPricing: SKFloatingTextField!
    @IBOutlet weak var txtFieldBusinessName: SKFloatingTextField!
    @IBOutlet weak var txtFieldBusinessMiningBlock: SKFloatingTextField!
    @IBOutlet weak var TextViewDescription:UITextView!
    
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var lblLocality: UILabel!
    @IBOutlet weak var btnLocality: UIButton!
    @IBOutlet weak var lblBusinesstype: UILabel!
    @IBOutlet weak var btnBusinessType: UIButton!
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var btnLookingFor: UIButton!
    
    @IBOutlet weak var btnSelectDocument: UIButton!
    
    @IBOutlet weak var viewBasic: UIView!
    @IBOutlet weak var lblBasic: UILabel!
    @IBOutlet weak var btnBasic: UIButton!
    
    @IBOutlet weak var viewFeature: UIView!
    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var btnFeature: UIButton!
    
    @IBOutlet weak var viewPremium: UIView!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var btnPremium: UIButton!
    
    
    @IBOutlet weak var viewCreateOpportunity: UIView!
    @IBOutlet weak var viewSelectCategoryTop: NSLayoutConstraint!
    @IBOutlet weak var btnSelectImage: UIButton!
   
    @IBOutlet weak var UploadimageCollectionView: UICollectionView!
    @IBOutlet weak var UploaddocumentCollectionView: UICollectionView!
    
    
    var stateid:Int?
    var subcatid:Int?
    var lookingforid:Int?
    var doc = ""
    var imagearr = [UIImage]()
    var documentarr = [URL]()
    var docummentarray = [String]()
    
   
    var getSubCategorylist = [getSubCartegoryModel]()
    var getstatelist       = [getStateModel]()
    var getlocalitylist    = [getLocalityModel]()
    var getlookingForList  = [getLookingForModel]()
    var getbusinesstypelist = [getbusinessminingTypeModel]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getsubcategoryapi()
        self.getstateapi()
        self.getbusinessminingtypeapi()
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
        self.setTextFieldUI(textField: txtFieldBusinessName, place: "Business name", floatingText: "Business name")
        self.setTextFieldUI(textField: txtFieldBusinessMiningBlock, place: "Business mining BLOCK", floatingText: "Business mining BLOCK")
        
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
//            if txt == "Cancel"{
//                vc.dismiss(animated: false){
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: MiningServiceVC.getStoryboardID()) as! MiningServiceVC
//                    self.navigationController?.pushViewController(vc, animated: false)
//                }
//
//            }
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
            if imagearr.count == 0{
                btnSelectImage.isEnabled = true
                ImagePickerHelper.shared.showPickerController {
                    image, url in
                    self.imagearr.append(image ?? UIImage())
                    self.UploadimageCollectionView.reloadData()
                }
                
                debugPrint("imagearraycount..........",self.imagearr.count)
            }
            else{
                btnSelectImage.isEnabled = false
            }
            self.viewSelectCategoryTop.constant = 420  // 310
        }
        
    }
    
    @IBAction func btnAddmoreImageTapped(_ sender: UIButton) {
        if self.btnSelectDocument.isSelected == true{
            if imagearr.count != 0{
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
            showSimpleAlert(message: "First upload Image")
        }
        else{
       
            sender.isSelected = !sender.isSelected
            if self.btnSelectDocument.isSelected == true{
                if documentarr.count == 0{
                    btnSelectDocument.isEnabled = true
                    self.openFileBrowser()
                    self.viewSelectCategoryTop.constant = 420
                    
                }
                else{
                    btnSelectDocument.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func btnAddMoreDocumentTapped(_ sender: UIButton) {
        if self.btnSelectDocument.isSelected == true{
        if documentarr.count != 0{
            self.openFileBrowser()
        }
    }
}
    
    
    @IBAction func btnSelectSubCategoryTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getSubCategorylist.map{String.getString($0.sub_cat_name)}, text: btnSubCategory) { (index, item) in
            self.lblSubCategory.text = item
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
            let id = self.getstatelist[index].id
            self.stateid = id
            self.lblLocality.text = item
           
        }
    }
    
    @IBAction func btnBusinessTypeTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getbusinesstypelist.map{String.getString($0.business_mining_type)}, text: btnBusinessType) { (index, item) in
            self.lblBusinesstype.text = item
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
    
    @IBAction func btnBasicTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnBasic.isSelected == true{
            self.viewBasic.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblBasic.textColor = .white
            self.viewFeature.backgroundColor = .white
            self.lblFeature.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewPremium.backgroundColor = .white
            self.lblPremium.textColor =  UIColor(red: 21, green: 114, blue: 161)
           
        }
    }
    
    @IBAction func btnFeatureTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnFeature.isSelected == true{
            self.viewFeature.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblFeature.textColor = .white
            self.viewBasic.backgroundColor = .white
            self.lblBasic.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewPremium.backgroundColor = .white
            self.lblPremium.textColor =  UIColor(red: 21, green: 114, blue: 161)
           
        }
    }
    
    @IBAction func btnPremiumTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnPremium.isSelected == true{
            self.viewPremium.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblPremium.textColor = .white
            self.viewBasic.backgroundColor = .white
            self.lblBasic.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewFeature.backgroundColor = .white
            self.lblFeature.textColor =  UIColor(red: 21, green: 114, blue: 161)
           
        }
    }
    
    @IBAction func btnCreateOppTapped(_ sender: UIButton) {
        self.createopportunityapi(image: self.imagearr, doc: self.documentarr)
    }
   
    
    
    // Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.UploadimageCollectionView:
            return self.imagearr.count
            
        case self.UploaddocumentCollectionView:
            return self.docummentarray.count
            
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
            }
            return cell
            
        case self.UploaddocumentCollectionView:
            let cell = UploaddocumentCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadDocumentCollectionViewCell", for: indexPath) as! UploadDocumentCollectionViewCell
            cell.lbldocument.text = docummentarray[indexPath.row]
            cell.callbackclose = {
                self.docummentarray.remove(at: indexPath.row)
                self.UploaddocumentCollectionView.reloadData()
                
            }
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    //  MARK: - Document Picker
    
    
    func openFileBrowser() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose File", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let fileAttachmentAction = UIAlertAction(title: "File Attachment", style: UIAlertAction.Style.default)
        {
            UIAlertAction in self.openFileBrowser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {_ in
            
            alert.dismiss(animated: false, completion: nil)
        }
        
        alert.addAction(fileAttachmentAction)
        alert.addAction(cancelAction)
        
        if let popoverPresentationController = alert.popoverPresentationController {
            //            popoverPresentationController.sourceView = Utils.getController().view
            //            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection()
            //            popoverPresentationController.sourceRect = CGRect(x: Utils.getController().view.bounds.midX, y: Utils.getController().view.bounds.midY, width: 0, height: 0)
            
            
            // self.present(alert, animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        
        let documentTypes =  ["public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.composite-content", "public.text"]
        
        //[String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)
        let documentsPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        //Call Delegate
        documentsPicker.delegate = self
        self.present(documentsPicker, animated: true)
        
    }
    
    
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        debugPrint("url = ",url)
        debugPrint("url = ",url.path)
        debugPrint("url = ",url.absoluteString)
        debugPrint("url = ",url.absoluteURL)
        
        
        //          self.urlAttachemnt = url
        //          if self.sizePerMB(url: url) > 500
        //          {
        //
        //
        //              NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: "File size must be lesser or equal to 500MB.")
        //              return
        //
        //          }
        
        
        // self.doc = (url)
        print("doc path=-=-=\(doc)")
        self.documentarr.append(url)
        self.docummentarray.append(url.lastPathComponent)
        print("doc documentarr=-=-=\(documentarr)")
        self.UploaddocumentCollectionView.reloadData()
        
        
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func savePdf(url:URL, fileName:String) {
        
    }
    
    func updateImageViewWithExtension(_ fileExtention:String) {

        
    }
    
}

extension MiningServiceVC{
    
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
extension MiningServiceVC : SKFlaotingTextFieldDelegate {
    
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
extension MiningServiceVC{
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
    
    func getbusinessminingtypeapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        BusinessminingTypeapi(language: "en"){ sucess, businessminingdata, message in
            CommonUtils.showHudWithNoInteraction(show: false)
            if sucess == 200 {
                if let businessminingdata = businessminingdata {
                    self.getbusinesstypelist = businessminingdata
                }
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
  
    
    
}
extension MiningServiceVC{
    //    Sub-Category API
    func subcategoryapi(language:String, completionBlock: @escaping (_ success: Int, _ catdata : [getSubCartegoryModel]?, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
        params.updateValue("4", forKey: "category_id")
        
        
        
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
        //        params.updateValue("1", forKey: "category_id")
        
        
        
        //
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
    
    // Business_Mining_Type_Api
    
    //  Looking For Api
    
    func BusinessminingTypeapi(language:String, completionBlock: @escaping (_ success: Int, _ businessminingdata : [getbusinessminingTypeModel]?, _ message: String) -> Void) {
        
        
        let headers : HTTPHeaders = ["Authorization": "Bearer " + kSharedUserDefaults.getLoggedInAccessToken(), "Accept-Language": language]
        debugPrint("headers......\(headers)")
        
        var params = Dictionary<String, String>()
        
        
        let url = kBASEURL + ServiceName.kgetbusinessminingtype
        //
        //        print("============\(params)")
        print(url)
        
        Alamofire.request(url,method: .get, parameters : params, headers: headers).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print(" Looking For json is:\n\(json)")
                    
                    let parser = getbusinessminingParser(json: json)
                    
                    
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
    class getbusinessminingParser : NSObject{
        
        let KResponsecode = "responsecode"
        let kStatus = "status"
        let kMessage = "message"
        let kbmy = "bmy"
        
        
        
        var responsecode = 0
        var status = 0
        var message = ""
        var bmy =  [getbusinessminingTypeModel]()
        
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
                    let Faq = getbusinessminingTypeModel(dictionary: item)
                    self.bmy.append(Faq)
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
    
    
    
    //    Create Opportunity Api
    
    func createopportunityapi(image:[UIImage?],doc:[URL?]){
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
        
        
        let userid = Int(UserData.shared.id ?? 0)  // For Remove Optional
        debugPrint("checkuserid",userid)
        
        let subcatid = Int(self.subcatid ?? 0)
        debugPrint("checksubcatid",subcatid)
        
        
        let params:[String : Any] = [
            "user_id":"\(String(describing: userid))",
            "category_id":"4",
            "sub_category":"\(String(describing: subcatid))",
            "title":String.getString(self.txtFieldTitle.text),
            "business_name":String.getString(self.txtFieldBusinessName.text),
            "business_mining_type":self.lblBusinesstype.text,
            "business_mining_block":String.getString(self.txtFieldBusinessMiningBlock.text),
            "opp_state":self.lblState.text,
            "opp_locality":self.lblLocality.text,
            "location_name":String.getString(self.txtFieldLocationName.text),
            "location_map":String.getString(self.txtFieldLocationOnMap.text),
            "description":String.getString(self.TextViewDescription.text),
            "mobile_num":String.getString(self.txtFieldMobileNumber.text),
            "whatsaap_num":String.getString(self.txtFieldWhatsappNumber.text),
            "pricing":String.getString(self.txtFieldPricing.text),
            "looking_for":self.lblLookingFor.text,
            "plan":"Basic",
            "cat_type_id":"2"
        ]
        
        
        
        
        let uploadimage:[String:Any] = ["filenames[]":self.imagearr ?? UIImage()]
        let uploaddocument:[String:Any] = ["opportunity_documents[]":self.documentarr]
        
        debugPrint("filenames[]......",self.imagearr)
        debugPrint("opportunity_documents[]......",self.documentarr)
        
        
        TANetworkManager.sharedInstance.requestMultiPartwithlanguage(withServiceName:ServiceName.kcreateopportunity , requestMethod: .post, requestImages: [uploadimage], requestdoc: [uploaddocument],requestVideos: [:], requestData:params, req: self.imagearr, req:self.documentarr)
        { (result:Any?, error:Error?, errortype:ErrorType?, statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errortype == .requestSuccess {
                debugPrint("result=====",result)
                let dictResult = kSharedInstance.getDictionary(result)
                debugPrint("dictResult====",dictResult)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let endToken = kSharedUserDefaults.getLoggedInAccessToken()
                        let septoken = endToken.components(separatedBy: " ")
                        if septoken[0] == "Bearer"{
                            kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: septoken[1])
                        }
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        kSharedAppDelegate?.makeRootViewController()
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errortype == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
            } else {
                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
}
