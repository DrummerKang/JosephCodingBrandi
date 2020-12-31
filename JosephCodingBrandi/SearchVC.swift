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
    
    // 검색할 페이지 카운트
    var searchPageCnt: Int = 0
    
    // 검색된 이미지 총 카운트
    var searchTotCnt: Int = 0
    
    var imgList: NSMutableArray!
    
    // API Reload 체크
    var searchReloadCheck: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listInit()
        
        // collectionView Layout Set
        setupFlowLayout()
    }
    
    // 초기화
    func listInit() {
        imgList = NSMutableArray()
        searchPageCnt = 1
    }
    
    // MARK: - API
    @objc func searchKeyword(){
        print("searchKeyword : ", self.searchBar.text!)
        
        let escapedKeyword = self.searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let searchURL = ApiManager.URL.SEARCH + escapedKeyword + "&size=30&page=" + String(searchPageCnt)
        
        self.showProgress()
        
        self.apiControl.apiRequest(url: searchURL) { [self] response in
            switch response.result {
            case .success(let value):
                let documents = JSON(value)
//                print(documents)
                let documentsArr = JSON(documents["documents"]).arrayValue as NSArray
                imgList.addObjects(from: documentsArr as! [Any])
                
                if(imgList.count == 0){
                    listInit()
                    imgCollectionView.reloadData()
                    
                    self.showAlert(message: "검색 결과가 없습니다.")
                    
                }else{
                    searchTotCnt = JSON(documents["meta"]["total_count"]).intValue
                    print("totCnt : ", searchTotCnt)
                    
                    imgCollectionView.reloadData()
                    // reload 완료 체크
                    imgCollectionView.performBatchUpdates(nil, completion: { (result) in
                        print("reload_result")
                        self.hideProgress()
                        searchReloadCheck = 0
                    })
                }
                
            case .failure(let error):
                print("error : \(error)")
                
                searchReloadCheck = 0
                self.hideProgress()
            }
        }
    }
    
    // MARK: - SearchBar Delegate
    
    // 실시간 검색어
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("didChangeText : ", searchText)
        
        if(searchReloadCheck == 0){
            searchReloadCheck = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                listInit()
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
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if(searchReloadCheck == 0){
                // 이미지 카운트와 총 카운트 비교
                if(imgList.count >= 90){
                    return
                }
                searchReloadCheck = 1
                searchPageCnt += 1
                searchKeyword()
            }
        }
    }
}

