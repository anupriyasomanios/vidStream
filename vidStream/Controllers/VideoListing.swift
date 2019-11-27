//
//  VideoListing.swift
//  vidStream
//
//  Created by Anupriya Soman on 26/11/2019.
//  Copyright © 2019 Anupriya Soman. All rights reserved.
//

import UIKit

class VideoListing: UIViewController {
    
    @IBOutlet weak var videoListingTableView: UITableView!
    private let dataController = DataController()
    
    
    fileprivate var listOfVideos = [Videos](){
        didSet{
            self.videoListingTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize(){
        dataController.delegate = self
        dataController.requestData(fileName: "Videos.json")
    }
}

extension VideoListing: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath)as! VideoListCell
        let video = listOfVideos[indexPath.row]
        videoCell.videoNameLabel.text = video.title
        videoCell.selectionStyle = .none
        let videoUrl  = URL(string: video.thumb!)
        videoCell.thumbImageView.downloadImage(from: videoUrl!)
        return videoCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "pushVideoDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = videoListingTableView.indexPathForSelectedRow{
            if segue.identifier == "pushVideoDetails" {
                let video = listOfVideos[indexPath.row]
                let details = segue.destination as! VideoDetails
                details.videoTitle = video.title!
                details.videoUrl = video.sources!
                details.videoDescription = video.description!
                details.thumbImage = video.thumb!
            }
        }
    }
}

extension VideoListing: DataControllerDelegate{
    func didVideoLoaded(videos: [Videos]) {
        self.listOfVideos = videos
    }
}

extension UIImageView {
   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
    
   func downloadImage(from url: URL) {
      getData(from: url) {
         data, response, error in
         guard let data = data, error == nil else {
            return
         }
         DispatchQueue.main.async() {
            self.image = UIImage(data: data)
         }
      }
   }
}
