//
//  ContentView.swift
//  CircleTransition
//
//  Created by Patrick Maltagliati on 11/12/20.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var animation
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Initial(animation: animation)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isShowingRed.toggle()
                    }
                }
            if isShowingRed {
                Detail(isShowing: $isShowingRed, animation: animation)
                    .transition(.iris)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1)
            }
        }
    }
}


struct Initial: View {
    var animation: Namespace.ID

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor(Color.red))
            Text(verbatim: "Hello").font(.system(.headline)).foregroundColor(.white).matchedGeometryEffect(id: "Title", in: animation)
        }
    }
}

struct Detail: View {
    @Binding var isShowing: Bool
    var animation: Namespace.ID

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Text(verbatim: "Hello").font(.system(.headline)).foregroundColor(.white).matchedGeometryEffect(id: "Title", in: animation)
                Stepper("Control", onIncrement: {}, onDecrement: {})
                Spacer()
            }
            Spacer()
        }
        .background(Color.red)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isShowing.toggle()
            }
        }
    }
}

struct ScaledCircle: Shape {
    var animatableData: CGFloat

    func path(in rect: CGRect) -> Path {
        let maximumCircleRadius = sqrt(rect.width * rect.width + rect.height * rect.height)
        let circleRadius = maximumCircleRadius * animatableData

        let x = rect.midX - circleRadius / 2
        let y = rect.midY - circleRadius / 2
        let circleRect = CGRect(x: x, y: y, width: circleRadius, height: circleRadius)

        return Circle().path(in: circleRect)
    }
}

struct ClipShapeModifier: ViewModifier {
    let shape: ScaledCircle

    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}

struct NoOp: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension AnyTransition {
    static var iris: AnyTransition {
        .modifier(
            active: ClipShapeModifier(shape: ScaledCircle(animatableData: 0)),
            identity: ClipShapeModifier(shape: ScaledCircle(animatableData: 1))
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
