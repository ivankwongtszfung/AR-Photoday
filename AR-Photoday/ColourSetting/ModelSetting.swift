//
//  ModelSettingViewController.swift
//  AR-Photoday
//
//  Created by Joker Lung on 7/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class ModelSetting: UIViewController,UITableViewDelegate,UITableViewDataSource,ColourPickerDelegate {
    
    
    @IBOutlet weak var optionTable: UITableView!
    
    let modelSpec = ["color1","color2"]
    var modelColour = ["#ff0000","00ff00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionTable.delegate = self
        optionTable.dataSource = self
        print(modelColour[0])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelSpec.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionTable.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.modelName.text = modelSpec[indexPath.row]
        cell.modelColour.backgroundColor = hexStringToUIColor(hex: modelColour[indexPath.row])
        
        // disable hightlight effect
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        performSegue(withIdentifier: "showColour", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let nav = segue.destination as? UINavigationController, let colour
        
        if let destination = segue.destination as? ColourPicker {
            destination.delegate = self
            destination.initColor = hexStringToUIColor(hex: modelColour[(optionTable.indexPathForSelectedRow?.row)!])
            destination.arrayIndex = (optionTable.indexPathForSelectedRow?.row)!
        }
    }

    // turn hex code to UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func changeColour(_ colour: String?, _ index: Int?){
        modelColour[index!] = colour!
        self.optionTable.reloadData()
    }

}
