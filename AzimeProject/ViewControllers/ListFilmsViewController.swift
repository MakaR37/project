//
//  ViewController.swift
//  AzimeProject
//
//  Created by Артем Мак on 10.12.2021.
//  Copyright © 2021 Артем Мак. All rights reserved.
//

import UIKit

class ListFilmsViewController: UIViewController {
    
    private lazy var films: [Film] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifire)
        tableView.backgroundColor = UIColor(red: (13/255.0), green: (13/255.0), blue: (13/255.0), alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(red: (13/255.0), green: (13/255.0), blue: (13/255.0), alpha: 1.0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicatorView.color = .red
        activityIndicatorView.frame = CGRect(x: view.center.x, y: 350, width: .zero, height: .zero)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupNavigationController()
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicatorView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    private func errorRepeatRequsetActionAlertController(title: String, message: String) {
        let errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let errorRepeatRequsetActionAlertController = UIAlertAction(title: "Повторить запрос", style: .default) { (request) in
            self.dataRequest()
        }
        let errorCloseAlertActrionAlertController = UIAlertAction(title: "Выйти", style: .cancel, handler: nil)
        errorAlertController.addAction(errorRepeatRequsetActionAlertController)
        errorAlertController.addAction(errorCloseAlertActrionAlertController)
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func dataRequest() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
        let apiUrl = "https://api.themoviedb.org/3/movie/popular?api_key=cd3f70865389730959814331bb70ebeb"
        guard let url = URL(string: apiUrl) else {
            self.errorRepeatRequsetActionAlertController(title: "Ошибка адреса", message: "")
            self.activityIndicatorView.stopAnimating()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.errorRepeatRequsetActionAlertController(title: "Не удалось получить данные", message: "")
                        self.activityIndicatorView.stopAnimating()
                    }
                    return
                }
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorRepeatRequsetActionAlertController(title: "Вернулась ошибка -\(error)", message: "")
                        self.activityIndicatorView.stopAnimating()
                    }
                }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    let getData = try JSONDecoder().decode(ModelFilm.self, from: data)
                    DispatchQueue.main.async {
                        self.films = getData.results
                        self.tableView.reloadData()
                    }
                }catch {
                    DispatchQueue.main.async{
                        self.errorRepeatRequsetActionAlertController(title: "Ошибка загрузки", message: "")
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

extension ListFilmsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifire, for: indexPath) as?
            FilmTableViewCell {
            cell.configure(with: films[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = films[indexPath.row]
        let detailVc = DetailsFilmViewController()
        guard let id = films[indexPath.row].id else {
            return
        }
        detailVc.id = id
        navigationController?.pushViewController(detailVc, animated: true)
    }
}


