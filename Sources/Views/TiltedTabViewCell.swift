//
//  TiltedTabViewCell.swift
//  TiltedTabView
//
//  Copyright © 2017 Ian McDowell. All rights reserved.
//

import UIKit

protocol TiltedTabViewCellDelegate: class {
    func tiltedTabViewCellCloseButtonTapped(_ cell: TiltedTabViewCell)
}

class TiltedTabViewCell: UICollectionViewCell {
    
    weak var delegate: TiltedTabViewCellDelegate?
    
    var title: String? {
        didSet {
            headerView.titleLabel.text = title
        }
    }
    var snapshot: UIImage? {
        didSet {
            snapshotContainer.image = snapshot
        }
    }
    
    private let headerView: TiltedTabViewCell.HeaderView
    private let snapshotContainer: UIImageView
    
    override init(frame: CGRect) {
        headerView = TiltedTabViewCell.HeaderView()
        snapshotContainer = UIImageView()
        super.init(frame: frame)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .white
        self.backgroundView?.layer.cornerRadius = 5
        self.backgroundView?.layer.masksToBounds = true
        
        let contentView = self.contentView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        snapshotContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        contentView.addSubview(snapshotContainer)
        
        headerView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            snapshotContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            snapshotContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            snapshotContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            snapshotContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override var isHighlighted: Bool {
        didSet {
            let transform = isHighlighted ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 500,
                initialSpringVelocity: 3,
                options: .allowUserInteraction,
                animations: {
                    self.contentView.transform = transform
                    self.backgroundView?.transform = transform
                },
                completion: nil
            )
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title = nil
        snapshot = nil
    }
    
    @objc private func closeTapped() {
        self.delegate?.tiltedTabViewCellCloseButtonTapped(self)
    }
    
    class HeaderView: UIView {
        let closeButton: UIButton
        let titleLabel: UILabel
        
        init() {
            closeButton = UIButton(type: .system)
            titleLabel = UILabel()
            super.init(frame: .zero)
            
            closeButton.setImage(HeaderView.closeImage, for: .normal)
            
            titleLabel.text = ""
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(closeButton)
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
                closeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                closeButton.topAnchor.constraint(equalTo: topAnchor),
                closeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private static var closeImage: UIImage = {
            return UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image(actions: { context in
                let downwards = UIBezierPath()
                downwards.move(to: CGPoint(x: 2, y: 2))
                downwards.addLine(to: CGPoint(x: 22, y: 22))
                UIColor.black.setStroke()
                downwards.lineWidth = 5
                downwards.stroke()
                
                let upwards = UIBezierPath()
                upwards.move(to: CGPoint(x: 2, y: 22))
                upwards.addLine(to: CGPoint(x: 22, y: 2))
                UIColor.black.setStroke()
                upwards.lineWidth = 5
                upwards.stroke()
                
                context.cgContext.addPath(downwards.cgPath)
                context.cgContext.addPath(upwards.cgPath)
            })
        }()
    }
}
