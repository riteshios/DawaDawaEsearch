//  RockPitOpportunityVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 07/07/22.
import UIKit
import SKFloatingTextField
import Alamofire
import SwiftyJSON
import MobileCoreServices

class RockPitOpportunityVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIDocumentPickerDelegate{
    
    //   MARK: - Properties
    @IBOutlet weak var txtFieldTitle: SKFloatingTextField!
    @IBOutlet weak var txtFieldLocationName: SKFloatingTextField!
    
    @IBOutlet weak var txtFieldMobileNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldWhatsappNumber: SKFloatingTextField!
    @IBOutlet weak var txtFieldPricing: SKFloatingTextField!
    @IBOutlet weak var TextViewDescription:UITextView!
    
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var lblLocality: UILabel!
    @IBOutlet weak var lblLocationOnMap: UILabel!
    
    @IBOutlet weak var btnLocality: UIButton!
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var btnLookingFor: UIButton!
    @IBOutlet weak var btnCreate_UpdateOpp: UIButton!
    
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
    @IBOutlet weak var btnMoreImage: UIButton!
    
    @IBOutlet weak var btnSelectDocument: UIButton!
    @IBOutlet weak var btnMoreDocument: UIButton!
    
    @IBOutlet weak var viewselectcategorybottom: NSLayoutConstraint!
    @IBOutlet weak var UploadimageCollectionView: UICollectionView!
    @IBOutlet weak var UploaddocumentCollectionView: UICollectionView!
    
    @IBOutlet weak var viewSelectImage: UIView!
    @IBOutlet weak var lblSelectImages: UILabel!
    @IBOutlet weak var viewSelectDocument: UIView!
    @IBOutlet weak var lblSelectdocuments: UILabel!
    @IBOutlet weak var btnCreateOpp: UIButton!
    
    var stateid:Int?
    var localityid:Int?
    var subcatid:Int?
    var lookingforid:Int?
    var doc = ""
    var imagearr = [UIImage]()
    var documentarr = [URL]()
    var docummentarray = [String]()
    
    var isSelectimage = false
    var isSelectDocument = false
    var isSelectSubcategory = false
    var isSelectState = false
    var isSelectLocality = false
    var isSelectLookingFor = false
    var isSelectopp_planBasic = false
    var isSelectopp_planPremium = false
    var isSelectopp_planFeatured = false
    
    var plan = ""
    var planpayment = 0
    var oppidget:Int?
    
    var getCategorylist    = [getCartegoryModel]()
    var getSubCategorylist = [getSubCartegoryModel]()
    var getstatelist       = [getStateModel]()
    var getlocalitylist    = [getLocalityModel]()
    var getlookingForList  = [getLookingForModel]()
    
    //update
    var userTimeLineoppdetails:SocialPostData?
    var imgarray = [oppr_image]()
    var docarray = [oppr_document]()
    var isedit = ""
    var imgUrl = ""
    var docUrl = ""
    var oppid:Int?
    
    //    Cuurent location
    var currentadd = ""
    var latitude = Double()
    var longitude = Double()
    
    //    Get Plan Amount
    var planamount:plan_amount?
    var amount = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        self.getsubcategoryapi()
        self.getstateapi()
        self.getlookingforapi(id: self.lookingforid ?? 0)
        
        self.setup()
        
