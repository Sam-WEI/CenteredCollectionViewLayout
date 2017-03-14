//
//  ViewController.swift
//  CenteredCollectionViewLayout
//
//  Created by WeiShengkun on 3/13/17.
//  Copyright © 2017 WeiShengkun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var number: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        let layout = CenteredCollectionViewLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }

    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        number = Int(sender.value)
        collectionView.reloadData()
    }
}



extension ViewController: CenteredCollectionViewLayoutDelegate {
    func minimumCellWidth() -> CGFloat {
        return 30
    }
    
    func maximumCellWidth() -> CGFloat {
        return 60
    }
    
    func cellSpacing() -> CGFloat {
        return 5
    }
}
