//
//  Library.swift
//  MusicPlayer
//
//  Created by Александр Галкин on 03.10.2021.
//

import SwiftUI

struct Library: View {
    var delegate: SaveDataProtocol?
    
    @State var tracks: [SearchViewModel.Cell] = []
    
    var list: [SearchViewModel.Cell] = []
    
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
                                if tracks != nil {
                                    self.tracks = tracks!
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
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                    }
                }
                
            }
            
            .navigationTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            
            if let urlImage = cell.trackImageUrl,
               let url = URL(string: urlImage),
               let data =  try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().frame(width: 60, height: 60).cornerRadius(5)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(cell.trackName ?? "")").fontWeight(.bold)
                Text("\(cell.artistName ?? "")")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
