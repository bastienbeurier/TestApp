//
//  CollectionVC.swift
//  TestApp
//
//  Created by Bastien Beurier on 3/12/19.
//  Copyright © 2019 Bastien Beurier. All rights reserved.
//

import UIKit

class CollectionVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension CollectionVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "collection-cell", for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
}
