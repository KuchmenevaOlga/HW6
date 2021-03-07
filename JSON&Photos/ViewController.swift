//
//  ViewController.swift
//  JSON&Photos
//
//  Created by Ольга Кучменева on 06.03.2021.
//

import UIKit

class PhotosViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        
        collectionView.toAutoLayout()
        collectionView.backgroundColor = UIColor(named: "white")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16*2)
        if indexPath.row == 0 {
            return CGSize(width: width, height: 60)
        } else {
            return CGSize(width: width, height: 130)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cellProgress: ProgressCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self),for: indexPath) as! ProgressCollectionViewCell
            cellProgress.configure(progress: HabitsStore.shared.todayProgress)
            return cellProgress
        } else {
            let cell: HabitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self),for: indexPath) as! HabitCollectionViewCell
            let habit = HabitsStore.shared.habits[indexPath.row - 1]

            cell.configure(habit: habit, update: {collectionView.reloadData()})
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
        collectionView.deselectItem(at: indexPath, animated: true)
        let habit = HabitsStore.shared.habits[indexPath.row - 1]
        let habitDetailsViewController = HabitDetailsViewController(habit: habit)
        self.navigationController?.pushViewController(habitDetailsViewController, animated: true)
        }
    }
}

