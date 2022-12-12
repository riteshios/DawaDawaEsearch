//  CountryStatePopUpVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 08/12/22.

import UIKit

class CountryStatePopUpVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var viewBG:UIView!
    
    var callback:((String)->())?
    var lbldata:String = "Country name"
    
    var data:[String] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    var searchData = [String]()
    var txtdata = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = String.getString(lbldata)
        self.textField.delegate = self
        self.searchData = data
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if viewBG == touch.view{
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func searchCountry(_ sender: UITextField){
        searchData.removeAll()
        if sender.text?.count == 0{
            self.searchData = self.data
        }
        else{
            txtdata = sender.text!
            for dicData in self.data {
                
                let isMachingWorker : NSString = (dicData) as NSString
                let range = isMachingWorker.lowercased.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                
                if range != nil {
                    searchData.append(dicData)
                }
            }
        }
        self.tableview.reloadData()
    }
 

}

extension CountryStatePopUpVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "CountryStateTVCell") as! CountryStateTVCell
        cell.labelName.text = self.searchData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.callback?(String.getString(self.searchData[indexPath.row]))
    }
}



class CountryStateTVCell: UITableViewCell{
    @IBOutlet weak var labelName:UILabel!
}
