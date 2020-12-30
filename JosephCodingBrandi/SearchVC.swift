//
//  SearchVC.swift
//  JosephCodingBrandi
//
//  Created by Joseph_iMac on 2020/12/30.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchImgCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var bgImage: UIImageView!
}

class SearchVC: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    // 검색할 이미지 카운트
    var searchImgCnt: Int = 0
    
    // 검색된 이미지 총 카운트
    var searchTotCnt: Int = 0
    
    var imgList: NSArray!
    
    // API 체크
    var searchCheck: Int = 0

    // Data Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgList = NSArray()
        searchImgCnt = 30
        
        // collectionView Layout Set
        setupFlowLayout()
        
        imgCollectionView.addSubview(self.refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print(searchImgCnt)
        print(searchTotCnt)
        searchImgCnt += 30
        searchKeyword()
        refreshControl.endRefreshing()
    }
    
    // MARK: - API
    @objc func searchKeyword(){
        print("searchKeyword : ", self.searchBar.text!)
//        imgList = NSArray()
        
        let escapedKeyword = self.searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let searchURL = ApiManager.URL.SEARCH + escapedKeyword + "&size=" + String(searchImgCnt)
        
        searchCheck = 0
        self.showProgress()
        
        self.apiControl.apiRequest(url: searchURL) { [self] response in
            switch response.result {
            case .success(let value):
                let documents = JSON(value)
                print(documents)
                imgList = JSON(documents["documents"]).arrayValue as NSArray
                
                if(imgList.count == 0){
                    imgCollectionView.reloadData()
                    searchImgCnt = 0
                    self.showAlert(message: "검색 결과가 없습니다.")
                }else{
                    searchTotCnt = JSON(documents["meta"]["total_count"]).intValue
                    print("totCnt : ", searchTotCnt)
                    imgCollectionView.reloadData()
                }
                
                self.hideProgress()
                
            case .failure(let error):
                print("error : \(error)")
                
                self.hideProgress()
            }
        }
    }
    
    // MARK: - SearchBar Delegate
    
    // 실시간 검색어
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("didChangeText : ", searchText)
        
        if(searchCheck == 0){
            searchCheck = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                searchKeyword()
            }
        }
    }

    // 검색시작
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 취소버튼 보이기
        self.searchBar.showsCancelButton = true
    }
    
    // 취소버튼 클릭시
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    // 키보드에서 검색버튼 클릭시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText : ", searchBar.text!)
        searchKeyword()
        
//        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgList.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchImgCollectionViewCell", for: indexPath) as! SearchImgCollectionViewCell
        
        let dic:NSDictionary = JSON(imgList[indexPath.row]).dictionary! as NSDictionary
//        print(dic)
        
        if let url = NSURL(string: JSON(dic["thumbnail_url"] as Any).stringValue) {
            if let data = NSData(contentsOf: url as URL) {
                if let image = UIImage(data: data as Data) {
                    DispatchQueue.main.async(execute: {
                        cell.bgImage.image = image
                    })
                }
            }
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic:NSDictionary = JSON(imgList[indexPath.row]).dictionary! as NSDictionary
        print(dic)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let searchDetailImgVC = storyboard.instantiateViewController(withIdentifier: "searchDetailImgVC") as! SearchDetailImgVC
        searchDetailImgVC.imgDic = JSON(imgList[indexPath.row]).dictionary! as NSDictionary
        self.navigationController?.pushViewController(searchDetailImgVC, animated: true)
    }

    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 3
        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfWidth * 0.9)
        self.imgCollectionView.collectionViewLayout = flowLayout
    }
}

