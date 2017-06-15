//
//  ViewController.swift
//  jsonTest2
//
//  Created by Takuya on 2017/06/02.
//  Copyright © 2017年 Takuya. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var compplantslist = [(id: "", name: "", url: "", srchtext: "", sortkey: "")]
    
    var compplantslist_tmp2 = [(id: "dummy", sortkey:"dummy", name: "dummy", url: "dummy", stat_image: "dummy", desc: "dummy")]
    
    var locationManager: CLLocationManager!
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //read json file and create json object
        do{
            let file = Bundle.main.path(forResource: "compPlantTBL", ofType: "json")
            let data = try Data(contentsOf: URL(fileURLWithPath: file!))
            print(data)
            
            let jsonCompPlantTBL = JSON(data)
            print(jsonCompPlantTBL)
            
            //
            //json data to arrary(compplantslist)
            //
            print("--------------------jsonCompPlantTBL--------------------")
            compplantslist.removeAll()
            for i in 0..<jsonCompPlantTBL["vegetables"].count {
                print(jsonCompPlantTBL["vegetables"][i]["id"].string!)
                print(jsonCompPlantTBL["vegetables"][i]["name"].string!)
                print(jsonCompPlantTBL["vegetables"][i]["sortkey"].string!)
                print(jsonCompPlantTBL["vegetables"][i]["srchtext"].string!)
                print("¥n")
            }

            print("--------------------test 001 --------------------")
            let vegid = "001"
            for i in 0..<jsonCompPlantTBL[vegid].count {
                print(jsonCompPlantTBL[vegid][i]["compid"].string!)
                print(jsonCompPlantTBL[vegid][i]["benefit_id"].string!)
                //print("")
            }
            
            print("--------------------test 001 2--------------------")
            //benefit desc
            print(jsonCompPlantTBL["benefit"])
            let benefit_id = "A"
            print("--------------------test 001 3--------------------")
            let benifit_arr = jsonCompPlantTBL["benefit"].arrayValue
            let filteredData = benifit_arr.filter(){
                let item = $0
                if (item["benefit_id"].stringValue == benefit_id ){
                    print(item["benefit_id"].stringValue)
                    print(item["desc"].stringValue)
                    return true
                }
                return false
            }
            print(filteredData)

            //print(jsonData)
        }catch let error_msg{
            print (error_msg)
        }

        //
        
        
        /*
        let jsonfile = "/Users/takuya/Desktop/xcode_test/sample.json"

        do{
            let fileContent = try String(contentsOfFile: jsonfile)
            //print(fileContent)
            
            let dataFromString = fileContent.data(using: .utf8, allowLossyConversion: false)
            
            //swiftJSON
            let jsonObj = JSON(data: dataFromString!)
            
            //print(jsonObj)
            
            print(jsonObj["vegetables"][0]["name"].string)
            print(jsonObj["vegetables"][1]["name"].string)
            print(jsonObj["vegetables"][2]["name"].string)
            print(jsonObj["vegetables"][3]["name"].string)
            print(jsonObj["vegetables"][4]["name"].string)
            
            print(jsonObj["vegetables"])
            print(jsonObj["companions"])
            

            
        }catch let error{
            print("Exception occurs...")
            print(error)
        }
         */
        
        //geo location
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.distanceFilter = 500; //更新間隔 500mごとに更新（locationManagerが呼ばれる）
            locationManager.startUpdatingLocation()
        }
        
        
        
        //weather info

            //let OpenWeatherMapUrl = "http://api.openweathermap.org/data/2.5/weather?q=xxxx&appid=xxxx"
            let OpenWeatherMapUrl = "http://samples.openweathermap.org/data/2.5/weather?id=2172797&appid=b1b15e88fa797225412429c1c50c122a1"
            let url = URL(string: OpenWeatherMapUrl)!
        
            let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            //let task = URLSession.shared.dataTask(with: url)
                if let data = data {
                    let json = JSON(data: data)
                    print(json)
                }
            })

            task.resume()
    }

    // 位置情報が更新されるたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        print(newLocation)
        //self.latTextField.text = "".appendingFormat("%.4f", newLocation.coordinate.latitude)
        //self.lngTextField.text = "".appendingFormat("%.4f", newLocation.coordinate.longitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

