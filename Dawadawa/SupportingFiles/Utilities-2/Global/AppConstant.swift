//  AppConstant.swift
//  CommonCode
//  Created by Ritesh Gupta on 6/10/17.
//  Copyright © 2017 Ritesh Gupta. All rights reserved.

import Foundation
import UIKit

//MARK:- Global Variables

let user_type = UserData.shared.user_type ?? ""

let sharedSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

// MARK: - Structure

//typealias  JSON = [String:Any]?

let kAppName                    = "DawaDawa"
let kIsTutorialAlreadyShown     = "isTutorialAlreadyShown"
let kIsUserLoggedIn             = "isUserLoggedIn"
let kLoggedInAccessToken        = "token"
let kLoggedInUserDetails        = "data"
let kOpportunityData            = "Opportunity"
let kLoggedInUserId             = "loggedInUserId"
let kLocationPreferences        = "LocationPreferences"
let kLatitude                   = "latitude"
let kLongitude                  = "longitude"
let kIsOtpVerified              = "is_mobile_verified"
let kIsProfileCreated           = "is_profile_create"
let kIs_Active                  = "is_active"
let kIs_Notification            = "is_notification"
let kIsAppInstalled             = "isAppInstalled"
let kAccessToken                = "access_token"
let kDeviceToken                = "device_token"
let kemail                      = "email"
let kLanguage                   = "Language"
let kEnglish                    = "English"
let kArabic                     = "Arabic"
let kUpdateLanguage             = "kUpdateLanguage"
let kacceptlanguage             = "Accept-Language"
let kdefaultlanguage            = "language"
let iosDeviceType               = "1"
let iosDeviceTokan              = "123456789"
let kpayment_type               = "payment_type"
var kBucketUrl                  = ""

let kSharedAppDelegate          = UIApplication.shared.delegate as? AppDelegate
let kSharedInstance             = SharedClass.sharedInstance
let kSharedSceneDelegate        = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
let kSharedUserDefaults         = UserDefaults.standard
let kScreenWidth                = UIScreen.main.bounds.size.width
let kScreenHeight               = UIScreen.main.bounds.size.height
let kRootVC                     = UIApplication.shared.windows.first?.rootViewController
let kBundleID                   = Bundle.main.bundleIdentifier!


struct APIUrl {
    //    static let kBaseUrl = "18.217.107.168:3010/user/"
    //    static let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
}

struct Keys {
    static let kDeviceToken     = "deviceToken"
    static let kAccessToken     = "access_token"
    static let kFirebaseId      = "firebaseId"
    static let kMobileVerified  = "isMobileVerified"
    static let kUserName        = "username"
    static let alphabet         = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
}

struct ServiceName {
    static let kcreateAccount         =       "api/register_new"
    static let kOtpVerify             =       "api/verify_user"
    static let klogin                 =       "api/login"
    static let kforgotpassword        =       "api/forgot-password" // this api is also used for change password
    static let kverifyforgototp       =       "api/verify-forgot-otp"
    static let kresetpassword         =       "api/forgot-psd"
    static let kresendotp             =       "api/resend-user-verify"
    static let kchangepassword        =       "api/change-password"
    static let keditprofileimage      =       "api/edit-profile-image"
    static let kedituserdetails       =       "api/edit-user-detail"
    static let kchangeemail           =       "api/change-email"
    static let kgooglelogin           =       "api/google-login"
    static let knewemailotpverify     =       "api/change-email-otp-verify"
    
    static let ktermsandcondition     =        "api/terms"
    static let kprivacypolicy         =        "api/privacy-policy"
    static let kAboutUs               =        "api/about"
    static let kFaq                   =        "api/faq"
   
    static let kgetcategory           =        "api/category"
    static let ksubcategory           =        "api/sub-category"
    static let kgetstate              =        "api/state"
    static let kgetlocality           =        "api/locality"
    static let kgetlookingfor         =        "api/looking-for"
    static let kgetSerivetype         =        "api/services-type"
    static let kgetbusinessminingtype =        "api/business-mining-type"
    
