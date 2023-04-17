import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct Static: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case blog
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    var url = URL(string: "https://alegre.dev")!

    var name = "Jorge Alegre"

    var description = """
    Hi! I'm Jorge Alegre, a software engineer from Argentina.
    """

    var imagePath: Path? { nil }

    var language: Language { .english }
}

// This will generate your website using the built-in Foundation theme:
try Static()
    .publish(using: [
        .copyResources(),
        .addMarkdownFiles(),
        .sortItems(by: \.date, order: .descending),
        .generateRSSFeed(including: [.blog]),
        .generateSiteMap(indentedBy: .spaces(2)),
        .generateHTML(
            withTheme: .foundation,
            indentation: .spaces(2)
        ),
    ])

