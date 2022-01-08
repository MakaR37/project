//
//  TableViewCell.swift
//  AzimeProject
//
//  Created by Артем Мак on 10.12.2021.
//  Copyright © 2021 Артем Мак. All rights reserved.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    static var identifire = "cell"
    
    private lazy var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        return posterImageView
    }()
    
    private lazy var imageViewButton: UIButton = {
        let imageButton = UIButton()
        imageButton.layer.cornerRadius = 4
        imageButton.layer.borderColor = UIColor.red.cgColor
        imageButton.setImage(UIImage(named: "play"), for: .normal)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.backgroundColor = .darkGray
        imageButton.alpha = 0.5
        return imageButton
    }()
    
    private lazy var originalTitleLabel: UILabel = {
        let originalTitleLabel = UILabel()
        originalTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        originalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        originalTitleLabel.textColor = .white
        return originalTitleLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private lazy var voteAverageLabel: UILabel = {
        let voteAverageLabel = UILabel()
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        voteAverageLabel.font = UIFont.boldSystemFont(ofSize: 21)
        return voteAverageLabel
    }()
    
    private lazy var voteCountLabel: UILabel = {
        let voteCountLabel = UILabel()
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.font = UIFont.systemFont(ofSize: 15)
        voteCountLabel.textColor = UIColor(red: (148/255.0), green: (148/255.0), blue: (148/255.0), alpha: 1)
        return voteCountLabel
    }()
    
    private lazy var releaseDate: UILabel = {
        let releaseDate = UILabel()
        releaseDate.translatesAutoresizingMaskIntoConstraints = false
        releaseDate.textColor = .white
        return releaseDate
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(originalTitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageViewButton)
        contentView.addSubview(voteAverageLabel)
        contentView.addSubview(voteCountLabel)
        contentView.addSubview(releaseDate)
    }
    
    public  func configure(with film: Film) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: (138/255.0), green: (168/255.0), blue: (3/255.0), alpha: 1)
        selectedBackgroundView = backgroundView
        originalTitleLabel.text = film.original_title
        releaseDate.text = film.release_date
        titleLabel.text = film.title
        voteAverageLabel.text = String(describing: film.vote_average ?? 0)
        voteCountLabel.text = String(describing: film.vote_count ?? 0)
        releaseDate.text = film.release_date
        let voteAverage = film.vote_average ?? 0
        switch voteAverage {
        case 7.0...10.0:
            voteAverageLabel.textColor = UIColor(red: (86/255.0), green: (148/255.0), blue: (46/255.0), alpha: 1)
        default:
            voteAverageLabel.textColor =  UIColor(red: (148/255.0), green: (148/255.0), blue: (148/255.0), alpha: 1)
        }
        backgroundColor = .black
        imageEterhetRequset(with: film)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate ([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            imageViewButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            imageViewButton.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            imageViewButton.widthAnchor.constraint(equalToConstant: 30),
            imageViewButton.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            originalTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            originalTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            originalTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            originalTitleLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -110),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            voteAverageLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 25),
            voteAverageLabel.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -15),
            voteAverageLabel.heightAnchor.constraint(equalToConstant: 30),
            voteAverageLabel.widthAnchor.constraint(equalToConstant: 35)
            ])
        
        NSLayoutConstraint.activate([
            voteCountLabel.leadingAnchor.constraint(equalTo: voteAverageLabel.trailingAnchor, constant: 0),
            voteCountLabel.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -15),
            voteCountLabel.heightAnchor.constraint(equalToConstant: 25),
            voteCountLabel.widthAnchor.constraint(equalToConstant: 60)
            ])
        
        NSLayoutConstraint.activate([
            releaseDate.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            releaseDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            releaseDate.widthAnchor.constraint(equalToConstant: 70)
            ])
    }
    
    private func imageEterhetRequset(with film: Film) {
        guard let posterPath = film.poster_path, let imageUrl = URL(string:"https://image.tmdb.org/t/p/w500\(posterPath)") else {
            posterImageView.image = UIImage(named: "placeholder")
            return
        }
        DispatchQueue.global(qos: .utility).async {
            guard let pictureData = NSData(contentsOf: imageUrl as URL),
                let picture = UIImage(data: pictureData as Data) else {
                    self.posterImageView.image = UIImage(named: "placeholder")
                    return
            }
            DispatchQueue.main.async {
                self.posterImageView.image = picture
            }
        }
    }}