    //    Opportunity
    static let kcreateopportunity       =        "api/create-opportunities"
    static let klistopportunity         =        "api/list-opportunities"
    static let kdeleteopportunity       =        "api/delete-opportunities"
    static let kdeleteoppimage          =        "api/delete-oppr-image"
    static let kdeleteoppdoc            =        "api/delete-oppr-document"
    static let kcloseopportunity        =        "api/close-opportunities"
    static let kgetallopportunity       =        "api/all-opportunity/"
    static let kflagpost                =        "api/flag-opportunity"
    static let kgetpremium              =        "api/opportunity-premium/\(UserData.shared.id)"
    static let kgetFeatured             =        "api/featured-opportunity"
    static let klikeopportunity         =        "api/like_opportunity"
    static let ksearchopportunity       =        "api/search-opportunity"
    static let kopportunitydetails      =        "api/opportunity-detail"
    static let kupdateopportunity       =        "api/update-opportunity"
    
    //    Filter
    static let kfiltersubcategory      =         "api/filter-sub-category"
    static let kfilter                 =         "api/opr-filter"
    
    //    Guest
    static let kguestcategory          =          "api/guest-category"
    static let kguestfiltersubcategory =          "api/guest-filter-sub-category"
    static let kguestservicetype       =          "api/guest-services-type"
    static let kgueststate             =          "api/guest-state"
    static let kguestlocality          =          "api/guest-locality"
    static let kguestfilter            =          "api/guest-opr-filter"
    static let kguestgetallopportunity  =         "api/guest-all-opportunity"
    static let kguestsearchopportunity  =         "api/guest-search-opportunity"
    
    //   Save Opp
    static let ksaveOpp                 =         "api/saveOpr"
    static let kgetsaveOppList          =         "api/savedOprList/\(UserData.shared.id)"
    static let kunsavedopp              =         "api/unsaveOpr"
    
    //   Mark Interested
    static let kmarkinterested          =          "api/mark-opportunity"
    static let kgetinterestedOppList    =          "api/markOprList/\(UserData.shared.id)"
    
    // Comment Opp
    static let kaddcomment              =         "api/comment-opportunity"
    static let kcommentreply            =         "api/commentreply-opportunity"
    
    // Rate Opp/User
    static let krateopp                =           "api/rateOpr"
    static let krateuser               =           "api/rateUser"
    
    // UserData
    static let kuserdata               =           "api/userData"
    
    // Payment And Subscription
    static let kgetsubscriptionplan    =           "api/getSubscriptionPlan/"
    static let kstorepayment           =           "api/storePayment"
    static let kgetactiveplan          =           "api/investorActivePlan/"
    static let kgettransactionhistory  =           "api/getTransactionHistory/"
    static let kgetplanamount          =           "api/plan-amount/"
    
   // Dashboard
    static let kdashboard              =           "api/dashboard"
    
  //  Notification
    static let kcountNotification      =            "api/countNotification/\(UserData.shared.id)"
    static let kgetallNotification     =            "api/getallNotification/\(UserData.shared.id)"
    static let kreadNotification       =            "api/readNotification"
    static let kmarkallread            =            "api/markall-read"
    
//    Report Opp/User
    static let kreportuser             =            "api/reportUser"
    
//    Chat
    static let kaddfriend              =            "api/userConversion"
    static let ksendmessage            =            "api/send-message"
    static let kgetmessage             =            "api/getmessage"
    static let kdeleteUsermessage      =            "api/delete-user-message"
    
//    Like List
    static let klikelist               =            "api/UserListLikesOpr"
    
//    Check Email and Phone
    static let kcheckemail             =            "api/email-already-exists"
    static let kcheckphone             =            "api/phone-already-exists"
    static let kgetcontactus              =            "api/contact_us"
}

