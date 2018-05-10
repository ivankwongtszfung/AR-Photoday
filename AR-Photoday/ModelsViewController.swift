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

class ModelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var modelCollectionView: UICollectionView!
    
    // Load a model from assets
    func loadModel(name: String) -> SCNNode {
        let scene = SCNScene(named: name, inDirectory: "art.scnassets", options: nil)!
        return scene.rootNode
    }
    
    let models = ["BAwith2M.scn"]
    let model_icons = ["arch1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelCollectionView.delegate = self
        self.modelCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ModelCollectionViewCell
        
        cell.imageView.image = UIImage(named: model_icons[indexPath.row])
        
        return cell
    }
}

class ModelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
}
