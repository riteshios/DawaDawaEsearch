//  FilterVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 28/07/22.

import UIKit
import RangeSeekSlider
import Alamofire
import SwiftyJSON

var filteredArray:[String] = [] // Global
var userTimeLine = [SocialPostData]()
var cameFrom = ""

class FilterVC: UIViewController{
    
    //    MARK: - Properties -
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
    
    @IBOutlet weak var btnPriceLtoH: UIButton!
    @IBOutlet weak var btnPriceHtoL: UIButton!
    @IBOutlet weak var btnDateNtoO: UIButton!
    @IBOutlet weak var btnDateOtoN: UIButton!
    
    @IBOutlet weak var imgradiopriceLtoH: UIImageView!
    @IBOutlet weak var imgradiopriceHtoL: UIImageView!
    @IBOutlet weak var imgradiodateNtoO: UIImageView!
    @IBOutlet weak var imgradiodateOtoN: UIImageView!
    
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
    
    @IBOutlet weak var viewToday: UIView!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var btnToday: UIButton!
    
    @IBOutlet weak var viewLastweek: UIView!
    @IBOutlet weak var lblLastweek: UILabel!
    @IBOutlet weak var btnLastweek: UIButton!
    
    @IBOutlet weak var viewLastMonth: UIView!
    @IBOutlet weak var lblLastmonth: UILabel!
    @IBOutlet weak var btnLastmonth: UIButton!
    
    @IBOutlet weak var viewCustomrange: UIView!
    @IBOutlet weak var lblCustomrange: UILabel!
    @IBOutlet weak var btnCustomrange: UIButton!
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnApplyfilter:UIButton!
    
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblOpportunitystatus: UILabel!
    @IBOutlet weak var lblOpportunitytype: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOpportunityStatus:UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServicetype:UILabel!
    @IBOutlet weak var lblSortby:UILabel!
    @IBOutlet weak var lblPricelowtohigh: UILabel!
    @IBOutlet weak var lblpricehightolow: UILabel!
    @IBOutlet weak var lbldateNewesttooldest: UILabel!
    @IBOutlet weak var lblDateoldesttonewest: UILabel!
    
    
    var getCategoryarr         =      [getCartegoryModel]()
    var getfiltersubcatarr     =      [getfiltersubcategoryModel]()
    var getServiceTypearr      =      [getServicetypeModel]()
    var getstatelistarr        =      [getstateModel]()
    var getlocalitylist        =      [getLocalityModel]()
    var getguestlocalitylist   =      [getlocalityModel]()
    //    var userTimeLine           =      [SocialPostData]()
    
    
    var selectedIds:[String] = []
    var selectedsubids:[String] = []
    var selectedservicetypesids:[String] = []
    var stringcatid = ""
    var imgUrl = ""
    
    var like = ""
    var rating = ""
    var oppstatus:String?
    var servicetype:Int?
    var today:String?
    var lastweek:String?
    var lastmonth:String?
    var sortby:Int?
    var selectedoptype = ""
    var selectedsuboptype = ""
    var selectedservicetype = ""
    
    var timePicker = UIDatePicker()
    var stateid:Int?
    var localityid:Int?
    
    var minprice:Int?
    var maxprice:Int?
    
    //    MARK: - UIView and Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuplanguage()
        
        if UserData.shared.isskiplogin == true{
            self.guestcategory()
            self.guestservicetype()
            self.gueststateapi()
        }
        else{
            self.getCartListApi()
            self.getservicetypeapi()
            self.getstateapi()
        }
        
