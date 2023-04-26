//
//  CircularProgressView.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 12.04.2023.
//

import UIKit

class CircularProgressView: UIView {

    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: Color.white.rawValue)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.snp.makeConstraints({ make in
            make.size.equalTo(CGSize(width: 50, height: 50))
        })

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CircularProgressView {
    func animationCircular() {
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let endAngle = -CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 10, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = .none
        trackLayer.strokeColor = UIColor(named: Color.cultured.rawValue)?.cgColor
        trackLayer.lineWidth = 2
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.lineWidth = 2
        progressLayer.fillColor = .none
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        progressLayer.strokeColor = UIColor(named: Color.hanPurple.rawValue)?.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = CFTimeInterval(1)
        basicAnimation.fromValue = 0.0
        basicAnimation.toValue = 1.0
        basicAnimation.repeatCount = .infinity
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(basicAnimation, forKey: AnimationType.spinner.rawValue)
    }
    
    func stopAnimation(for key: String) {
        progressLayer.removeAnimation(forKey: key)
    }
    
    func setProgress(duration: TimeInterval = 3, to newProgress: Float) -> Void{
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = newProgress
        progressLayer.strokeEnd = CGFloat(newProgress)
        
        progressLayer.add(animation, forKey: AnimationType.fill.rawValue)
        
    }
}
