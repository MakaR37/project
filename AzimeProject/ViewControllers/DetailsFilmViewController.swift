//
//  DetailsFilm.swift
//  AzimeProject
//
//  Created by Артем Мак on 23.12.2021.
//  Copyright © 2021 Артем Мак. All rights reserved.
//

import UIKit

class DetailsFilmViewController: UIViewController {
    
    public var id: Int?
    private lazy var sloganTextView: UITextView = {
        let sloganTextView = UITextView()
        sloganTextView.textColor = .white
        sloganTextView.backgroundColor = .black
        sloganTextView.font = UIFont.systemFont(ofSize: 18)
        sloganTextView.translatesAutoresizingMaskIntoConstraints = false
        sloganTextView.isEditable = false
        return sloganTextView
    }()
    
    private lazy var overviewTextView: UITextView = {
        let overviewTextView = UITextView()
        overviewTextView.textColor = .lightGray
        overviewTextView.backgroundColor = .black
        overviewTextView.font = UIFont.systemFont(ofSize: 18)
        overviewTextView.isScrollEnabled = false
        overviewTextView.translatesAutoresizingMaskIntoConstraints = false
        overviewTextView.isEditable = false
        return overviewTextView
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.textColor = .lightGray
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        return durationLabel
    }()
    
    private lazy var webSiteLabel: UILabel = {
        let webSiteLabel = UILabel()
        webSiteLabel.textColor = .lightGray
        webSiteLabel.font = UIFont.systemFont(ofSize: 18)
        webSiteLabel.translatesAutoresizingMaskIntoConstraints = false
        return webSiteLabel
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicatorView.color = .red
        activityIndicatorView.frame = CGRect(x: view.center.x, y: 250, width: .zero, height: .zero)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInfoRequset()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationItem.title = "Описание"
        view.addSubview(activityIndicatorView)
        view.addSubview(overviewTextView)
        view.addSubview(sloganTextView)
        view.addSubview(durationLabel)
        view.addSubview(webSiteLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sloganTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            sloganTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            sloganTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            sloganTextView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        NSLayoutConstraint.activate([
            overviewTextView.leftAnchor.constraint(equalTo: sloganTextView.leftAnchor),
            overviewTextView.topAnchor.constraint(equalTo: sloganTextView.bottomAnchor, constant: 8),
            overviewTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            ])
        
        NSLayoutConstraint.activate([
            durationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            durationLabel.topAnchor.constraint(equalTo: overviewTextView.bottomAnchor, constant: 8),
            durationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15)
            ])
        
        NSLayoutConstraint.activate([
            webSiteLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            webSiteLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            webSiteLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15)
            ])
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    private func errorRepeatRequsetActionAlertController(title: String, message: String) {
        let errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let errorRepeatRequsetActionAlertController = UIAlertAction(title: "Повторить запрос", style: .default) { (request) in
            self.detailInfoRequset()
        }
        let errorCloseAlertActrionAlertController = UIAlertAction(title: "Выйти", style: .cancel, handler: nil)
        errorAlertController.addAction(errorRepeatRequsetActionAlertController)
        errorAlertController.addAction(errorCloseAlertActrionAlertController)
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
    private func detailInfoRequset() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
        guard let idFilm = self.id else {
            DispatchQueue.main.async {
                self.errorRepeatRequsetActionAlertController(title: "Ошибка", message: "")
                self.activityIndicatorView.stopAnimating()
            }
            return
        }
        let detailApiUrl = "https://api.themoviedb.org/3/movie/\(idFilm)?api_key=cd3f70865389730959814331bb70ebeb"
        guard let url = URL(string: detailApiUrl ) else {
            DispatchQueue.main.async {
                self.errorRepeatRequsetActionAlertController(title: "Ошибка адреса запроса", message: "")
                self.activityIndicatorView.stopAnimating()
            }
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorRepeatRequsetActionAlertController(title: "Ошибка данных", message: "")
                        self.activityIndicatorView.stopAnimating()
                    }
                    return
                }
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorRepeatRequsetActionAlertController(title: "Произошла ошибка \(error)", message: "")
                        self.activityIndicatorView.stopAnimating()
                    }
                }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    let getData = try JSONDecoder().decode(DetailInfoFilm.self, from: data)
                    DispatchQueue.main.async {
                        self.overviewTextView.text = getData.overview
                        if let runtime = getData.runtime {
                            self.durationLabel.text = "Film duration: \(runtime) min"
                        } else {
                            self.durationLabel.text = ""
                        }
                        self.sloganTextView.text = getData.tagline
                        
                        self.webSiteLabel.text = getData.homepage
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorRepeatRequsetActionAlertController(title: "Произошла ошибка \(error)", message: "")
                        self.activityIndicatorView.stopAnimating()
                    }
                }
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
                }.resume()
        }
    }
}