        self.slidersetup()
        self.setuptableview()
        self.setupstartdate()
        self.setupendtdate()
    }
    
    private func setuptableview(){
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
        PriceSlider.numberFormatter.positiveSuffix = ""
    }
    
    private func resetsetup(){
        self.viewMostLiked.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblMostLiked.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewLeastLiked.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblLeastLiked.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewMostRated.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblMostrated.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewLeastrated.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblLeastrated.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewAvailable.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblAvailable.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewClosed.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblClosed.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewSold.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblSold.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewToday.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblToday.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewLastweek.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblLastweek.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewLastMonth.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblLastmonth.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.viewCustomrange.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
        self.lblCustomrange.textColor = UIColor(red: 21, green: 114, blue: 161)
        self.imgradiopriceLtoH.image = UIImage(named: "radiouncheck")
        self.imgradiopriceHtoL.image = UIImage(named: "radiouncheck")
        self.imgradiodateNtoO.image = UIImage(named: "radiouncheck")
        self.imgradiodateOtoN.image = UIImage(named: "radiouncheck")
        self.txtfieldEndDate.text = ""
        self.txtfieldStartDate.text = ""
        self.lblState.text = "State"
        self.lblLocality.text = "Locality"
        
        self.like = ""
        self.rating = ""
        self.oppstatus = String()
        self.servicetype = Int()
        self.today = String()
        self.lastweek = String()
        self.lastmonth = String()
        self.sortby = Int()
        self.stateid = Int()
        self.localityid = Int()
        self.minprice = Int()
        self.maxprice = Int()
        
    }
    //    MARK: - @IBActions and Methods -
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnresetTapped(_ sender: UIButton) {
        self.resetsetup()
    }
    
    @IBAction func btnMostLikedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnMostLiked.isSelected == true{
            self.viewMostLiked.backgroundColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lblMostLiked.textColor = .white
            self.viewLeastLiked.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLeastLiked.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.like = "DESC"
            filteredArray.append("Most liked")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Least liked"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnLeasttikedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnLeastLiked.isSelected == true{
            self.viewLeastLiked.backgroundColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lblLeastLiked.textColor = .white
            self.viewMostLiked.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblMostLiked.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.like = "ASC"
            
            filteredArray.append("Least liked")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Most liked"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnmostratedTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if self.btnmostrated.isSelected == true{
            self.viewMostRated.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblMostrated.textColor = .white
            self.viewLeastrated.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLeastrated.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.rating = "DESC"
            filteredArray.append("Most rated")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Least rated"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnleastratedTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnleastrated.isSelected == true{
            self.viewLeastrated.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblLeastrated.textColor = .white
            self.viewMostRated.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblMostrated.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.rating = "ASC"
            filteredArray.append("Least rated")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Most rated"{
                    filteredArray.remove(at: i)
                    break
                }
            }
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
            self.oppstatus = String.getString("all")
            filteredArray.append("All")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Available"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Closed"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnAvailableTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnAvailable.isSelected == true{
            self.viewAvailable.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblAvailable.textColor = .white
            self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewClosed.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblClosed.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewSold.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblSold.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.oppstatus = String.getString("available")
            filteredArray.append("Available")
              for i in 0 ..< filteredArray.count - 1{
                        if filteredArray[i] == "All"{
                              filteredArray.remove(at: i)
                                        break
                                    }
                            }
              for i in 0 ..< filteredArray.count - 1{
                          if filteredArray[i] == "Closed"{
                                filteredArray.remove(at: i)
                                        break
                                    }
                         }
        }
    }
    
    @IBAction func btnClosedTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnClosed.isSelected == true{
            self.viewClosed.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblClosed.textColor = .white
            self.viewAvailable.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAvailable.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewSold.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblSold.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.oppstatus = String.getString("closed")
            filteredArray.append("Closed")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "All"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Available"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnSoldTapped(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        if self.btnSold.isSelected == true{
            self.viewSold.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblSold.textColor = .white
            self.viewAvailable.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAvailable.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewClosed.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblClosed.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewAll.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblAll.textColor = UIColor(red: 21, green: 114, blue: 161)
//            self.oppstatus = 5
        }
    }
    
    @IBAction func btnTodayTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnToday.isSelected == true{
            self.viewToday.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblToday.textColor = .white
            self.viewLastweek.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLastweek.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewLastMonth.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLastmonth.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewCustomrange.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblCustomrange.textColor =  UIColor(red: 21, green: 114, blue: 161)
            self.today = String.getString("todaydate")
            filteredArray.append("Today")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Last week"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Last month"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Custom range"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnLastweekTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnLastweek.isSelected == true{
            self.viewLastweek.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblLastweek.textColor = .white
            self.viewToday.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblToday.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewLastMonth.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLastmonth.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewCustomrange.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblCustomrange.textColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lastweek = String.getString("lastweek")
            filteredArray.append("Last week")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Today"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Last month"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Custom range"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    @IBAction func btnLastmonthTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnLastmonth.isSelected == true{
            self.viewLastMonth.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblLastmonth.textColor = .white
            self.viewLastweek.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLastweek.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewToday.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblToday.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewCustomrange.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblCustomrange.textColor =  UIColor(red: 21, green: 114, blue: 161)
            self.lastmonth = String.getString("lastmonth")
            filteredArray.append("Last month")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Last week"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Today"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Custom range"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    @IBAction func btnCustomrangeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnCustomrange.isSelected == true{
            self.viewCustomrange.backgroundColor = UIColor(red: 21, green: 114, blue: 161)
            self.lblCustomrange.textColor = .white
            self.viewLastweek.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLastweek.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewLastMonth.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblLastmonth.textColor = UIColor(red: 21, green: 114, blue: 161)
            self.viewToday.backgroundColor = UIColor(red: 241, green: 249, blue: 253)
            self.lblToday.textColor =  UIColor(red: 21, green: 114, blue: 161)
            if kSharedUserDefaults.getlanguage() as? String == "en"{
                self.showSimpleAlert(message: "Please Choose Start date to Last date")
            }
            else{
                self.showSimpleAlert(message: "الرجاء اختيار تاريخ البدء إلى آخر تاريخ")
            }
            
            filteredArray.append("Custom range")
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Last week"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Last month"{
                    filteredArray.remove(at: i)
                    break
                }
            }
            for i in 0 ..< filteredArray.count - 1{
                if filteredArray[i] == "Today"{
                    filteredArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    @IBAction func btnSelectStateTapped(_ sender: UIButton) {
        kSharedAppDelegate?.dropDown(dataSource: getstatelistarr.map{String.getString($0.state_name)}, text: btnState){
            (index,item) in
            self.lblState.text = item
            let id = self.getstatelistarr[index].id
            self.stateid = id
            debugPrint("State idddd.....btnnnnt",  self.stateid = id)
            
            if UserData.shared.isskiplogin == true{
                self.guestlocalityapi(id: self.stateid ?? 0)
            }
            else {
                self.getlocalityapi(id: self.stateid ?? 0 )
            }
        }
    }
    
    @IBAction func btnLocalityTapped(_ sender: UIButton) {
        if UserData.shared.isskiplogin == true{
            
            kSharedAppDelegate?.dropDown(dataSource: getguestlocalitylist.map{String.getString($0.local_name)}, text: btnLocality){
                (index,item) in
                self.lblLocality.text = item
                let id  = self.getguestlocalitylist[index].id
                self.localityid = id
                debugPrint("localityid....",self.localityid)
                
            }
        }
        
        else{
            kSharedAppDelegate?.dropDown(dataSource: getlocalitylist.map{String.getString($0.local_name)}, text: btnLocality){
                (index,item) in
                self.lblLocality.text = item
                let id  = self.getlocalitylist[index].id
                self.localityid = id
                debugPrint("localityid....",self.localityid)
                
            }
        }
    }
    
    @IBAction func btnPriceLtoHTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnPriceLtoH.isSelected == true{
            self.imgradiopriceLtoH.image = UIImage(named: "darkcircle")
            self.imgradiopriceHtoL.image = UIImage(named: "radiouncheck")
            self.imgradiodateNtoO.image = UIImage(named: "radiouncheck")
            self.imgradiodateOtoN.image = UIImage(named: "radiouncheck")
            self.sortby = 1
        }
    }
    
    @IBAction func btnPriceHtoLTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnPriceHtoL.isSelected == true{
            self.imgradiopriceHtoL.image = UIImage(named: "darkcircle")
            self.imgradiopriceLtoH.image = UIImage(named: "radiouncheck")
            self.imgradiodateNtoO.image = UIImage(named: "radiouncheck")
            self.imgradiodateOtoN.image = UIImage(named: "radiouncheck")
            self.sortby = 2
        }
    }
    
    @IBAction func btnDateNtoOTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnDateNtoO.isSelected == true{
            self.imgradiodateNtoO.image = UIImage(named: "darkcircle")
            self.imgradiopriceLtoH.image = UIImage(named: "radiouncheck")
            self.imgradiopriceHtoL.image = UIImage(named: "radiouncheck")
            self.imgradiodateOtoN.image = UIImage(named: "radiouncheck")
            self.sortby = 3
        }
    }
    
    @IBAction func btnDateOtoNTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnDateOtoN.isSelected == true{
            self.imgradiodateOtoN.image = UIImage(named: "darkcircle")
            self.imgradiopriceLtoH.image = UIImage(named: "radiouncheck")
            self.imgradiopriceHtoL.image = UIImage(named: "radiouncheck")
            self.imgradiodateNtoO.image = UIImage(named: "radiouncheck")
            self.sortby = 4
        }
    }
    
    @IBAction func btnApplyfilterTapped(_ sender: UIButton) {
        if UserData.shared.isskiplogin == true{
            self.guestfilterdataapi()
        }
        else{
            self.filterdataapi()
        }
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
                cell.btnSelectOpptype.addTarget(self, action: #selector(buttoncategoryTapped), for: .touchUpInside)
                cell.btnSelectOpptype.tag = indexPath.row
                cell.imgradio.image = obj.isselection == true ? UIImage(named: "darkcircle") : UIImage(named: "radiouncheck")
                
                return cell
                
            case 1:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "SubCategorylabelTableViewCell") as! SubCategorylabelTableViewCell
                return cell
                
            case 2:
                let cell = self.tblViewOpportunitytype.dequeueReusableCell(withIdentifier: "SubcategoryTableViewCell") as! SubcategoryTableViewCell
                
                let obj = self.getfiltersubcatarr[indexPath.row]
                cell.lblSubcategory.text = obj.sub_cat_name
                cell.btnSelect.addTarget(self, action: #selector(buttonsubcategoryTapped), for: .touchUpInside)
                cell.btnSelect.tag = indexPath.row
                cell.imgradio.image = obj.isselection == true ? UIImage(named: "darkcircle") : UIImage(named: "radiouncheck")
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case tblViewServicetype:
            let cell = self.tblViewServicetype.dequeueReusableCell(withIdentifier: "ServiceTypeTableViewCell", for: indexPath) as! ServiceTypeTableViewCell
            let obj = self.getServiceTypearr[indexPath.row]
            cell.lblServicetype.text = obj.services_type
            cell.btnSelection.addTarget(self, action: #selector(buttonserviceTypeTapped), for: .touchUpInside)
            cell.btnSelection.tag = indexPath.row
            cell.imgradio.image = obj.isselection == true ? UIImage(named: "darkcircle") : UIImage(named: "radiouncheck")
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
        case tblViewOpportunitytype:
            switch indexPath.section{
                
            case 0, 1, 2:
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
    
    
    @objc func buttoncategoryTapped(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let obj = self.getCategoryarr[sender.tag]
        if sender.isSelected {
            obj.isselection = true
            self.selectedIds.append(String.getString(obj.id))
            print("selectedIds---\(self.selectedIds)")
            
            let ids = self.selectedIds.joined(separator: ",")
            self.selectedoptype = ids
            print("selectedoptype=-=-=\(self.selectedoptype)")
            print(" selected   -ids---\(ids)")
            
            if UserData.shared.isskiplogin == true{
                self.guestfiltersubcategoryapi(catid: ids)
            }
            else{
                self.filtersubcategoryapi(catid: ids)
            }
            
        }else if sender.isSelected == false{
            for i in 0 ..< self.selectedIds.count{
                if String.getString(obj.id) == self.selectedIds[i]{
                    self.selectedIds.remove(at: i)
                    print(" RemoveselectedIds---\(self.selectedIds)")
                    obj.isselection = false
                    
                    let ids = self.selectedIds.joined(separator: ",")
                    self.selectedoptype = ids
                    print("selectedoptype=-=-=\(self.selectedoptype)")
                    
                    print(" selected   -ids---\(ids)")
                    if UserData.shared.isskiplogin == true{
                        self.guestfiltersubcategoryapi(catid: ids)
                    }
                    else{
                        self.filtersubcategoryapi(catid: ids)
                    }
                    break
                }
            }
        }
    }
    
    @objc func buttonsubcategoryTapped(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let obj = self.getfiltersubcatarr[sender.tag]
        if sender.isSelected {
            obj.isselection = true
            self.selectedsubids.append(String.getString(obj.id))
            print(" selectedSubIds---\(self.selectedsubids)")
            
            let ids = self.selectedsubids.joined(separator: ",")
            self.selectedsuboptype = ids
            
            print("selectedsuboptype=-=-=\(self.selectedsuboptype)")
            print(" selected Sub -ids---\(ids)")
            
            self.tblViewOpportunitytype.reloadData()
        }else if sender.isSelected == false{
            for i in 0 ..< self.selectedsubids.count{
                if String.getString(obj.id) == self.selectedsubids[i]{
                    self.selectedsubids.remove(at: i)
                    print(" RemoveselectedSubIds---\(self.selectedsubids)")
                    obj.isselection = false
                    
                    let ids = self.selectedsubids.joined(separator: ",")
                    self.selectedsuboptype = ids
                    
                    print("selectedsuboptype=-=-=\(self.selectedsuboptype)")
                    print(" selected Sub  -ids---\(ids)")
                    self.tblViewOpportunitytype.reloadData()
                    break
                }
            }
            
        }
    }
    
    @objc func buttonserviceTypeTapped(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let obj = self.getServiceTypearr[sender.tag]
        if sender.isSelected {
            obj.isselection = true
            self.selectedservicetypesids.append(String.getString(obj.id))
            print(" selectedServiceIds---\(self.selectedservicetypesids)")
            
            let ids = self.selectedservicetypesids.joined(separator: ",")
            self.selectedservicetype = ids
            
            print("selectedservicetype=-=-=\(self.selectedservicetype)")
            print(" selected service -ids---\(ids)")
            
            self.tblViewServicetype.reloadData()
        }else if sender.isSelected == false{
            for i in 0 ..< self.selectedservicetypesids.count{
                if String.getString(obj.id) == self.selectedservicetypesids[i]{
                    self.selectedservicetypesids.remove(at: i)
                    print(" RemoveselectedServiceIds---\(self.selectedservicetypesids)")
                    obj.isselection = false
                    
                    let ids = self.selectedservicetypesids.joined(separator: ",")
                    self.selectedservicetype = ids
                    
                    print("selectedserviceoptype=-=-=\(self.selectedservicetype)")
                    print(" selected Service  -ids---\(ids)")
                    self.tblViewServicetype.reloadData()
                    break
                }
            }
        }
    }
}

// MARK: - RangeSeekSliderDelegate

extension FilterVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === PriceSlider {
            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            self.minprice = Int(minValue)
            self.maxprice = Int(maxValue)
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
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
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
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
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
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
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kfiltersubcategory, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        DispatchQueue.main.async {
                            self?.tblViewOpportunitytype.reloadData()
                        }
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        self?.getfiltersubcatarr.removeAll()
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
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
                //                CommonUtils.showToastForDefaultError()
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
        
        let stateids = Int(self.stateid ?? 0) // For remove optional
        debugPrint("checkstateids",stateids)
        
        let localityid = Int(self.localityid ?? 0)
        debugPrint("checklocalityid",localityid)
        
        let params:[String : Any] = [
            "user_id":Int.getInt(UserData.shared.id),
            "most_like":String.getString(like),
            "rating":String.getString(rating),
            "opr_status":String.getString(oppstatus),
            "opr_type":selectedoptype,
            "opr_subtype":selectedsuboptype,
            "date":String.getString(today),
            "lastweek":String.getString(lastweek),
            "lastmonth":String.getString(lastmonth),
            "state":"\(String(describing: stateids))",
            "locality":"\(String(describing: localityid))",
            "services_type":selectedservicetype,
            "sort_by":Int.getInt(sortby),
            "start_date":String.getString(self.txtfieldStartDate.text),
            "end_date":String.getString(self.txtfieldEndDate.text),
            "min_price":Int.getInt(minprice),
            "max_price":Int.getInt(maxprice)
        ]
        
        // Added user id in api url
        TANetworkManager.sharedInstance.requestwithlanguageApi(withServiceName:ServiceName.kfilter, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
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
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(userTimeLine)")
                        
                        // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                        //  let vc = self?.storyboard?.instantiateViewController(withIdentifier: HomeVC.getStoryboardID()) as! HomeVC
                        //                        vc.cameFrom = "FilterData"
                        //                        vc.userTimeLine = self!.userTimeLine
                        //                        self?.navigationController?.pushViewController(vc, animated: true)
                        
                        cameFrom = "FilterData"
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        self?.tabBarController?.selectedIndex = 0
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //     CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //    MARK: - API For Guest
    
    //    Guest Category Api
    
    func guestcategory(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kguestcategory, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        let Categories = kSharedInstance.getArray(withDictionary: dictResult["Categories"])
                        self.getCategoryarr = Categories.map{getCartegoryModel(data: $0)}
                        DispatchQueue.main.async {
                            self.tblViewOpportunitytype.reloadData()
                        }
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //    CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    // Guest Filter Sub category Api
    
    func guestfiltersubcategoryapi(catid:String){
        CommonUtils.showHud(show: true)
        
        let stateids = Int(self.stateid ?? 0) // For remove optional
        debugPrint("checkstateids",stateids)
        
        let params:[String : Any] = [
            "category_id":catid
        ]
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestfiltersubcategory, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let Categories = kSharedInstance.getArray(withDictionary: dictResult["Categories"])
                        self?.getfiltersubcatarr = Categories.map{getfiltersubcategoryModel(data: $0)}
                        
                        //   CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        DispatchQueue.main.async {
                            self?.tblViewOpportunitytype.reloadData()
                        }
                    }
                    else if  Int.getInt(dictResult["status"]) == 400{
                        //     CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //  Guest Service Type Api
    
    func guestservicetype(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kguestservicetype, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let bmy = kSharedInstance.getArray(withDictionary: dictResult["bmy"])
                        self.getServiceTypearr = bmy.map{getServicetypeModel(data: $0)}
                        DispatchQueue.main.async {
                            self.tblViewServicetype.reloadData()
                        }
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        //    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                    // CommonUtils.showError(.info, String.getString(dictResult["message"]))
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    // Guest State Api
    
    func gueststateapi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName: ServiceName.kgueststate, requestMethod: .GET, requestParameters:[:], withProgressHUD: false) { (result:Any?, error:Error?, errorType:ErrorType?,statusCode:Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let state = kSharedInstance.getArray(withDictionary: dictResult["state"])
                        self.getstatelistarr = state.map{getstateModel(data: $0)}
                        
                    }
                    else if  Int.getInt(dictResult["status"]) == 401{
                        //    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                default:
                    CommonUtils.showError(.error, String.getString(dictResult["message"]))
                }
            }else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    //    Guest Locality Api
    
    func guestlocalityapi(id:Int){
        CommonUtils.showHud(show: true)
        
        
        let stateids = Int(self.stateid ?? 0) // For remove optional
        debugPrint("checkstateids",stateids)
        
        let params:[String : Any] = [
            "localitys_id":"\(String(describing: stateids))",
            
        ]
        // Added user id in api url
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestlocality, requestMethod: .POST, requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    
                    if Int.getInt(dictResult["status"]) == 200{
                        
                        let localitys = kSharedInstance.getArray(withDictionary: dictResult["localitys"])
                        self?.getguestlocalitylist = localitys.map{getlocalityModel(data: $0)}
                        
                        //     CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        DispatchQueue.main.async {
                            self?.tblViewOpportunitytype.reloadData()
                        }
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //                CommonUtils.showToastForDefaultError()
            }
        }
    }
    
    //    Guest Filter data Api
    
    func guestfilterdataapi(){
        CommonUtils.showHud(show: true)
        
        let stateids = Int(self.stateid ?? 0) // For remove optional
        debugPrint("checkstateids",stateids)
        
        let localityid = Int(self.localityid ?? 0)
        debugPrint("checklocalityid",localityid)
        
        let params:[String : Any] = [
            "most_like":String.getString(like),
            "rating":String.getString(rating),
            "opp_status":Int.getInt(oppstatus),
            "opr_type":selectedoptype,
            "opr_subtype":selectedsuboptype,
            "date":Int.getInt(today),
            "lastweek":Int.getInt(lastweek),
            "lastmonth":Int.getInt(lastmonth),
            "state":"\(String(describing: stateids))",
            "locality":"\(String(describing: localityid))",
            "services_type":selectedservicetype,
            "sort_by":Int.getInt(sortby),
            "start_date":String.getString(self.txtfieldStartDate.text),
            "end_date":String.getString(self.txtfieldEndDate.text)
        ]
        
        TANetworkManager.sharedInstance.requestlangApi(withServiceName:ServiceName.kguestfilter, requestMethod: .POST,requestParameters:params, withProgressHUD: false)
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
                        userTimeLine = Opportunity.map{SocialPostData(data: kSharedInstance.getDictionary($0))}
                        print("DataallSearchpost=\(userTimeLine)")
                        
                        //                        CommonUtils.showError(.info, String.getString(dictResult["message"]))
                        
                        //                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: HomeVC.getStoryboardID()) as! HomeVC
                        //                        cameFrom = "FilterData"
                        //                        vc.userTimeLine = self!.userTimeLine
                        //                        vc.hidesBottomBarWhenPushed = false
                        //                       vc.tabBarController?.hidesBottomBarWhenPushed = false
                        
                        cameFrom = "FilterData"
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        self?.tabBarController?.selectedIndex = 0
                        
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    else if  Int.getInt(dictResult["status"]) == 400{
                        
                        //  CommonUtils.showError(.info, String.getString(dictResult["message"]))
                    }
                    
                default:
                    CommonUtils.showError(.info, String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToastForInternetUnavailable()
                
            } else {
                //      CommonUtils.showToastForDefaultError()
            }
        }
    }
}

extension FilterVC{
    
    func setuplanguage(){
        lblFilter.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Filter", comment: "")
        lblLikes.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Likes", comment: "")
        lblMostLiked.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Most liked", comment: "")
        lblLeastLiked.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Least liked", comment: "")
        lblRating.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rating", comment: "")
        lblMostrated.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Most rated", comment: "")
        lblLeastrated.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Least rated", comment: "")
        lblOpportunitystatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Opportunity status", comment: "")
        lblAll.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "All", comment: "")
        lblAvailable.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Available", comment: "")
        lblClosed.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Closed", comment: "")
        lblSold.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Sold", comment: "")
        lblOpportunitytype.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Opportunity type", comment: "")
        lblDate.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Date", comment: "")
        lblToday.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Today", comment: "")
        lblLastweek.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last week", comment: "")
        lblLastmonth.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Last month", comment: "")
        lblCustomrange.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Custom range", comment: "")
        
        lblOpportunityStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Opportunity status", comment: "")
        lblState.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "State", comment: "")
        lblLocality.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Locality", comment: "")
        lblSortby.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Sort by", comment: "")
        lblPrice.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Price", comment: "")
        lblpricehightolow.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Price: High to Low", comment: "")
        lblPricelowtohigh.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Price: Low to High", comment: "")
        lbldateNewesttooldest.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Date: Newest to Oldest", comment: "")
        lblDateoldesttonewest.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Date: Oldest to Newest", comment: "")
        txtfieldStartDate.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Start date", comment: "")
        txtfieldEndDate.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "End date", comment: "")
        btnReset.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Reset", comment: ""), for: .normal)
        btnApplyfilter.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Apply Filter", comment: ""), for: .normal)
        
    }
}
