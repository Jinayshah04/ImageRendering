//
//  ViewController.swift
//  ImageRendering
//
//  Created by mobile1 on 10/12/24.
//

import UIKit

import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableVC: UITableView!
    // NSCache to store images in memory for quick access and reduce network calls
    var imageCache = NSCache<NSString, UIImage>()
    var catArr:[CatModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadApi()
    }
    
    func setupTable(){
        tableVC.delegate=self
        tableVC.dataSource=self
        
        tableVC.register(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier: "CatCell")
    }
    
    func loadApi(){
        ApiManager().fetchAF (completionHandler: { res in
            switch res{
            case .success(let data):
                self.catArr=data
                DispatchQueue.main.async{
                    self.tableVC.reloadData()
                }
            case .failure(let err):
                print("Error Fetching:-",err)
            }
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell
        let caturl = catArr[indexPath.row].url
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: caturl as NSString) {
            // If the image is cached, set it directly to the image view
            cell.imageView?.image = cachedImage
        } else {
            // If the image is not cached, download it from the URL
            AF.download(caturl).responseData { response in
                switch response.result {
                    case .success(let data):
                    // If image data is successfully downloaded
                        if let image = UIImage(data: data) {
                            // Set the downloaded image to the cell's image view
                            cell.imageView?.image = image
                            // Cache the image for future use
                            self.imageCache.setObject(image, forKey: caturl as NSString)
                        }
                     case .failure(let error):
                         print("Image not Rendering: \(error)")
                }
            }
        }
        return cell
    }
}

