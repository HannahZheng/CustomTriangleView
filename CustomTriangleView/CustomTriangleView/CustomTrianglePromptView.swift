//
//  CustomTrianglePromptView.swift
//  CustomTrianglePromptView
//
//  Created by Han on 2024/3/30.
//

import UIKit

enum CustomTrianglePositionType {
    case top, right, bottom, left
}
/// 带三角的视图，支持上下左右箭头设置（宽度 高度）与不同位置，以及边框与填充色设置，支持非正常三角设置
final class CustomTrianglePromptView: UIView {
    /// 三角的顶点
    private var triangle_center: CGPoint = .zero
    /// 三角的边长
    var triangle_length: CGFloat = 18
    /// 三角形左侧或者上面的点 与三角形边长距离的比率
    var triagnle_ratio: CGFloat = 0.5
    /// 三角的高度
    var triangle_height: CGFloat = 8
    /// 三角
    var triangle_postion: CustomTrianglePositionType = .top
    var corner_radius: CGFloat = 12
    var triangle_position_left: CGFloat = 0
    
    // 三角边左侧或者上面的点
    private var triangle_point1: CGPoint = .zero
    // 三角边右侧或者下面的点
    private var triangle_point2: CGPoint = .zero
    
    private lazy var leftTopPoint: CGPoint = .zero
    private lazy var rightTopPoint: CGPoint = .zero
    private lazy var rightBottomPoint: CGPoint = .zero
    private lazy var leftBottomPoint: CGPoint = .zero
    
    private lazy var linePath: CGMutablePath = {
        let path = CGMutablePath()
        return path
    }()
    
    private(set) lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 0
        layer.fillColor = UIColor.black.withAlphaComponent(0.6).cgColor
        layer.strokeColor = UIColor.clear.cgColor
        return layer
    }()
    
    convenience init(position: CustomTrianglePositionType, left: CGFloat) {
        self.init(frame: .zero)
        self.triangle_postion = position
        self.triangle_position_left = left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = bounds
        updatePath()
    }
    
    func updatePath() {
        caculatePointPosition()
        caculatePath()
        shapeLayer.path = linePath
    }
}

private extension CustomTrianglePromptView {
    // 计算三角形的另外2个点 以及 矩形的四个角
    func caculatePointPosition() {
        guard bounds.size != .zero else {
            return
        }
        triangle_center = .zero
        let left_width = triangle_length * triagnle_ratio
        let right_width = triangle_length * (1 - triagnle_ratio)
        switch triangle_postion {
        case .top:
            triangle_center.x = triangle_position_left
            
            triangle_point1.x = triangle_center.x - left_width
            triangle_point1.y = triangle_center.y + triangle_height
            triangle_point2.x = triangle_center.x + right_width
            triangle_point2.y = triangle_center.y + triangle_height
            
            leftTopPoint  = CGPoint(x: 0, y: triangle_height)
            rightTopPoint = CGPoint(x: bounds.width, y: triangle_height)
            rightBottomPoint = CGPoint(x: bounds.width, y: bounds.height)
            leftBottomPoint = CGPoint(x: 0, y: bounds.height)
            
        case .right:
            triangle_center.x = bounds.width
            triangle_center.y = triangle_position_left
            
            triangle_point1.x = triangle_center.x - triangle_height
            triangle_point1.y = triangle_center.y - left_width
            triangle_point2.x = triangle_center.x - triangle_height
            triangle_point2.y = triangle_center.y + right_width
            
            leftTopPoint  = CGPoint(x: 0, y: 0)
            rightTopPoint = CGPoint(x: bounds.width - triangle_height, y: 0)
            rightBottomPoint = CGPoint(x: bounds.width - triangle_height, y: bounds.height)
            leftBottomPoint = CGPoint(x: 0, y: bounds.height)
            
        case .bottom:
            triangle_center.x = triangle_position_left
            triangle_center.y = bounds.height
            
            triangle_point1.x = triangle_center.x - left_width
            triangle_point1.y = triangle_center.y - triangle_height
            triangle_point2.x = triangle_center.x + right_width
            triangle_point2.y = triangle_center.y - triangle_height
            
            leftTopPoint  = CGPoint(x: 0, y: 0)
            rightTopPoint = CGPoint(x: bounds.width, y: 0)
            rightBottomPoint = CGPoint(x: bounds.width, y: bounds.height - triangle_height)
            leftBottomPoint = CGPoint(x: 0, y: bounds.height - triangle_height)
            
        case .left:
            triangle_center.y = triangle_position_left
            
            triangle_point1.x = triangle_center.x + triangle_height
            triangle_point1.y = triangle_center.y - left_width
            triangle_point2.x = triangle_center.x + triangle_height
            triangle_point2.y = triangle_center.y + right_width
            
            leftTopPoint  = CGPoint(x: triangle_height, y: 0)
            rightTopPoint = CGPoint(x: bounds.width, y: 0)
            rightBottomPoint = CGPoint(x: bounds.width, y: bounds.height)
            leftBottomPoint = CGPoint(x: triangle_height, y: bounds.height)
        }
    }
    
