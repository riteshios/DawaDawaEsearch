import UIKit

enum Storyboard: String{
    case kMain = "Main"
    case KHome = "Home"
}

extension UIViewController {
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
    
    func showSimpleAlert(message:String) {
        let alert = UIAlertController(title: kAppName, message: message,preferredStyle: UIAlertController.Style.alert)
        
        //Add imageview to alert  // if want to add logo in alert message
        //            let imgViewTitle = UIImageView(frame: CGRect(x: 57, y: 10, width: 30, height: 30))
        //            imgViewTitle.image = UIImage(named:"Frame 726")
        //            alert.view.addSubview(imgViewTitle)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    static func getStoryboardID()->String {
        return String.init(describing: self)
    }
    
    static var storyboardID:String {
        return String(describing: self)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: kAppName, message: "Not Available for Guest User Please Register or Login to get full access of Account Features.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Skip", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Login",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        self.present(alert, animated: false, completion: nil)
    }
    
    func showalertarabic(){
        let alert = UIAlertController(title: kAppName, message: "غير متاح للمستخدم الضيف ، يرجى التسجيل أو تسجيل الدخول للوصول الكامل إلى ميزات الحساب.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "يتخطى", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "تسجيل الدخول",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        self.present(alert, animated: false, completion: nil)
    }
}


extension UIViewController {
    
    var isRootController: Bool {
        return (self.navigationController?.viewControllers.count ?? 0) == 1
    }
    
    static func getControllerObject<T : UIViewController>(storyboard: String, type: T.Type ) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: self.storyboardID) as! T
        return controller
    }
    
    static func getController(storyboard: Storyboard) -> Self {
        return getControllerObject(storyboard: storyboard.rawValue, type: self)
    }
    
    static func getVisibleController() -> UIViewController? {
        let controller = kSceneDelegateWindow?.rootViewController
        return visibleController(rootController: controller)
    }
    
    static func visibleController(rootController: UIViewController?) -> UIViewController? {
        guard let controller = rootController as? UINavigationController else {
            guard let tabC = rootController as? UITabBarController else {
                guard let presentedController = rootController?.presentedViewController else {
                    return rootController
                }
                return presentedController
            }
            return visibleController(rootController: tabC.selectedViewController)
        }
        return visibleController(rootController: controller.visibleViewController)
    }
}

//kydrawercontroller
extension UIViewController {
    
    
    //kydrawer controller
    //    func showController(storyboard: Storyboard, controllerType type: UIViewController.Type) {
    //        let controller = type.self.getController(storyboard: storyboard)
    //        self.showController(controller: controller)
    //    }
    
    
    func showPopUp(storyboard: Storyboard, controllerType type: UIViewController.Type) {
        let controller = type.self.getController(storyboard: storyboard)
        self.showPopUp(controller)
    }
    
    func showPopUp(_ controller: UIViewController) {
        controller.modalTransitionStyle     = UIModalTransitionStyle.crossDissolve
        controller.modalPresentationStyle   = UIModalPresentationStyle.overFullScreen
        //   controller.view.backgroundColor     = UIColor.darkGray.withAlphaComponent(0.5)
        self.present(controller, animated: true, completion: nil)
    }
    
    //     func showConfirmation(_ message : String, actiontitle : String , actiontitle2 :String ) {
    //
    //        let alert = UIAlertController.init(title: kAppName, message: message, preferredStyle: .alert)
    //
    //        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: { action in
    //            kAppDelegate.logOut()
    //        }))
    //        alert.addAction(UIAlertAction(title: actiontitle2, style: .cancel, handler: nil))
    //
    //        self.present(alert, animated: true)
    //    }
    
}
extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

//public extension UIViewController {
//    func setStatusBar(color: UIColor) {
//        let tag = 12321
//        if let taggedView = self.view.viewWithTag(tag){
//            taggedView.removeFromSuperview()
//        }
//        let overView = UIView()
//        overView.frame = UIApplication.shared.statusBarFrame
//        overView.backgroundColor = color
//        overView.tag = tag
//        self.view.addSubview(overView)
//    }
//}


