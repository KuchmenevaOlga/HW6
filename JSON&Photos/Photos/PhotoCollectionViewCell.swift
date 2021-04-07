//
//  PhotoCollectionViewCell.swift
//  JSON&Photos
//
//  Created by Ольга Кучменева on 06.03.2021.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {

    var url: String?
    
    private let photoView: UIImageView = {
        let view = UIImageView()
        view.toAutoLayout()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font =  UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.toAutoLayout()
        return label
    }()

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.photoView.image = UIImage(data: data)
            }
        }
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white

        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    func configure(item: PhotoItem) {
        titleLabel.text = item.title
        self.url = item.url
        let urlAdress = URL(string: self.url ?? "")
        guard let url = urlAdress else {
            return
        }
        downloadImage(from: url)
    }
}

extension PhotoCollectionViewCell{
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().inset(4)
            make.width.equalToSuperview()
        }
        
        photoView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
            
        }
    }
}
