import Foundation

struct FirestoreFields
{
    static let users = "users"
    
    struct User
    {
        static let date = "date"
        static let name = "name"
        static let posts = "Posts"
        
        struct Post
        {
            static let imgUrl = "imgUrl"
            static let poster = "poster"
            static let text = "text"
        }
    }
}

struct FirebaseFileFields
{
    static let avaImages = "avaImages"
    static let posts = "posts"
}
