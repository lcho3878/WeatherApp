//
//  ViewController.swift
//  WeatherApp
//
//  Created by 이찬호 on 6/22/24.
//

import UIKit
import CoreLocation
import SnapKit
import Kingfisher

class MainViewController: UIViewController {

    //MARK: Properties
    private let locationManager = CLLocationManager()
    
    private let labelEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    

    //MARK: View Properties
    private let mainView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.isHidden = true
        return view
    }()
    
    private let loadingIndicator = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.color = .white
        view.style = .large
        return view
    }()
    
    //MARK: MainView Properties
    private let timeLabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .white
        return timeLabel
    }()

    private let locationImageView = {
        let locationImageView = UIImageView()
        locationImageView.image = UIImage(systemName: "location.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return locationImageView
    }()
    
    private let locationLabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .white
        locationLabel.font = .boldSystemFont(ofSize: 20)
        return locationLabel
    }()
    
    private let shareButton = {
        let shareButton = UIButton()
        shareButton.setImage(UIImage(systemName: "goforward")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        return shareButton
    }()
    
    private let reloadButton = {
        let reloadButton = UIButton()
        reloadButton.setImage(UIImage(systemName: "arrow.clockwise")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        return reloadButton
    }()
    
    private lazy var tempLabel = {
        let tempLabel = UIPaddingLabel(edgeInsets: labelEdgeInsets)
        return tempLabel
    }()
    
    private lazy var humidityLabel = {
        let humidityLabel = UIPaddingLabel(edgeInsets: labelEdgeInsets)
        return humidityLabel
    }()
    
    private lazy var windLabel = {
        let windLabel = UIPaddingLabel(edgeInsets: labelEdgeInsets)
        return windLabel
    }()
    
    private let weatherImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .center
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var commentLabel = {
        let commentLabel = UIPaddingLabel(edgeInsets: labelEdgeInsets)
        commentLabel.text = "오늘도 행복한 하루 보내세요"
        return commentLabel
    }()
    
    //MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurelocationManager()
        configureHierarchy()
        configureLayout()
    }
    
    
    //MARK: View Functions
    private func configureUI() {
        view.backgroundColor = .systemOrange
    }
    
    private func configureHierarchy() {
        view.addSubview(mainView)
        view.addSubview(loadingIndicator)
        mainView.addSubview(timeLabel)
        mainView.addSubview(locationImageView)
        mainView.addSubview(locationLabel)
        mainView.addSubview(shareButton)
        mainView.addSubview(reloadButton)
        mainView.addSubview(tempLabel)
        mainView.addSubview(humidityLabel)
        mainView.addSubview(windLabel)
        mainView.addSubview(weatherImageView)
        mainView.addSubview(commentLabel)
    }
    
    private func configureLayout() {
        mainView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        locationImageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(16)
            $0.leading.equalTo(timeLabel)
            $0.centerY.equalTo(locationLabel)
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
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(locationImageView.snp.bottom).offset(16)
            $0.leading.equalTo(locationImageView)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(16)
            $0.leading.equalTo(tempLabel)
        }
        
        windLabel.snp.makeConstraints {
            $0.top.equalTo(humidityLabel.snp.bottom).offset(16)
            $0.leading.equalTo(humidityLabel)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(windLabel.snp.bottom).offset(16)
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(150)
            $0.leading.equalTo(windLabel)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImageView.snp.bottom).offset(16)
            $0.leading.equalTo(weatherImageView)
        }
    }
    
    private func configureData(_ result: WeatherResult) {
        timeLabel.text = Date().formatted()
        locationLabel.text = result.name
        tempLabel.text = result.tempDescription
        humidityLabel.text = result.humidityDescription
        windLabel.text = result.windDescription
        weatherImageView.kf.setImage(with: result.iconImageURL)
        loadingIndicator.stopAnimating()
        mainView.isHidden = false
    }
}

//MARK: CLLocationManagerDelegate
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