struct Notifications {
    static let KProfileimage                    =  "Please upload the Image "
    static let kDOB                             =  "Please Enter Date of Birth"
    static let kEnterMobileNumber               =  "Please Enter Mobile Number"
    static let kentermobileemail                =  "Please Enter Your Mobile Number/Email Address"
    static let kEnterValidMobileNumber          =  "Please Enter Valid Mobile Number"
    static let kentervalidphoneemail            =  "Please Enter Valid Mobile Number/Email Address"
    static let kcountrycode                     =  "Please Select Country Code"
    static let kEnterUserId                     =  "Please Enter User Id"
    static let kEnterEmail                      =  "Please Enter your EmailId"
    static let kEnterValidEmail                 =  "Please Enter Valid Email Id"
    static let kName                            =  "Please Enter  Name"
    static let Kimage                           =  "Please Select Image"
    static let kPassword                        =  "Please Enter Password"
    static let kValidPassword                   =  "Password should contain atleast 8 characters, one uppercase, one lowercase including digits and special characters"
    static let kConfirmPassword                 =  "Please Enter Confirm Password"
    static let kNewPassword                     =  "Please Enter Password"
    
    static let kvalidusername                   =  "Please Enter Valid User Name"
    static let kvalidfirsname                   =  "Please Enter Valid First Name"
    static let kvalidlastname                   =  "Please Enter Valid Last Name"
    
    static let kGender                          =  "Please select your gender"
    static let knationalid                      =  "Please Enter your NationalID"
    static let Kpassport                        =  "Please Enter your Passport number"
    static let kvehimg                          =  "Please upload Your vehicle Image"
    static let kvehreg                          =  "Please Uplaod Your Vehicle registration Image"
    static let kvehinsu                         =  "Please Upload your Vehicle Insurance Image"
    static let kvehlicence                      =  "Please upload Your Vehicle Licence Image"
    static let kMatchPassword                   =  "Password & Confirm Password doesn't match"
    static let kEnterOTP                        =  "OTP Can't be Empty"
    static let kEnterFullName                   =  "Please Enter Full Name"
    static let kvalidFullName                   =  "Please Enter Valid Full Name"
    static let kusername                        =  "Please Enter user Name"
    static let kEnterValidFirstName             =  "First Name required alphabets only"
    static let kEnterLastName                   =  "Please Enter Last Name"
    static let kEnterValidLastName              =  "Last Name required alphabets only"
    static let kEnterPassword                   =  "Please Enter Password"
    static let kReEnterPassword                 =  "Please Enter Confirm Password"
    static let kEnterValidPassword              =  "Please Enter Valid Password"
    static let kFirstName                       =  "Please Enter First Name"
    static let kLastName                        =  "Please Enter Last Name"
    static let kEnterValidEmailId               =  "Please Enter Valid Email ID"
    static let kEmailId                         =  "Please Enter Email ID"
    static let kPasswordRange                   =  "Password Should be Minimum Of 8 digits"
    static let kPasswordMatch                   =  "Password & Confirm Password Should Be Same"
    static let kAcceptCond                      =  "Please Accept terms and conditions"
    static let kcheckbutton                     =  "Please Accept terms & condition"
    static let kConfirmpassword                 =  "Please Enter Confirm Password  "
    static let kconfirmMismatch                 =  "Password does not match "
    static let kAllergic                        =  "Please Select Allergic"
    
    static let ktitle                           =  "Please Enter the Title"
    static let KValidtitle                      =  "Please Enter valid title"
    static let kLocationName                    =  "Please Enter the Location Name"
    static let kvalidlocationname               =  "Please Enter the Valild Location Name"
    static let kDescription                     =  "Please Enter the description"
    static let kwhatsappnumber                  =  "Please Enter the whatsapp Number"
    static let kvalidwhatsappnumber             =  "Please Enter Valid Whatstapp Number"
    static let kbusinessname                    =  "Please Enter Business Name"
    static let kbusinessBlock                   =  "Please Enter Business Mining Block"
    
}

struct ApiParameters {
    static let message = "message"
    static let kFirst_name = "first_name"
    static let kLast_name = "last_name"
    static let kMobile_number = "mobile_number"
    static let kcountry_code = "country_code"
    static let kPassword = "password"
    static let kDevice_type = "device_type"
    static let kDevice_token = "device_token"
    static let klatitude = "latitude"
    static let klongitude = "longitude"
    static let date_of_birth = "date_of_birth"
    static let kGender = "gender"
    static let kallergic_to = "allergic_to"
    static let kprofileImage = "profile_image"
    static let ksecret_key = "secret_key"
    static let kotp_value = "otp_value"
    static let kuploadImage = "upload_file"
    static let KuploadProfileImages = "images"
    
