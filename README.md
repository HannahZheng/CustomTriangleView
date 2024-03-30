支持非等腰箭头设置
带三角的视图，支持上下左右箭头设置（宽度 高度）与不同位置，以及边框与填充色设置，支持非正常三角设置（非等腰）

![截屏2024-03-30 18 19 16](https://github.com/HannahZheng/CustomTriangleView/assets/19170853/6cbe5598-7186-4153-adad-b8a184f3d6db)
![截屏2024-03-30 18 18 54](https://github.com/HannahZheng/CustomTriangleView/assets/19170853/636981fa-90d0-4622-8575-f5387c73b418)
![IMG_0218](https://github.com/HannahZheng/CustomTriangleView/assets/19170853/dce3d83c-98ae-432a-b41d-d17f46cd94e2)

使用示例：

    lazy var triangleView: CustomTrianglePromptView = {
        //非正常三角
        let view = CustomTrianglePromptView(position: .top, left: 40)
        view.triagnle_ratio = 0.85
        view.triangle_height = 10
        view.frame.size = CGSize(width: 300, height: 97)
        return view
    }()


            view.addSubview(triangleView)
        
        triangleView.frame.origin.x = 10
        triangleView.frame.origin.y = 100
        triangleView.updatePath()
