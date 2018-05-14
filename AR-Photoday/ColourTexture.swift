//
//  ColourTexture.swift
//  AR-Photoday
//
//  Created by Joker Lung on 10/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

class ColourTexture: UIViewController,UITableViewDelegate,UITableViewDataSource,ModelSettingDelegate {

    func changeObjectColour(_ colour: [String]!) {
        //set the colour array
        if(colourArr != colour){
            colourArr=colour
            navigationController?.popViewController(animated: true)
        }

    }

    var colourArr = ["ff0000","00ff00"]
    var optionArr = ["Colour":["colour 1","colour 2"],"Texture":["texture 1","texture 2"]]
    var theColor = true
    weak var delegate: ModelSettingDelegate?
    
    @IBOutlet weak var table: UITableView!
    let arr = ["Colour","Texture"]
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = arr[indexPath.row]
        // This initialize all cell to be unselected
        // Should be initialize according to user's choice
        cell?.accessoryType = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            // When the cell is selected
            // Should present segue here
            
            guard let name = cell.textLabel?.text else{ return }
            openModelSettingController(option: name)
            
            
        }
    }
    
    func openModelSettingController(option : String) ->Void{
        if(colourArr.isEmpty || optionArr.isEmpty)
        {
            print("color array and name array should not be empty.")
            return
        }
        if let destination = self.storyboard?.instantiateViewController(withIdentifier: "ModelSetting") as? ModelSetting {
            destination.delegate = self
            destination.modelName=option
            destination.modelColour=colourArr
            destination.modelSpec=optionArr[option]!
            self.navigationController?.pushViewController(destination, animated: true)
        }
        else{
            print("storyboard dont contain modelsetting identifier")
        }
        return
        
    }
    

    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("we are coming back to view controller")
            //pass data by delegate
            delegate?.changeObjectColour(colourArr)
            
        }
    }

}
