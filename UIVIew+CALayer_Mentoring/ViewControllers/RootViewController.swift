//
//  ViewController.swift
//  UIVIew+CALayer_Mentoring
//
//  Created by EvgeniiChistyakov on 01.03.2021.
//

import UIKit

class RootViewController: UIViewController {
    
    //MARK: - UIView
        
    private var mainView: CustomView!
    private var secondView: CustomView!
    private var pauseButton: UIButton!
    private var replaceButton: UIButton!
    
    //MARK: - Lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtons()
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        //MARK: - setupMainView
        
        mainView = CustomView(backgroundColor: .green, text: "Nikolay Truchin")
        self.view.addSubview(mainView)
        NSLayoutConstraint.activate([mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 20),
                                     mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                                     mainView.heightAnchor.constraint(equalToConstant: 200)])
        
        
        //MARK: - setupSecondView
        
        secondView = CustomView(backgroundColor: .red, text: "Andrey Kozlov", shadow: true)
        self.view.addSubview(secondView)
        self.view.addConstraints([secondView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                  secondView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                  secondView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4),
                                  secondView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4)])
        
        [secondView, mainView].forEach { self.addTap(view: $0) }
    }
    
    private func configureButton(title: String?, selector: Selector) -> UIButton {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func setupButtons() {
        pauseButton = configureButton(title: "Pause", selector: #selector(tapPauseButton))
        replaceButton = configureButton(title: "Replace", selector: #selector(tapReplaceButton))
        
        let stackView = UIStackView(arrangedSubviews: [pauseButton, replaceButton])
        pauseButton.isHidden = true
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution  = UIStackView.Distribution.equalCentering
        stackView.alignment = UIStackView.Alignment.center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),
                                     view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
                                     pauseButton.heightAnchor.constraint(equalToConstant: 50),
                                     replaceButton.heightAnchor.constraint(equalToConstant: 50),
                                     pauseButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
                                     replaceButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9)])
        
    }
}


//MARK: - AddGesture to view

extension RootViewController {
    private func addTap(view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
}

//MARK: - Handles tap

extension RootViewController {
    @objc
    private func tapPauseButton() {
        [mainView, secondView].forEach { itemView in
            let currentLayer = itemView!.layer
            if currentLayer.speed != 0 {
                pauseLayer(layer: currentLayer)
                pauseButton.setTitle("Resume", for: .normal)
            } else {
                resumeAnimation(layer: currentLayer)
                pauseButton.setTitle("Pause", for: .normal)
            }
        }
    }
    
    @objc
    private func tapReplaceButton() {
        guard let displayFrontView = self.view.subviews.last == mainView ? secondView : mainView else { return }
        displayFrontView.alpha = 0
        self.view.bringSubviewToFront(displayFrontView)
        UIView.animate(withDuration: 0.8, animations: {
            displayFrontView.alpha = 1
        })
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let currentView =  sender.view as? CustomView else { return }
        let anotherView = currentView == mainView ? secondView : mainView
        if !removeAnimation(view: currentView, for: "rotation") {
            rotateAnimation(view: currentView, reverse: currentView == mainView)
            pauseButton.isHidden = false
            
        } else if anotherView?.layer.animation(forKey: "rotation") == nil {
            pauseButton.isHidden = true
        }
    }
}

//MARK: - Layer + Animations

extension RootViewController {
    private func removeAnimation (view: UIView, for key: String) -> Bool {
        guard view.layer.animation(forKey: key) != nil else { return false }
        view.layer.removeAnimation(forKey: key)
        view.transform = .identity
        return true
    }
    
    private func rotateAnimation(view: UIView, duration: CFTimeInterval = 2.0, reverse: Bool = false) {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = reverse ? CGFloat(.pi * 2.0) : 0
            rotateAnimation.toValue = reverse ? 0 : CGFloat(.pi * 2.0)
            rotateAnimation.duration = duration
            rotateAnimation.repeatCount = .greatestFiniteMagnitude
            view.layer.add(rotateAnimation, forKey: "rotation")
    }
    
    private func pauseLayer(layer : CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func resumeAnimation(layer : CALayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}


