//
//  DataController.swift
//  iOS_MVCAndLocalData
//
//  Created by THE DUY NGUYEN on 29/5/19.
//  Copyright © 2019 THE DUY NGUYEN. All rights reserved.
//

import Foundation

class DataController{
    weak var delegate: DataControllerDelegate?
    
    
    func requestData(fileName: String){
        guard var copyFileToPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError("Missing copy path in project!!!")
        }
        copyFileToPath = copyFileToPath + fileName
        if loadFile(copyFileToPath: copyFileToPath) {
            let url = URL(fileURLWithPath: copyFileToPath)
            let jsonData = try! Data(contentsOf: url)
            let videoList = try!JSONDecoder().decode([Videos].self, from: jsonData)
            self.delegate?.didVideoLoaded(videos: videoList)
        } else {
            print("Could not load file")
        }
    }
    
    private func loadFile(copyFileToPath: String)->Bool{
        if FileManager.default.fileExists(atPath: copyFileToPath) {
            print("Videos.json already exists in local !!!")
            return true
        }
        
        guard let copyFileFromUrl = Bundle.main.url(forResource: "Videos", withExtension: "json") else {
            fatalError("Missing Videos.json in project!!!")
        }
        
        do{
            try FileManager.default.copyItem(atPath: copyFileFromUrl.path, toPath: copyFileToPath)
        }catch{
            print("Could not copy file")
            return false
        }
        return true
    }
}
