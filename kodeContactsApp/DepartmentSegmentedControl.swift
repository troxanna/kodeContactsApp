
//
//  DepartmentSegmentedControl.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 09.03.2023.
//

import UIKit

class DepartmentSegmentedControl: UIView, UIScrollViewDelegate {

    weak var delegate: DepartmentSegmentedControlDelegate?
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private let segmentsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1)
        return label
    }()
    
    private let activeLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    private var segmentButtons: [UIButton] = []
    private var segmentViews: [UIView] = []

    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            setupActiveSegment(segmentButtons[selectedSegmentIndex])
        }
    }
    

    init(frame: CGRect, items: [String]) {
        super.init(frame: frame)
        self.scrollView.delegate = self
        setup(items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(items: [String]) {
        makeConstraintsScrollView()
        makeConstraintsContentView()
        
        for item in items {
            segmentViews.append(UIView())
            guard let viewSegment = segmentViews.last else { break }
            guard let buttonSegment = configurationContentSegmentButtons(item: item) else { break }
            viewSegment.addSubview(buttonSegment)
            buttonSegment.snp.makeConstraints({ make in
                make.left.equalTo(viewSegment.snp.left).inset(12)
                make.right.equalTo(viewSegment.snp.right).inset(12)
            })
            segmentsStackView.addArrangedSubview(viewSegment)
        }
        
        addTargetSegmentButtons()
        makeConstraintsLine()
        makeConstraintsSegmentsStackView()
    }
}

//MARK: Private functions
extension DepartmentSegmentedControl {
    private func configurationContentSegmentButtons(item: String) -> UIButton? {
        segmentButtons.append(UIButton())
        guard let buttonSegment = segmentButtons.last else { return nil }
        buttonSegment.setTitle(item, for: .normal)
        buttonSegment.backgroundColor = .white
        buttonSegment.titleLabel?.font = UIFont(name: "Inter-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        buttonSegment.setTitleColor(UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1), for: .normal)
        return buttonSegment
    }
    
    private func addTargetSegmentButtons() {
        for button in segmentButtons {
            button.addTarget(self, action: #selector(buttonSegmentPressed), for: .touchUpInside)
        }
    }
    
    private func makeConstraintsScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    private func makeConstraintsContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({ make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView.frameLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.frameLayoutGuide.snp.bottom)
            make.height.equalTo(36)
        })
    }
    
    private func makeConstraintsLine() {
        contentView.addSubview(line)
        line.snp.makeConstraints({ make in
            make.height.equalTo(0.33)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        })
    }
    
    private func makeConstraintsSegmentsStackView() {
        contentView.addSubview(segmentsStackView)
        segmentsStackView.snp.makeConstraints({ make in
            make.right.equalTo(contentView.snp.right).inset(16)
            make.left.equalTo(contentView.snp.left).inset(16)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(line.snp.top)
        })
    }
    
    private func makeConstraintsSegmentView() {

    }
    
    private func makeConstraintsActiveLineForBotton(sender: UIButton) {
        guard let viewSegment = sender.superview else { return }
        contentView.addSubview(activeLine)
        activeLine.snp.makeConstraints({ make in
            make.height.equalTo(2)
            make.bottom.equalTo(line.snp.top)
            make.leading.equalTo(viewSegment.snp.leading)
            make.trailing.equalTo(viewSegment.snp.trailing)
        })
    }
    
    private func setupActiveSegment(_ sender: UIButton) {
        activeLine.snp.removeConstraints()
        activeLine.removeFromSuperview()
        
        for button in segmentButtons {
            button.setTitleColor(UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1), for: .normal)
        }
        sender.setTitleColor(UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1), for: .normal)
        makeConstraintsActiveLineForBotton(sender: sender)
    }
    
    @objc private func buttonSegmentPressed(_ sender: UIButton) {
        setupActiveSegment(sender)
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
        if let department = sender.currentTitle {
            self.delegate?.buttonSegmentPressed(department: department)
        }
    }
}

