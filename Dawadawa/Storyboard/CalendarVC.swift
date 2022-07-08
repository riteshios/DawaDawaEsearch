import UIKit

class CalendarVC: UIViewController {
    @IBOutlet weak var labelYear: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var viewDate = UIDatePicker()
    var date:String?
    
    var callBack:((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.locale = .current
        datePicker.date = Date()
       // datePicker.minimumDate = datePicker.date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        
        let dateFormatter = DateFormatter()
       
        dateFormatter.dateFormat = "dd/MM/yyyy"

        self.date = dateFormatter.string(from: datePicker.date)
        print(date ?? "")
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "MMM"
       let month = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd"
        let dayInt = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "ccc"
       let day = dateFormatter.string(from: datePicker.date)
        self.labelYear.text = "\(year)"
        self.labelDate.text = "\(day), " + "\(dayInt) " + "\(month)"
        
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
    }
   
    
    @objc
    func dateSelected(){
        let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "dd/MM/yyyy"

        self.date = dateFormatter.string(from: datePicker.date)
        print(date ?? "")
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "MMM"
       let month = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd"
        let dayInt = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "ccc"
       let day = dateFormatter.string(from: datePicker.date)
        self.labelYear.text = "\(year)"
        self.labelDate.text = "\(day), " + "\(dayInt) " + "\(month)"

    }
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonDone(_ sender: UIButton) {
        if self.date == "" {
           
            
            self.showSimpleAlert(message: "Please select date")
           
        }
        
        
        else{
            self.callBack?(self.date ?? "")
        }
       
    }
}

