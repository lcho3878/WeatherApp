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
    
    private let timeLabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .white
        return timeLabel
    }()

    private let locationImageView = {
        let locationImageView = UIImageView()
        locationImageView.image = UIImage(systemName: "location.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        locationImageView.isHidden = true
        return locationImageView
    }()
    
    private let locationLabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .white
        return locationLabel
    }()
    
    private let shareButton = {
        let shareButton = UIButton()
        shareButton.setImage(UIImage(systemName: "goforward")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        shareButton.isHidden = true
        return shareButton
    }()
    
    private let reloadButton = {
        let reloadButton = UIButton()
        reloadButton.setImage(UIImage(systemName: "arrow.clockwise")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        reloadButton.isHidden = true
        return reloadButton
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
        view.addSubview(timeLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(shareButton)
        view.addSubview(reloadButton)
    }
    
    private func configureLayout() {
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        locationImageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(16)
            $0.leading.equalTo(timeLabel)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(locationImageView)
            $0.leading.equalTo(locationImageView.snp.trailing).offset(8)
        }
        
        reloadButton.snp.makeConstraints {
            $0.centerY.equalTo(locationImageView)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.size.equalTo(40)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalTo(reloadButton)
            $0.trailing.equalTo(reloadButton.snp.leading).inset(-8)
            $0.size.equalTo(reloadButton)
        }
    }
    
    private func configureData(_ result: WeatherResult) {
        timeLabel.text = Date().formatted()
        locationLabel.text = result.name
        
        locationImageView.isHidden = false
        shareButton.isHidden = false
        reloadButton.isHidden = false
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
        WeatherService.shared.callRequest(lat: String(lat), lon: String(lon)) { result in
            self.configureData(result)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print(#function)
        checkDeiveLocationAuthorization()
    }
    
}

