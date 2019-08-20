//
//  TeamMenuVC.swift
//  DatXanhManagement
//
//  Created by ivc on 8/19/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class TeamMenuVC: UIViewController {

    @IBOutlet weak var cvMenu: UICollectionView!
    var arrMenu: [String] = ["Danh sách thành viên", "Thứ tự phân chia khách", "Phân chia khách" ,"Thống kê"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvMenu.delegate = self
        cvMenu.dataSource = self
    }

}

extension TeamMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamMenuCell", for: indexPath) as! TeamMenuCVC
        cell.lblTitle.text = arrMenu[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingHeight = CGFloat(10 * (arrMenu.count - 1))
        return CGSize(width: self.cvMenu.frame.size.width, height: (self.cvMenu.frame.height - spacingHeight) / CGFloat(arrMenu.count))
    }
    
    
}
