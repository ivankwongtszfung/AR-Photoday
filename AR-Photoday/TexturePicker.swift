//
//  TexturePicker.swift
//  AR-Photoday
//
//  Created by Vincent Au on 13/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol TexturePickerDelegate: class{
    func changeTexture(_ texture: String?,_ index: Int?)
}

class TexturePicker: UICollectionViewController {

    
    //this is a hardcode array of the UIImage
    
    let store = ["add.png","angry.png","love.png","tick.png","redball.jpg","texture.png"]
    var arrayIndex: Int!
    var textureCode: String!
    weak var delegate: TexturePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return store.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if(textureCode==store[indexPath.row]){
            navigationController?.popViewController(animated: true)
        }
        print("did selected begin:")
        if(indexPath.row < store.count){
            //this is a redundant check if it exist there will be a problem in the ios not for us
            print(store[indexPath.row])
            textureCode = store[indexPath.row]
        }
        print(":did selected end")
        

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! TextureCell
        
        // Configure the cell
        configureCell(cell: cell, forItemAtIndexPath: indexPath)
        
        return cell
    }
    
    func getNameOfImage(num:Int)->String{
        let index = store[num].count - 4
        
        let substring = store[num].prefix(index)
        
        return String(substring)
    }
    
    func configureCell(cell: TextureCell,forItemAtIndexPath: IndexPath){
        cell.backgroundColor = UIColor.lightGray
        cell.TextureView.image = UIImage.init(named: store[forItemAtIndexPath.row])
        cell.TextureLabel.text = getNameOfImage(num: forItemAtIndexPath.row)
        print(cell.debugDescription)
    }

    // MARK: UICollectionViewDelegate

    
    //Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func changeObjectColour(_ colour: [String]!) {
        let indexPath = (self.collectionView!.indexPathsForSelectedItems)!
        print(indexPath.debugDescription)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("changing the texture code")
        if(textureCode!=nil){
            delegate?.changeTexture(textureCode, arrayIndex)
            
        }
    }
 

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