        if isedit == "True"{
            if self.userTimeLineoppdetails?.oppimage.count == 0{
                self.viewSelectCategoryTop.constant = 10
                self.fetdata()
            }
            else{
                self.viewSelectCategoryTop.constant = 420
                self.fetdata()
            }
        }
        self.UploadimageCollectionView.reloadData()
    }
    
    func setup(){
        
        self.txtFieldMobileNumber.keyBoardType = .numberPad
        self.txtFieldWhatsappNumber.keyBoardType = .numberPad
        self.viewSelectImage.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.viewSelectDocument.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        self.viewCreateOpportunity.applyGradient(colours: [UIColor(red: 21, green: 114, blue: 161), UIColor(red: 39, green: 178, blue: 247)])
        
        if self.txtFieldTitle.text == "" {
            self.setTextField(textField: txtFieldTitle, place: "Title", floatingText: "Title")
        }else{
            self.setTextFieldUI(textField: txtFieldTitle, place: "Title", showFloating:true, floatingText: "Title")
        }
        if self.txtFieldLocationName.text == ""{
            self.setTextField(textField: txtFieldLocationName, place: "Location name", floatingText: "Location name")
        }else{
            self.setTextFieldUI(textField: txtFieldLocationName, place: "Location name", showFloating: true, floatingText: "Location name")
        }
        if self.txtFieldMobileNumber.text == ""{
            self.setTextField(textField: txtFieldMobileNumber, place: "Mobile number", floatingText: "Mobile number")
        }
        else{
            self.setTextFieldUI(textField: txtFieldMobileNumber, place:  "Mobile number", showFloating: true, floatingText: "Mobile number")
        }
        if self.txtFieldWhatsappNumber.text == ""{
            self.setTextField(textField: txtFieldWhatsappNumber, place: "WhatsApp number", floatingText: "WhatsApp number")
        }
        else{
            self.setTextFieldUI(textField: txtFieldWhatsappNumber, place: "WhatsApp number", showFloating: true, floatingText: "WhatsApp number")
        }
        if self.txtFieldPricing.text == ""{
            self.setTextField(textField: txtFieldPricing, place: "Price in US Dollar (optional)", floatingText: "Price in US Dollar (optional)")
        }
        else{
            self.setTextFieldUI(textField: txtFieldPricing, place: "Price in US Dollar (optional)", showFloating: true, floatingText: "Price in US Dollar (optional)")
        }
    }
    
    func fetdata(){
        
        self.UploadimageCollectionView.reloadData()
        self.UploaddocumentCollectionView.reloadData()
        self.btnCreate_UpdateOpp.setTitle("Update opportunity", for: .normal)
        self.lblSubCategory.text = self.userTimeLineoppdetails?.subcategory_name
        self.txtFieldTitle.text = self.userTimeLineoppdetails?.title
        // self.lblState.text = self.userTimeLineoppdetails?.opp_state
        // self.lblLocality.text = self.userTimeLineoppdetails?.opp_locality
        self.txtFieldLocationName.text = self.userTimeLineoppdetails?.location_name
        
        self.TextViewDescription.text = self.userTimeLineoppdetails?.description
        self.txtFieldMobileNumber.text = self.userTimeLineoppdetails?.mobile_num
        self.txtFieldWhatsappNumber.text = self.userTimeLineoppdetails?.whatsaap_num
        self.txtFieldPricing.text = self.userTimeLineoppdetails?.pricing
        
        if self.userTimeLineoppdetails?.looking_for == "0"{
            self.lblLookingFor.text = "Investor"
        }
        else if self.userTimeLineoppdetails?.looking_for == "1"{
            self.lblLookingFor.text = "Business Owner"
        }
        else if self.userTimeLineoppdetails?.looking_for == "2"{
            self.lblLookingFor.text = "Service Provider"
        }
        self.stateid = Int.getInt(self.userTimeLineoppdetails?.opp_state)
        self.getlocalityapi(id: Int.getInt(self.stateid))
        if String.getString(self.userTimeLineoppdetails?.opp_plan) == "Basic"{
            self.viewBasic.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblBasic.textColor = .white
            
        }
        else if String.getString(self.userTimeLineoppdetails?.opp_plan) == "Featured"{
            self.viewFeature.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblFeature.textColor = .white
        }
        else if String.getString(self.userTimeLineoppdetails?.opp_plan) == "Premium"{
            self.viewPremium.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblPremium.textColor = .white
        }
        self.setup()
    }
    // MARK: - @IBActions
    
    @IBAction func btnpinlocationtapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CurrentLocationVC.getStoryboardID()) as! CurrentLocationVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        vc.callback = { address , latitude, longitude in
            vc.dismiss(animated: true){
                self.lblLocationOnMap.text = address
                self.latitude = latitude
                self.longitude = longitude
                self.currentadd = address
            }
        }
        self.present(vc, animated: false)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: QuitVCViewController.getStoryboardID()) as! QuitVCViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.callbackquit =  { txt in
            //
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
            self.isSelectimage = true
            
        }
    }
    
    @IBAction func btnAddmoreImageTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnMoreImage.isSelected == true{
            if self.isedit == "True"{
                ImagePickerHelper.shared.showPickerController {
                    image, url in
                    self.imagearr.append(image ?? UIImage())
                    debugPrint("imagearraycount..........",self.imagearr.count)
                    
                    let obj = oppr_image(data: [:])
                    obj.imageurl = ""
                    obj.img = image
                    self.imgarray.append(obj)
                    debugPrint("imgarra=-=-=",self.imgarray.count)
                    
                    self.UploadimageCollectionView.reloadData()
                }
            }
            else{
                if imagearr.count != 0{
                    ImagePickerHelper.shared.showPickerController {
                        image, url in
                        self.imagearr.append(image ?? UIImage())
                        self.UploadimageCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func btnSelectDocumentTapped(_ sender: UIButton) {
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
        self.isSelectDocument = true
        
    }
    @IBAction func btnAddMoreDocumentTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnMoreDocument.isSelected == true{
            if self.isedit == "True"{
                self.openFileBrowser()
            }
            else{
                if documentarr.count != 0{
                    self.openFileBrowser()
                }
            }
        }
    }
    
    @IBAction func btnSelectSubCategoryTapped(_ sender: UIButton) {
        
        kSharedAppDelegate?.dropDown(dataSource: getSubCategorylist.map{String.getString($0.sub_cat_name)}, text: btnSubCategory) { (index, item) in
            self.lblSubCategory.text = item
            let subcatid = self.getSubCategorylist[index].id
            self.subcatid = subcatid
            debugPrint("subcatid........",subcatid)
            self.isSelectSubcategory = true
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
            self.isSelectState = true
        }
    }
    
    @IBAction func btnLocalityTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getlocalitylist.map{String.getString($0.local_name)}, text: btnLocality){
            (index,item) in
            self.lblLocality.text = item
            let id = self.getlocalitylist[index].id
            self.localityid = id
            debugPrint("localityid.....btnnnnt",  self.localityid = id)
            self.isSelectLocality = true
            
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
            self.isSelectLookingFor = true
        }
    }
    
    @IBAction func btnBasicTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnBasic.isSelected == true{
            self.plan = "Basic"
            self.planpayment = 0
            self.viewBasic.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblBasic.textColor = .white
            self.viewFeature.backgroundColor = .white
            self.lblFeature.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewPremium.backgroundColor = .white
            self.lblPremium.textColor =  UIColor(red: 21, green: 114, blue: 161)
            self.isSelectopp_planBasic = true
            
        }
    }
    
    @IBAction func btnFeatureTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnFeature.isSelected == true{
            self.plan = "Featured"
            self.planpayment = 1
            self.viewFeature.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblFeature.textColor = .white
            self.viewBasic.backgroundColor = .white
            self.lblBasic.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewPremium.backgroundColor = .white
            self.lblPremium.textColor =  UIColor(red: 21, green: 114, blue: 161)
            self.isSelectopp_planFeatured = true
            
        }
    }
    
    @IBAction func btnPremiumTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnPremium.isSelected == true{
            self.plan = "Premium"
            self.planpayment = 2
            self.viewPremium.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblPremium.textColor = .white
            self.viewBasic.backgroundColor = .white
            self.lblBasic.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewFeature.backgroundColor = .white
            self.lblFeature.textColor =  UIColor(red: 21, green: 114, blue: 161)
            
            self.isSelectopp_planPremium = true
        }
    }
    
    @IBAction func btnCreateOppTapped(_ sender: UIButton) {
        if self.isedit == "True"{
            self.updateopportunityapi()
        }
        else{
            self.Validation()
        }
    }
    
    //    MARK: - Validation
    
    func Validation(){
        //        if self.isSelectimage == false && self.imagearr.count == 0{
        //            self.showSimpleAlert(message: "Please Select the image")
        //            return
        //        }
        //        else if self.isSelectDocument == false && self.documentarr.count == 0 {
        //            self.showSimpleAlert(message: "Please Select the Document")
        //            return
        //        }
        if self.isSelectSubcategory == false{
            self.showSimpleAlert(message: "Please Select the Subcategory")
            return
        }
        else if String.getString(self.txtFieldTitle.text).isEmpty
        {
            self.showSimpleAlert(message: Notifications.ktitle)
            return
        }
        else if !String.getString(self.txtFieldTitle.text).isValidUserName()
        {
            self.showSimpleAlert(message: Notifications.KValidtitle)
            return
        }
        else if self.isSelectState == false{
            self.showSimpleAlert(message: "Please Select the State")
            return
        }
        else if self.isSelectLocality == false{
            self.showSimpleAlert(message: "Please Select the Locality")
            return
        }
        
        //        else if String.getString(self.txtFieldLocationName.text).isEmpty
        //        {
        //            showSimpleAlert(message: Notifications.kLocationName)
        //            return
        //        }
        else if String.getString(self.TextViewDescription.text).isEmpty{
            showSimpleAlert(message: Notifications.kDescription)
            return
        }
        else if String.getString(self.txtFieldMobileNumber.text).isEmpty
        {
            showSimpleAlert(message: Notifications.kEnterMobileNumber)
            return
        }
        else if !String.getString(self.txtFieldMobileNumber.text).isPhoneNumber()
        {
            self.showSimpleAlert(message: Notifications.kEnterValidMobileNumber)
            return
        }
        
        else if self.isSelectLookingFor == false{
            self.showSimpleAlert(message: "Please Select looking For")
            return
        }
        else if self.isSelectopp_planBasic == false && self.isSelectopp_planPremium == false && self.isSelectopp_planFeatured == false{
            self.showSimpleAlert(message: "Please Select Opportunity Plan")
            return
        }
        else if self.isSelectopp_planPremium == true && self.isSelectimage == false && self.imagearr.count == 0{
            self.showSimpleAlert(message: "Please add at least one opportunity photo")
            return
        }
        self.view.endEditing(true)
        self.createopportunityapi()
    }
    
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.UploadimageCollectionView:
            if self.isedit == "True"{
                return self.imgarray.count
            }
            else{
                return self.imagearr.count
            }
            
        case self.UploaddocumentCollectionView:
            if self.isedit == "True"{
                return self.docarray.count
            }
            else {
                return self.docummentarray.count
            }
        default: return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case self.UploadimageCollectionView:
            let cell = UploadimageCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCollectionViewCell", for: indexPath) as! UploadImageCollectionViewCell
            
            if self.isedit == "True"{
                let imgurl = self.imgarray[indexPath.item].imageurl
                print("-=-imgurl-=-\(imgurl)")
                
                if imgurl == ""
                {
                    cell.image.image = self.imgarray[indexPath.item].img
                }
                else{
                    let imageurl = "\(self.imgUrl)/\(String.getString(imgurl))"
                    print("-=imageurl=-=-\(imageurl)")
                    cell.image.downlodeImage(serviceurl: imageurl, placeHolder: UIImage(named: "baba"))
                }
                
                cell.callback = {
                    self.imgarray.remove(at: indexPath.row)
                    let imgid = Int.getInt(self.userTimeLineoppdetails?.oppimage[indexPath.row].id)
                    self.deleteimageapi(imageid: imgid)
                    self.UploadimageCollectionView.reloadData()
                }
            }
            
            else{
                cell.image.image = imagearr[indexPath.row]
                cell.callback = {
                    self.imagearr.remove(at: indexPath.row)
                    self.UploadimageCollectionView.reloadData()
                }
            }
            return cell
        case self.UploaddocumentCollectionView:
            let cell = UploaddocumentCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadDocumentCollectionViewCell", for: indexPath) as! UploadDocumentCollectionViewCell
            
            if self.isedit == "True"{
                let obj = self.docarray[indexPath.item].oppr_document
                print("documenturl=-=-=-=\(obj)")
                let documenturl = "\(self.docUrl)/\(String.getString(obj))"
                print("fulldocumenturl=-=-=-\(documenturl)")
                
                cell.lbldocument.text = obj
                
                cell.callbackclose = {
                    self.docarray.remove(at: indexPath.row)
                    self.UploaddocumentCollectionView.reloadData()
                    
                }
            }
            
            else{
                cell.lbldocument.text = docummentarray[indexPath.row]
                cell.callbackclose = {
                    self.docummentarray.remove(at: indexPath.row)
                    self.UploaddocumentCollectionView.reloadData()
                }
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
        
        //        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        
        //        let documentTypes =  ["public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.composite-content", "public.text"]
        let documentType = [kUTTypePDF as String]
        //[String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)
        let documentsPicker = UIDocumentPickerViewController(documentTypes: documentType, in: .import)
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
        //        print("doc path=-=-=\(doc)")
        self.documentarr.append(url)
        print("doc documentarr=-=-=\(documentarr)")
        self.docummentarray.append(url.lastPathComponent)
        print("doc documentarrCount=-=-=\(documentarr.count)")
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

extension RockPitOpportunityVC{
    func setTextFieldUI(textField:SKFloatingTextField,place:String,showFloating:Bool ,floatingText:String){
        textField.delegate = self
        textField.showFloatingTitle(isShow: showFloating)
        //textField.placeholder = place
        textField.activeBorderColor = .init(red: 21, green: 114, blue: 161)
        textField.floatingLabelText = floatingText
        textField.floatingLabelColor = .init(red: 21, green: 114, blue: 161)
        textField.setRoundTFUI()
    }
    
    func setTextField(textField:SKFloatingTextField,place:String,floatingText:String){
        textField.delegate = self
        textField.placeholder = place
        textField.activeBorderColor = .init(red: 21, green: 114, blue: 161)
        textField.floatingLabelText = floatingText
        textField.floatingLabelColor = .init(red: 21, green: 114, blue: 161)
        textField.setRoundTFUI()
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
                    if self.isedit == "True"{
                        for i in 0 ..< self.getstatelist.count - 1{
                            if String.getString(self.userTimeLineoppdetails?.opp_state) == String.getString(self.getstatelist[i].id){
                                self.lblState.text = String.getString(self.getstatelist[i].state_name)
                                return
                            }
                        }
                    }
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
                    if self.isedit == "True"{
                        for i in 0 ..< self.getlocalitylist.count - 1{
                            if String.getString(self.userTimeLineoppdetails?.opp_locality) == String.getString(self.getlocalitylist[i].id){
                                self.lblLocality.text = String.getString(self.getlocalitylist[i].local_name)
                                return
                            }
                        }
                    }
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
    
    
    //    Create Opportunity Api
    
    func createopportunityapi(){
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
        
        let lookingforid = Int(self.lookingforid ?? 0)
        debugPrint("checklookingforid",lookingforid)
        
        let stateid = Int(self.stateid ?? 0)
        debugPrint("checkstateid",stateid)
        
        let localityid = Int(self.localityid ?? 0)
        debugPrint("checklocalityid",localityid)
        
        let params:[String : Any] = [
            "user_id":"\(String(describing: userid))",
            "category_id":"1",
            "sub_category":"\(String(describing: subcatid))",
            "title":String.getString(self.txtFieldTitle.text),
            "opp_state":"\(String(describing: stateid))",
            "opp_locality":"\(String(describing: localityid))",
            "location_name":String.getString(self.txtFieldLocationName.text),
            "description":String.getString(self.TextViewDescription.text),
            "mobile_num":String.getString(self.txtFieldMobileNumber.text),
            "whatsaap_num":String.getString(self.txtFieldWhatsappNumber.text),
            "pricing":String.getString(self.txtFieldPricing.text),
            "looking_for":"\(String(describing: lookingforid))",
            "plan":String.getString(plan),
            "location_map":String.getString(self.lblLocationOnMap.text),
            "latitude":String.getString(self.latitude),
            "longitude":String.getString(self.longitude),
            "cat_type_id":"0"
        ]
        
        let uploadimage:[String:Any] = ["filenames[]":self.imagearr]
        let uploaddocument:[String:Any] = ["opportunity_documents[]":self.documentarr]
        
        debugPrint("filenames[]......",self.imagearr)
        debugPrint("opportunity_documents[]......",self.documentarr)
        
        
        TANetworkManager.sharedInstance.requestMultiPartwithlanguage(withServiceName:ServiceName.kcreateopportunity , requestMethod: .post, requestImages: [:], requestdoc: [:],requestVideos: [:], requestData:params, req: self.imagearr, req:self.documentarr)
        {(result:Any?, error:Error?, errortype:ErrorType?, statusCode:Int?) in
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
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                        if self.planpayment == 0{
                            kSharedAppDelegate?.makeRootViewController()
                        }
                        
                        else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: PaymentForFeatureandPremiumPopUPVC.getStoryboardID()) as! PaymentForFeatureandPremiumPopUPVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.plan = self.planpayment
                            
                            vc.callbackamount = { Price in
                                self.amount = Price
                                print("amount=-=-\(self.amount)")
                            }
                            
                            vc.callback = { txt in
                                
                                if txt == "Pay"{
                                    vc.dismiss(animated: false) {
                                        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PaymentforFeaturePremiumVC") as! PaymentforFeaturePremiumVC
                                        vc.price = self.amount
                                        vc.opptype = self.planpayment
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                            self.present(vc, animated: false)
                        }
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
    // Update Opportunity Api
    
    func updateopportunityapi(){
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
        
        let oppid = Int(self.oppid ?? 0) // For remove optional
        debugPrint("checkoppid",oppid)
        
        let subcatid = Int(self.subcatid ?? 0)
        debugPrint("checksubcatid",subcatid)
        
        let stateid = Int(self.stateid ?? 0)
        debugPrint("checkstateid",stateid)
        
        let localityid = Int(self.localityid ?? 0)
        debugPrint("checklocalityid",localityid)
        
        let lookingforid = Int(self.lookingforid ?? 0)
        debugPrint("checklookingforid",lookingforid)
        
        let params:[String : Any] = [
            "oppr_id":700,
            "category_id":"1",
            "sub_category":"\(String(describing: subcatid))",
            "title":String.getString(self.txtFieldTitle.text),
            "opp_state":"\(String(describing: stateid))",
            "opp_locality":"\(String(describing: localityid))",
            "location_name":String.getString(self.txtFieldLocationName.text),
            "location_map":String.getString(self.currentadd),
            "description":String.getString(self.TextViewDescription.text),
            "mobile_num":String.getString(self.txtFieldMobileNumber.text),
            "whatsaap_num":String.getString(self.txtFieldWhatsappNumber.text),
            "pricing":String.getString(self.txtFieldPricing.text),
            "looking_for":"\(String(describing: lookingforid))",
            "plan":String.getString(plan),
            "latitude":String.getString(self.latitude),
            "longitude":String.getString(self.longitude)
        ]
        
        let uploadimage:[String:Any] = ["filenames[]":self.imagearr]
        let uploaddocument:[String:Any] = ["opportunity_documents[]":self.documentarr]
        
        debugPrint("image[]......",self.imagearr)
        debugPrint("opportunity_documents[]......",self.documentarr)
        
        
        TANetworkManager.sharedInstance.UpdatetMultiPartwithlanguage(withServiceName:ServiceName.kupdateopportunity , requestMethod: .post, requestImages: [:], requestdoc: [:],requestVideos: [:], requestData:params, req: self.imagearr, req:self.documentarr)
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
                    else if  Int.getInt(dictResult["status"]) == 401{
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
    
    //    Delete image Api
    
    func deleteimageapi(imageid:Int){
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
            "oppr_id":imageid  // its image id
        ]
        
        debugPrint("imageid......",imageid)
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kdeleteoppimage, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
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
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 404{
                        
                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        // kSharedAppDelegate?.makeRootViewController()
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

// MARK: - Localisation
extension RockPitOpportunityVC{
    func setuplanguage(){
        lblSelectImages.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select images", comment: "")
        lblSelectdocuments.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select documents", comment: "")
        lblSubCategory.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Select subcategory", comment: "")
        txtFieldTitle.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Title", comment: "")
        txtFieldTitle.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Title", comment: "")
        lblState.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "State", comment: "")
        lblLocality.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Locality", comment: "")
        txtFieldLocationName.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location name", comment: "")
        txtFieldLocationName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location name", comment: "")
        txtFieldMobileNumber.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mobile number", comment: "")
        txtFieldMobileNumber.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mobile number", comment: "")
        txtFieldWhatsappNumber.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Whatsapp number", comment: "")
        txtFieldWhatsappNumber.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Whatsapp number", comment: "")
        txtFieldPricing.floatingLabelText = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Price in US Dollar (optional)", comment: "")
        txtFieldPricing.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Price in US Dollar (optional)", comment: "")
        
        lblLocationOnMap.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Pin Location on map(optional)", comment: "")
        lblLookingFor.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Looking for", comment: "")
        lblBasic.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Basic", comment: "")
        lblFeature.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Featured", comment: "")
        lblPremium.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Premium", comment: "")
        btnCreateOpp.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Create opportunity", comment: ""), for: .normal)
    }
}