    func caculatePath() {
        
        linePath.move(to: triangle_center)
        linePath.addLine(to: triangle_point1)
        switch triangle_postion {
        case .top:
            let point1 = CGPoint(x: leftTopPoint.x + corner_radius, y: leftTopPoint.y)
            linePath.addLine(to: point1)
            
            let point2 = CGPoint(x: leftTopPoint.x, y: leftTopPoint.y + corner_radius)
            // 控制点1与当前点为切线1，控制点1与控制点2构成切线2
            linePath.addArc(tangent1End: leftTopPoint, tangent2End: point2, radius: corner_radius)
            
            let p3 = CGPoint(x: leftBottomPoint.x, y: leftBottomPoint.y - corner_radius)
            linePath.addLine(to: p3)
            
            let p4 = CGPoint(x: leftBottomPoint.x + corner_radius, y: leftBottomPoint.y)
            linePath.addArc(tangent1End: leftBottomPoint, tangent2End: p4, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: rightBottomPoint.x - corner_radius, y: rightBottomPoint.y))
            let p5 = CGPoint(x: rightBottomPoint.x, y: rightBottomPoint.y - corner_radius)
            linePath.addArc(tangent1End: rightBottomPoint, tangent2End: p5, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: rightTopPoint.x, y: rightTopPoint.y + corner_radius))
            let p6 = CGPoint(x: rightTopPoint.x - corner_radius, y: rightTopPoint.y)
            linePath.addArc(tangent1End: rightTopPoint, tangent2End: p6, radius: corner_radius)
            
        case .right:
            let point1 = CGPoint(x: rightTopPoint.x, y: rightTopPoint.y + corner_radius)
            linePath.addLine(to: point1)
            
            let point2 = CGPoint(x: rightTopPoint.x - corner_radius, y: rightTopPoint.y)
            // 控制点1与当前点为切线1，控制点1与控制点2构成切线2
            linePath.addArc(tangent1End: rightTopPoint, tangent2End: point2, radius: corner_radius)
            
            let p3 = CGPoint(x: leftTopPoint.x + corner_radius, y: leftTopPoint.y)
            linePath.addLine(to: p3)
            
            let p4 = CGPoint(x: leftTopPoint.x, y: leftTopPoint.y + corner_radius)
            linePath.addArc(tangent1End: leftTopPoint, tangent2End: p4, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: leftBottomPoint.x, y: rightBottomPoint.y - corner_radius))
            let p5 = CGPoint(x: leftBottomPoint.x + corner_radius, y: leftBottomPoint.y)
            linePath.addArc(tangent1End: leftBottomPoint, tangent2End: p5, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: rightBottomPoint.x - corner_radius, y: rightBottomPoint.y))
            let p6 = CGPoint(x: rightBottomPoint.x, y: rightBottomPoint.y - corner_radius)
            linePath.addArc(tangent1End: rightBottomPoint, tangent2End: p6, radius: corner_radius)
            
            
            
        case .bottom:
            let point1 = CGPoint(x: leftBottomPoint.x + corner_radius, y: leftBottomPoint.y)
            linePath.addLine(to: point1)
            
            let point2 = CGPoint(x: leftBottomPoint.x, y: leftBottomPoint.y - corner_radius)
            // 控制点1与当前点为切线1，控制点1与控制点2构成切线2
            linePath.addArc(tangent1End: leftBottomPoint, tangent2End: point2, radius: corner_radius)
            
            let p3 = CGPoint(x: leftTopPoint.x, y: leftTopPoint.y + corner_radius)
            linePath.addLine(to: p3)
            
            let p4 = CGPoint(x: leftTopPoint.x + corner_radius, y: leftTopPoint.y)
            linePath.addArc(tangent1End: leftTopPoint, tangent2End: p4, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: rightTopPoint.x - corner_radius, y: rightTopPoint.y))
            let p5 = CGPoint(x: rightTopPoint.x, y: rightTopPoint.y + corner_radius)
            linePath.addArc(tangent1End: rightTopPoint, tangent2End: p5, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: rightBottomPoint.x, y: rightBottomPoint.y - corner_radius))
            let p6 = CGPoint(x: rightBottomPoint.x - corner_radius, y: rightBottomPoint.y)
            linePath.addArc(tangent1End: rightBottomPoint, tangent2End: p6, radius: corner_radius)
            
        case .left:
            let point1 = CGPoint(x: leftTopPoint.x, y: leftTopPoint.y + corner_radius)
            linePath.addLine(to: point1)
            let point2 = CGPoint(x: leftTopPoint.x + corner_radius, y: leftTopPoint.y)
            // 控制点1与当前点为切线1，控制点1与控制点2构成切线2
            linePath.addArc(tangent1End: leftTopPoint, tangent2End: point2, radius: corner_radius)
            
            let p3 = CGPoint(x: rightTopPoint.x - corner_radius, y: rightTopPoint.y)
            linePath.addLine(to: p3)
            
            let p4 = CGPoint(x: rightTopPoint.x, y: rightTopPoint.y + corner_radius)
            linePath.addArc(tangent1End: rightTopPoint, tangent2End: p4, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: rightBottomPoint.x, y: rightBottomPoint.y - corner_radius))
            let p5 = CGPoint(x: rightBottomPoint.x - corner_radius, y: rightBottomPoint.y)
            linePath.addArc(tangent1End: rightBottomPoint, tangent2End: p5, radius: corner_radius)
            
            linePath.addLine(to: CGPoint(x: leftBottomPoint.x + corner_radius, y: leftBottomPoint.y))
            let p6 = CGPoint(x: leftBottomPoint.x, y: leftTopPoint.y - corner_radius)
            linePath.addArc(tangent1End: leftBottomPoint, tangent2End: p6, radius: corner_radius)
            
    
        }
        
        linePath.addLine(to: triangle_point2)
        linePath.addLine(to: triangle_center)
//        linePath.closeSubpath()
    }
}
