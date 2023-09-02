//
//  Home.swift
//  ScrollHeaderAnimation
//
//  Created by shiyanjun on 2023/9/2.
//

import SwiftUI

struct Home: View {
    // 矩形背景色
    let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple]
    
    var body: some View {
        // 滚动时观察坐标变化
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    let size = geo.size
                    
                    // 顶部图片
                    Image("food")
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: 200 + (minY > 0 ? minY : 0))
                        .offset(y: minY > 0 ? -minY : 0)
                }
                .frame(height: 200)
                
                // 矩形列表
                ForEach(colors, id: \.self) { color in
                    RectangleView(fillColor: color)
                        .frame(height: 200)
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

// 矩形组件，显示矩形的大小、坐标的最小值和最大值
struct RectangleView: View {
    var fillColor: Color = .black
    var cornerRadius: CGFloat = 0
    
    @State var size: CGSize = .zero
    @State var position: CGRect = .zero
    
    var body: some View {
        Rectangle()
            .fill(fillColor)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            // 初始化大小和坐标
                            self.size = geo.size
                            self.position = geo.frame(in: .global)
                        }
                        .onChange(of: geo.frame(in: .global)) { newPosition in
                            // 监控坐标变化
                            self.position = newPosition
                        }
                }
            )
            .overlayText(
                text: "W:\(format(value: self.size.width))\nH:\(format(value: self.size.height))",
                alignment: .center)
            .overlayText(
                text: "(\(format(value: self.position.minX)), \(format(value: self.position.minY)))",
                alignment: .topLeading)
            .overlayText(
                text: "(\(format(value: self.position.maxX)), \(format(value: self.position.maxY)))",
                alignment: .bottomTrailing)
    }
    
    // 数字格式化，保留2位小数
    func format(value: Double) -> String {
        return String(format: "%.2f", value)
    }
}

extension View {
    // 标注背景样式
    func markBackgroundStyle() -> some View {
        modifier(MarkBackgroundModifier())
    }
    
    // 覆盖文字视图
    func overlayText(text: String, alignment: Alignment) -> some View {
        modifier(OverlayTextModifier(text: text, alignment: alignment))
    }
}

struct MarkBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .font(.caption)
            .foregroundColor(.white)
            .background(
                Rectangle()
                    .fill(.black.opacity(0.5))
            )
    }
}

struct OverlayTextModifier: ViewModifier {
    let text: String
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .overlay (
                VStack(alignment: .leading) {
                    Text(text)
                }
                    .markBackgroundStyle()
                , alignment: alignment
            )
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

