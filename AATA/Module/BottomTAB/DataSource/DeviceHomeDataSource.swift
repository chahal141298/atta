//
//  DeviceHomeDataSource.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit



///
class DeviceHomeDataSource: NSObject {
    
    weak var delegate: DeviceDelegate?

    // MARK: - Variables
    ///
    fileprivate let interItemsPedding: CGFloat = 4.0
    ///
    var reuseIdentifier: String {
        return "DeviceHomeCell"
    }
    ///
    var nibName: String {
        return "DeviceHomeCell"
    }
    ///
    var cellWidth: CGFloat = UIScreen.main.bounds.width - 100
    ///
    var cellHeight: CGFloat = 130.0
    ///
    var collectionView: UICollectionView?
    ///
    var endDeviceList: [EndDevice] = []
    
    // MARK: - Initializing methods
    ///
    convenience init(_ collectionView: UICollectionView) {
        self.init()
        self.collectionView = collectionView
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        DispatchQueue.main.async {
            self.cellWidth = (UIScreen.main.bounds.width) - 100
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
}

///
extension DeviceHomeDataSource: UICollectionViewDataSource {
    ///
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return endDeviceList.count
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DeviceHomeCell {
            cell.backgroundColor = .clear
            cell.deviceIdLabel.text = endDeviceList[indexPath.row].deviceId
            cell.addressLabel.text = "154 AD Street N/A, New York city, USA"
            cell.delegate = delegate
            //cell.delegate = self
                // endDeviceList[indexPath.row].propertyInfo?.locationName ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

///
extension DeviceHomeDataSource: UICollectionViewDelegate {
    ///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelect(id: endDeviceList[indexPath.row].id, deviceId: endDeviceList[indexPath.row].deviceId)
    }
}

///
extension DeviceHomeDataSource: UICollectionViewDelegateFlowLayout {
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemsPedding
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemsPedding
    }
}

