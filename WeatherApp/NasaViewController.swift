//
//  NasaViewController.swift
//  WeatherApp
//
//  Created by 이찬호 on 7/2/24.
//

import UIKit
import SnapKit

final class NasaViewController: UIViewController {
    
    enum Nasa: String, CaseIterable {
        
        static let baseURL = "https://apod.nasa.gov/apod/image/"
        
        case one = "2308/sombrero_spitzer_3000.jpg"
        case two = "2212/NGC1365-CDK24-CDK17.jpg"
        case three = "2307/M64Hubble.jpg"
        case four = "2306/BeyondEarth_Unknown_3000.jpg"
        case five = "2307/NGC6559_Block_1311.jpg"
        case six = "2304/OlympusMons_MarsExpress_6000.jpg"
        case seven = "2305/pia23122c-16.jpg"
        case eight = "2308/SunMonster_Wenz_960.jpg"
        case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
         
        static var photo: URL {
            return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
        }
    }
    
    private var session: URLSession!
    
    private var total: Double = 0
    
    private var buffer: Data?
    
    private let nasaImageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleAspectFill
        return imgview
    }()
    
    private let activityIndicator = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .black
        return view
    }()
    
    private let progressLabel = {
        let lb = UILabel()
        lb.backgroundColor = .lightGray
        lb.textColor = .black
        return lb
    }()
    
    private lazy var requestButton = {
        let bt = UIButton()
        bt.setTitle("request", for: .normal)
        bt.backgroundColor = .systemPink
        bt.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureHierarchy() {
        view.addSubview(requestButton)
        view.addSubview(progressLabel)
        view.addSubview(nasaImageView)
        nasaImageView.addSubview(activityIndicator)
    }
    
    private func configureLayout() {
        requestButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        progressLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(requestButton.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        nasaImageView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(progressLabel.snp.bottom).offset(20)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension NasaViewController {
    @objc
    private func requestButtonClicked() {
        buffer = Data()
        callRequest()
    }
    
    private func callRequest() {
        requestButton.isEnabled = false
        activityIndicator.startAnimating()
        let request = URLRequest(url: Nasa.photo)
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.dataTask(with: request).resume()
    }
}

extension NasaViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode),
              let contentLength = response.value(forHTTPHeaderField: "Content-Length"),
              let totalLength = Double(contentLength) else { return .cancel}
        
        total = totalLength
        return .allow
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
        let percent = Double(buffer?.count ?? 0) / total  * 100
        progressLabel.text = "\(String(format: "%.2f", percent)) / 100.0"
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        requestButton.isEnabled = true
        activityIndicator.stopAnimating()
        guard error == nil else {
            progressLabel.text = "문제가 발생했습니다."
            nasaImageView.image = UIImage(systemName: "star")
            return
        }
        
        guard let buffer = buffer else {
            progressLabel.text = "Buffer nil"
            nasaImageView.image = UIImage(systemName: "star")
            return
        }
        let image = UIImage(data: buffer)
        nasaImageView.image = image
    }
    
}