    static let kvehicleImages = "vehicleImages"
    static let kvehicleRegistrationImages = "vehicleRegisterationImages"
    static let kvehicleInsuranceImage = "vehicleInsuranceImages"
    static let kvehicleLicenseImage = "driverLicenceImages"
}
enum CommunicationType{
    case audio,video,chat,none
}
struct CustomColor {
    
    static let kGreen               = UIColor.init(red: 50/255,  green: 185/255, blue: 113/255, alpha: 1)
    static let kRed                 = UIColor.init(red: 229/255,  green: 49/255, blue: 38/255, alpha: 1)
    static let kSenderPlay          = UIColor.init(red: 198/255,  green: 212/255, blue: 225/255, alpha: 0.4)
    static let kReceiverPlay        = UIColor.init(red: 115/255,  green: 120/255, blue: 128/255, alpha: 1)
    static let kBlack               = UIColor.init(red: 0/255,  green: 0/255, blue: 0/255, alpha: 0.05)
    static let kGray                = UIColor.init(red: 158/255,  green: 161/255, blue: 167/255, alpha: 1)
    static let kLightRed            = UIColor.init(red: 89/255,  green: 124/255, blue: 236/255, alpha: 1)
    static let kDarkRed             = UIColor.init(red: 57/255,  green: 83/255, blue: 164/255, alpha: 1)
    static let kChatHeader          = UIColor.init(red: 142/255,  green: 148/255, blue: 156/255, alpha: 1)
    
}

struct NumberContants {
    static let kMinPasswordLength = 8
}


struct  AlertMessage {
    static let kDefaultError                  = "Something went wrong. Please try again."
    static let knoNetwork                     = "Please check your internet connection !"
    static let kSessionExpired                = "Your session has expired. Please login again. -> 🚀 "
    static let kNoInternet                    = "Unable to connect to the Internet. Please try again."
    static let kInvalidUser                   = "Oops something went wrong. Please try again later."
    static let knoData                        = "No Data Found 🎈"
    static let noName                         = "Empty name 🚀"
    static let Under_Development              = "Under Development 👨‍🏫"
    static let logout                         = "Are you sure you want to logout?"
    static let signin                         = "Please sign in first."
    static let currentPagealert               = "you are already on this page 🤣 -> 🚀"
}

struct Identifiers {
    static let kLoginVc                               = "LoginVC"
    static let kSelectLangVc                          = "SelectLangViewController"
    static let kWalkthroughCVC                        = "WalkthroughCVC"
    static let kPersonalDetailsVC                     = "PersonalDetailsViewController"
    static let kMedicalIDVC                           = "MedicalIDViewController"
    static let kLifeStyleVC                           = "LifeStyleViewController"
    static let kbannerCVC                             = "BannerCollectionViewCell"
    static let kResetPassVC                           = "ResetPassViewController"
    static let kForgotPassVC                          = "ForgotPassViewController"
    static let kOtpVerificationVC                     = "OtpVerificationViewController"
    static let kSignUpVC                              = "SignUpViewController"
    static let kCartController                        = "MyCartViewController"
    static let kPromoCodeController                   = "PromoCodeListViewController"
    static let kMapController                         = "MapViewController"
    static let kAddOnsController                      = "AddOnsViewController"
    static let kMenuController                        = "MenuViewController"
    static let kPaymentController                     = "MakePaymentViewController"
    static let kOrderPlacedPopUpController            = "OrderPlacedPopUpViewController"
    static let kHome                                  = "HomeVC"
    static let kMedicalDetailsVC                      = "MedicalDetailsViewController"
    static let kSearchMedicalInfoVC                   = "SearchMedicalInfoViewController"
    //MARK:- tableView cell Constants
    static let kEmergencyContactsTVCell        = "EmergencyContactsTableViewCell"
}

