//
//  Library.swift
//  MusicPlayer
//
//  Created by Александр Галкин on 03.10.2021.
//

import SwiftUI

struct Library: View {
    var delegate: SaveDataProtocol?
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8989167809, green: 0.8961265683, blue: 0.9011060596, alpha: 1)))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            SearchInteractor.loadTracks { tracks in
                                if let tracks = tracks {
                                    for i in tracks {
                                        print(i.trackName)
                                    }
                                }
                            }
                        }, label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8989167809, green: 0.8961265683, blue: 0.9011060596, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 70)
                
                Divider().padding(.leading).padding(.trailing)
                
                List {
                    LibraryCell()
                    LibraryCell()
                    LibraryCell()
                }
                
            }
            .navigationTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Image").resizable().frame(width: 60, height: 60).cornerRadius(5)
            VStack {
                Text("Track title")
                Text("Artist title")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
