//
//  ViewController.swift
//  CustomTriangleView
//
//  Created by Han on 2024/3/30.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var triangleView: CustomTrianglePromptView = {
        //非正常三角
        let view = CustomTrianglePromptView(position: .top, left: 40)
        view.triagnle_ratio = 0.85
        view.triangle_height = 10
        view.frame.size = CGSize(width: 300, height: 97)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        view.addSubview(triangleView)
        
        triangleView.frame.origin.x = 10
        triangleView.frame.origin.y = 100
        triangleView.updatePath()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }


}