struct Storyboards {
    static let kMain                           = "Main"
    static let kHome                           = "Home"
    static let KsellerHome                     = "HomeSeller"
    static let kServiceHome                    = "HomeServices"
    static let kDoctor                         = "MyDoctors"
    static let kHospitals                      = "Hospitals"
    static let kOrders                         = "Orders"
    static let kChat                            = "Chat"
}
struct ServiceIconIdentifiers {
    static let video = "video_call_sm"
    static let home = "home_visit"
    static let chat = "chat_sm"
    static let audio = "call_sm"
    static let clinic = "clinic_visit_sm"
}
struct ServicesIdentifiers{
    static let video = "video"
    static let home = "home"
    static let chat = "chat"
    static let audio = "audio"
    static let clinic = "visit"
}

enum HasCameFrom{
    case signUp,login,forgotPass,none,reset, resendSignUp, resendForgot, signUpUnverified, discountedApps,loyaltyCards
}

enum PostTypes{
    case text,media,poll,findExpert,share
}
enum profileData{
    case education,certificate,experience
}
enum listingData{
    case degree,industry,organization
}
enum likeType{
    case post,comment
}
enum rejectionType{case receiver,sender}

enum addSymptomsEnum{
    case allergie,currentMedications,pastMedications,chronicDisease,injuries,surgeries,none
}
struct AlertTitle {
    static let kOk                = "OK"
    static let kCancel            = "Cancel"
    static let kDone              = "Done"
    static let ChooseDate         = "Choose Date"
    static let SelectCountry      = "Select Country"
    static let logout             = "Logout"
    static let kInvalidOtp        = "Invalid OTP"
}

struct Notification {
    static let kEmail = "Please Enter Email"
    static let kValidmail = "Please Enter Valid Email"
    static let kPassword = "Please Enter Password"
}


struct Cellidentifier {
    
    static let IntroductionCell    = "IntroductionCell"
    static let SidebarMenuCell     = "SidebarMenuCell"
    
}

struct OtherConstant {
    static let kAppDelegate        = UIApplication.shared.delegate as? AppDelegate
    // static let kRootVC             = UIApplication.shared.keyWindow?.rootViewController
    static let kBundleID           = Bundle.main.bundleIdentifier!
    static let kGenders: [String]  = ["Male", "Female", "Other"]
    static let kReviewsSortBy: [String] = ["Recent", "Last Month", "Last Year"]
}

func Localised(_ aString:String) -> String {
    
    return NSLocalizedString(aString, comment: aString)
}



struct Indicator {
    
    static func showToast(message aMessage: String)
    {
        DispatchQueue.main.async
        {
            showAlertMessage.alert(message: aMessage)
        }
    }
}

// Enums
enum PhotoSource {
    case library
    case camera
}

enum MessageType {
    case photo
    case text
    case video
    case audio
}

enum MessageOwner {
    case sender
    case receiver
}

enum BottomOptions: Int {
    case search = 0
    case match
    case message
    case post
}

//enum HasCameFrom{
//    case Forgot // forgot Password flow
//    case SignUp
//    case ResetPassword
//}

enum AppColor {
    case Blue, Red
    var color : UIColor {
        switch self {
        case .Blue:
            return UIColor.blue
        case .Red:
            return UIColor.init(hexString: "#C7003B")
        }
    }
}


enum OpenMediaType: Int {
    case camera = 0
    case photoLibrary
    case videoCamera
    case videoLibrary
}



enum AppFonts {
    case bold(CGFloat),regular(CGFloat)
    var font:UIFont {
        switch self {
        case .bold(let size):
            return UIFont (name: "System", size: size)!
        case .regular(let size):
            return UIFont.systemFont(ofSize: size)
        }
    }
}



//// MARK: ---------Color Constants---------

let appThemeUp               = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
let appThemeDown             = UIColor.init(red: 251/255, green: 136/255, blue: 51/255, alpha: 1)

//MARK: ---------Method Constants---------


func print_debug(items: Any) {
    print(items)
}

func print_debug_fake(items: Any) {
}
