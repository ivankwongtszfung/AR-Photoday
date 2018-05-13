//
//  ModelsViewController.swift
//  AR-Photoday
//
//  Created by CCH on 10/5/2018.
//  Copyright © 2018年 Group7. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

private let reuseIdentifier = "Cell"

class ModelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var modelCollectionView: UICollectionView!
    
    static let segueIdentifier = "AddModel"
    let models = ["BAwith2M.scn"]
    let model_icons = ["arch1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelCollectionView.delegate = self
        self.modelCollectionView.dataSource = self
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set width according to fixed column number
        // Reference: https://stackoverflow.com/questions/40826242/
        let nColumns: CGFloat = 3, cellSpacing: CGFloat = 10
        let width = collectionView.bounds.size.width / nColumns - cellSpacing
        let height = width
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model_icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ModelCollectionViewCell
        
        cell.imageView.image = UIImage(named: model_icons[indexPath.row])
        
        return cell
    }
 
    // MARK: - Unwind segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sd = sender as? UICollectionViewCell {
            let vc = segue.destination as! ViewController
            let idx = self.modelCollectionView.indexPath(for: sd)![1]
            vc.chosenModel = models[idx]
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch(identifier) {
        case ModelsViewController.segueIdentifier:
            // Make sure the sender is a cell, and there is an item in selected index
            guard let sd = sender as? UICollectionViewCell else { return false }
            let idx = self.modelCollectionView.indexPath(for: sd)![1]
            // Make sure not out of index
            return idx < models.count
        default:
            return false
        }
    }
    
}

// MARK: - Model Cells
class ModelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
}
