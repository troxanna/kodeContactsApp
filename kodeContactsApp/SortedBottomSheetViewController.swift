//
//  CustomModalViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 03.04.2023.
//

import UIKit

class SortedBottomSheetViewController: UIViewController {

    weak var delegate: SortedBottomSheetViewControllerDelegate?
    
    private let checkBoxControl: CheckBoxControl = {
        let view = CheckBoxControl()
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 2
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        label.text = "Сортировка"
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icons.arrowBack.rawValue), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    lazy private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    //по дизайну = 0.16
    let maxDimmedAlpha = 0.4
    
    lazy private var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: maxDimmedAlpha)
        return view
    }()
    
    let defaultHeight: CGFloat = 397
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 397
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configurationContent()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
}

//MARK: override viewDidLoad

//MARK: animate functions
private extension SortedBottomSheetViewController {
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.maximumContainerHeight
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: {
                self.delegate?.sortedTableView(by: self.checkBoxControl.getActiveSortedType())
            })
        }
    }
}

//MARK: setup functions
private extension SortedBottomSheetViewController {
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
        
        let gestureDimmedViewTap = UITapGestureRecognizer(target: self, action: #selector(didDimmedViewTap))
        dimmedView.addGestureRecognizer(gestureDimmedViewTap)
    }
    
    func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)

        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        dimmedView.snp.makeConstraints({ make in
            make.edges.equalTo(view.snp.edges)
        })
        containerView.snp.makeConstraints({ make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        })
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func configurationContent() {
        configurationTitleView()
        configurationCheckBoxControl()
        
        backButton.isHidden = true
        view.backgroundColor = .clear
    }
    
    func configurationTitleView() {
        containerView.addSubview(titleView)
        containerView.addSubview(line)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        titleView.addSubview(backButton)

        
        titleView.snp.makeConstraints({ make in
            make.height.equalTo(24)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.right.equalTo(containerView.snp.right).inset(16)
            make.top.equalTo(containerView.snp.top).offset(24)
        })
        
        backButton.snp.makeConstraints({ make in
            make.left.equalTo(titleView.snp.left)
            make.top.equalTo(titleView.snp.top)
            make.bottom.equalTo(titleView.snp.bottom)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.top)
            make.bottom.equalTo(titleView.snp.bottom)
        })
        
        line.snp.makeConstraints({ make in
            make.height.equalTo(4)
            make.width.equalTo(56)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(containerView.snp.top).offset(12)
        })
    }
    
    func configurationCheckBoxControl() {
        containerView.addSubview(checkBoxControl)
        checkBoxControl.translatesAutoresizingMaskIntoConstraints = false
        checkBoxControl.snp.makeConstraints({ make in
            make.top.equalTo(titleView.snp.top).inset(34)
            make.left.equalTo(containerView.snp.left).offset(24)
            make.right.equalTo(containerView.snp.right).offset(24)
        })
    }
}

//MARK: user actions
private extension SortedBottomSheetViewController {
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
            case .changed:
                if newHeight < maximumContainerHeight {
                    containerViewHeightConstraint?.constant = newHeight
                    view.layoutIfNeeded()
                }
            case .ended:
                if newHeight < dismissibleHeight {
                    self.animateDismissView()
                }
                else if newHeight < defaultHeight {
                    animateContainerHeight(defaultHeight)
                    backButton.isHidden = true
                    line.isHidden = false
                }
                else if newHeight < maximumContainerHeight && isDraggingDown {
                    animateContainerHeight(defaultHeight)
                    backButton.isHidden = true
                    line.isHidden = false
                }
                else if newHeight > defaultHeight && !isDraggingDown {
                    animateContainerHeight(maximumContainerHeight)
                    backButton.isHidden = false
                    line.isHidden = true
                }
            default:
                break
        }
    }
    
    @objc func backAction() {
        animateDismissView()
    }
    
    @objc func didDimmedViewTap() {
        animateDismissView()
    }
}
