//
//  ViewController.swift
//  WeatherApp
//
//  Created by 이찬호 on 6/22/24.
//

import UIKit
import CoreLocation
import SnapKit

class MainViewController: UIViewController {

    private let locationManager = CLLocationManager()
    
    private let cityLabel = {
        let lb = UILabel()
        lb.textColor = .white
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurelocationManager()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemOrange
    }
    
    private func configureHierarchy() {
        view.addSubview(cityLabel)
    }
    
    private func configureLayout() {
        cityLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    
    }

}

extension MainViewController: CLLocationManagerDelegate {
    
    private func configurelocationManager() {
        locationManager.delegate = self
    }
    
    private func checkDeiveLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkCurrentLocationAuthorization()
            }
            else {
                print("위치 서비스 꺼져있음")
            }
        }
        
    }
    
    private func checkCurrentLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("거부")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lat = manager.location?.coordinate.latitude,
              let lon = manager.location?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()
        cityLabel.text = "lat: \(lat), lon: \(lon)"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print(#function)
        checkDeiveLocationAuthorization()
    }
    
}

