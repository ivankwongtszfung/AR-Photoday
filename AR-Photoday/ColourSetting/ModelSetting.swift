//
//  ModelSettingViewController.swift
//  AR-Photoday
//
//  Created by Joker Lung on 7/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

protocol ModelSettingDelegate: class{
    func changeObjectColour(_ colour: [String]!,_ model: String)
}


class ModelSetting: UIViewController,UITableViewDelegate,UITableViewDataSource,ColourPickerDelegate,TexturePickerDelegate {
    
    
    @IBOutlet weak var optionTable: UITableView!
    

    var modelName = String()
    var modelSpec = [String]()
    var modelColour = [String]()
    
    var modelViewController = ["Texture":"showTexture","Colour":"showColour"]
    weak var delegate: ModelSettingDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionTable.delegate = self
        optionTable.dataSource = self
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelSpec.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionTable.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.modelName.text = modelSpec[indexPath.row]
        switch modelName {
        case "Texture":
            //since the modelName will change by default so i dont perform any action
            // if we want to preview texture we can do it here
            break
        case "Colour":
            cell.modelColour.backgroundColor = hexStringToUIColor(hex: modelColour[indexPath.row])
            break
        default:
            let alertController = UIAlertController(title: "oops", message:
                "we can only choose texture and colour", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            break
        }
        
        // disable hightlight effect
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        //perform segue by modelName which is set in the option calss
        
        if let vc = modelViewController[modelName] {
            // now val is not nil and the Optional has been unwrapped, so use it
            performSegue(withIdentifier: vc, sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ColourPicker {
            destination.delegate = self
            destination.initColor = hexStringToUIColor(hex: modelColour[(optionTable.indexPathForSelectedRow?.row)!])
            destination.arrayIndex = (optionTable.indexPathForSelectedRow?.row)!
        }
        else if let destination = segue.destination as? TexturePicker{
            //perform segue to texture picker
            //set all the data to the colour texture class
            destination.delegate = self
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
    
    
    // Change the colour of the cell by changing the array
    func changeColour(_ colour: String?, _ index: Int?){
        modelColour[index!] = colour!
        self.optionTable.reloadData()
    }
    //get the name of the texture
    func getNameOfImage(imageName:String)->String{
        let index = imageName.count - 4
        let substring = imageName.prefix(index)
        return String(substring)
    }
    
    //change the texture of the cell by changing the array
    func changeTexture(_ texture: String?, _ index: Int?) {
        print("texture changing in modelsetting")
        modelColour[index!] = texture!
        modelSpec[index!] = getNameOfImage(imageName: texture!)
        self.optionTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            print("we are coming back to view controller")
            //pass data by delegate
            delegate?.changeObjectColour(modelColour,modelName)
            
        }
        
    }

    

    

}
