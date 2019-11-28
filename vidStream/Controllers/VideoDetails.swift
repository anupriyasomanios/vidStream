//
//  VideoDetails.swift
//  vidStream
//
//  Created by Anupriya Soman on 26/11/2019.
//  Copyright © 2019 Anupriya Soman. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class VideoDetails: UIViewController, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoUrlLabel: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var videoListingTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fullLisView: UIView!
    
    let overlay = PlayerOverlay.getScreen()
    let playerController = AVPlayerViewController()
    private let dataController = DataController()
    var avPlayer = AVPlayer()
    var videoTitle: String = ""
    var videoDescription: String = ""
    var thumbImage: String = ""
    var videoUrl: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()   
    }
    
    private func initialize(){
        dataController.delegate = self
        dataController.requestData(fileName: "Videos.json")
    }
    
    fileprivate var listOfVideos = [Videos](){
        didSet{
            self.videoListingTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.titleLabel.text = videoTitle
        let videoSourse  = URL(string: thumbImage)
        self.thumbImageView.downloadImage(from: videoSourse!)
        self.videoUrlLabel.text = videoUrl
        self.videoDescriptionLabel.text = videoDescription
        self.fullLisView.isHidden = true
    }
    
    @IBAction func videoPlayClickAction(_ sender: UIButton) {
        self.setupOverlayButton()
        playButton.isHidden = true
        playImageView.isHidden = true
        overlayView.isHidden = true
        thumbImageView.isHidden = true
        let videoURL = URL(string: videoUrl)
        avPlayer = AVPlayer(url: videoURL!)
        avPlayer.allowsExternalPlayback = true
        playerController.player = avPlayer
        playerController.delegate = self
        videoContainerView.addSubview(playerController.view)
        playerController.view.frame = CGRect(x: 0, y: 0, width: videoContainerView.frame.width, height: videoContainerView.frame.height)
        avPlayer.play()
    }
    
    func setupOverlayButton() {
        let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2.0
        let topDistance = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)! +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        overlay.listButton.center = CGPoint(x: horizontalCenter, y: topDistance)
        overlay.listButton.addTarget(self, action: #selector(overlayVideoListAction), for: .touchUpInside)
    }
      
    func playerViewController(_: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
         overlay.listButton.isHidden = false
        window!.addSubview(overlay.listButton)
        
    }
    
    func playerViewController(_: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator) {
        overlay.listButton.isHidden = true
    }
    
      
    @objc func overlayVideoListAction(sender: UIButton!) {
          let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
              self.fullLisView.isHidden = false
              window!.addSubview(self.fullLisView)
    }
    
     @IBAction func closeListAction(sender: UIButton!) {
        self.fullLisView.isHidden = true
     }
    
     @IBAction func backClickAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
     }
}

extension VideoDetails: UITableViewDataSource, UITableViewDelegate {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listOfVideos.count
   }


func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let videoCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath)as! VideoListCell
    let video = listOfVideos[indexPath.row]
    videoCell.videoNameLabel.text = video.title
    let videoUrl  = URL(string: video.thumb!)
    videoCell.selectionStyle = .none
    videoCell.thumbImageView.downloadImage(from: videoUrl!)
    return videoCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = listOfVideos[indexPath.row]
        let videoURL = URL(string: video.sources!)
        avPlayer = AVPlayer(url: videoURL!)
        playerController.player = avPlayer
        playerController.delegate = self
        avPlayer.play()
        self.fullLisView.isHidden = true
    }
}

extension VideoDetails: DataControllerDelegate{
    func didVideoLoaded(videos: [Videos]) {
        self.listOfVideos = videos
    }
}
