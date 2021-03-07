//
//  ViewController.swift
//  JSON&Photos
//
//  Created by Ольга Кучменева on 06.03.2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class PhotosViewController: UIViewController {

    var photos: [PhotoItem] = []
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotoCollectionViewCell.self))
       
        
        collectionView.toAutoLayout()
        collectionView.backgroundColor = UIColor(named: "white")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        AF.request("https://jsonplaceholder.typicode.com/photos").response {
            response in

            guard let data = response.data else {return}
            let json = try! JSON(data: data)
            
            if let items = json.array
            {
                for item in items
                    {
                        if let url  = item["url"].string,
                            let thumbnailUrl = item["thumbnailUrl"].string,
                            let title = item["title"].string,
                            let albumId = item["albumId"].object as? Int,
                            let id = item["id"].object as? Int
                        {
                            self.photos.append(PhotoItem(url: url, thumbnailUrl: thumbnailUrl, title: title, albumId: albumId, id: id))
                            if self.photos.count > 4 {
                                self.collectionView.reloadData()
                            }
                        }
                    }
            }
        }
        setupLayout()
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16*2)
        return CGSize(width: width, height: width)
        
    }
}

extension PhotosViewController {
    private func setupLayout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self),for: indexPath) as! PhotoCollectionViewCell
        
        cell.configure(item: photos[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return photos.count
    }
   
}

