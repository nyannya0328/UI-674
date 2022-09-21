//
//  MorphingView.swift
//  UI-674
//
//  Created by nyannyan0328 on 2022/09/21.
//

import SwiftUI

struct MorphingView: View {
    @State var currentImage : CustomShape = .cloud
    @State var pickedImage : CustomShape = .cloud
    @State var turnOffImage : Bool = false
    
    @State var animatedMorphy : Bool = false
    
    @State var blurRaius : CGFloat = 0
    var body: some View {
        VStack{
            
            GeometryReader{proxy in
                
                let size = proxy.size
             
                Image("p1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,height: size.height)
                    .clipped()
                    .overlay {
                        
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImage ? 1 : 0)
                    }
                    .mask {
                        
                        Canvas { context, size in
                            
                            context.addFilter(.alphaThreshold(min: 0.3))
                            context.addFilter(.blur(radius: blurRaius >= 20 ? 20 - (blurRaius - 20) : blurRaius))
                            context.drawLayer { cxt in
                                
                                if let reslovedImage = context.resolveSymbol(id: 1){
                                    
                                    cxt.draw(reslovedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                    
                                }
                            }
                            
                            
                        } symbols: {
                            
                            ResolVedView(currentImage: $currentImage)
                                .tag(1)
                        }

                    }
                    .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                        
                        
                        if animatedMorphy{
                            
                            if blurRaius <= 40{
                                
                                blurRaius += 0.5
                                
                                if blurRaius.rounded() == 20{
                                    currentImage = pickedImage
                                    
                                }
                            }
                            if blurRaius.rounded() == 40{
                                
                                animatedMorphy = false
                                blurRaius = 0
                            }
                        }
                    }
                
            
                    
            }
            .frame(height:400)
            
            Picker("", selection: $pickedImage) {
                
                ForEach(CustomShape.allCases ,id:\.self){shape in
                    
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .contentShape(Rectangle())
            .padding(.horizontal)
            .pickerStyle(.segmented)
            .overlay {
                Rectangle()
                    .fill(.red)
                    .opacity(animatedMorphy ? 0.1 : 0)
            }
            .onChange(of: pickedImage) { newValue in
                
                animatedMorphy = true
            }
            
            Toggle("Trun off Image", isOn: $turnOffImage)
                .fontWeight(.semibold)
                .padding(.top,15)
            
            
        
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
    }
}

struct ResolVedView : View{
    
    @Binding var currentImage : CustomShape
    var body: some View{
        
        Image(systemName:currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.7,dampingFraction: 0.7,blendDuration: 0.7), value: currentImage)
            .frame(width: 300,height: 300)
        
    }
}



struct MorphingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
