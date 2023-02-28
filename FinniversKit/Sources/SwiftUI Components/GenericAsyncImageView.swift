import SwiftUI

public struct GenericAsyncImageView: View {
    let imageURL: URL?
    let fallbackImage: Image = Image(uiImage: UIImage(named: .noImage))
    let backgroundColor: Color = .bgSecondary
    
    @State private var state: ImageState = .loading
    
    public init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    public init(imageURLString: String?) {
        self.imageURL = URL(string: imageURLString ?? "")
    }
    
    public var body: some View {
        Group {
            switch state {
            case .loading:
                ZStack {
                    Rectangle()
                        .fill(backgroundColor)
                    
                    ProgressView()
                }
                
            case .fetched(let image):
                image.resizable()
                
            case .notFound:
                fallbackImage.resizable()
            }
        }
        .onAppear {
            Task {
                await fetchImage()
            }
        }
    }
    
    private func fetchImage() async {
        guard let imageURL else {
            state = .notFound
            return
        }
        
        if
            let (data, _) = try? await URLSession.shared.data(from: imageURL),
            let uiImage = UIImage(data: data)
        {
            let image = Image(uiImage: uiImage)
            self.state = .fetched(image)
            
        } else {
            self.state = .notFound
        }
    }
}

extension GenericAsyncImageView {
    enum ImageState {
        case loading
        case fetched(Image)
        case notFound
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        GenericAsyncImageView(imageURL: URL(string: ""))
    }
}

