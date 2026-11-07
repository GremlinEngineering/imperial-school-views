import AppKit
import CoreText

@MainActor enum ViewsBrand {
    static let paper = color(0xfbf8ec, 0x141126, highContrast: .windowBackgroundColor)
    static let ink = color(0x272635, 0xf3ecdb, highContrast: .labelColor)
    static let muted = color(0x56536b, 0xb9b1ce, highContrast: .labelColor)
    static let accent = color(0x9d3766, 0xfbbf55, highContrast: .labelColor)

    private static func color(_ light: Int, _ dark: Int, highContrast: NSColor) -> NSColor {
        NSColor(name: nil) { appearance in
            switch appearance.bestMatch(from: [.accessibilityHighContrastDarkAqua, .accessibilityHighContrastAqua, .darkAqua, .aqua]) {
            case .accessibilityHighContrastDarkAqua, .accessibilityHighContrastAqua: return highContrast
            case .darkAqua: return rgb(dark)
            default: return rgb(light)
            }
        }
    }

    nonisolated private static func rgb(_ value: Int) -> NSColor {
        NSColor(srgbRed: CGFloat(value >> 16) / 255, green: CGFloat((value >> 8) & 255) / 255, blue: CGFloat(value & 255) / 255, alpha: 1)
    }

    static func registerFonts(in folder: URL?) {
        guard let folder else { return }
        for name in ["oswald_semibold", "literata", "ptmono"] {
            CTFontManagerRegisterFontsForURL(folder.appendingPathComponent(name + ".ttf") as CFURL, .process, nil)
        }
    }

    static let bundledFonts: Void = registerFonts(in: Bundle.main.resourceURL?.appendingPathComponent("branding"))

    static func heading(_ size: CGFloat) -> NSFont { NSFont(name: "Oswald-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold) }
    static func intro(_ size: CGFloat) -> NSFont { NSFont(name: "Literata-12pt", size: size) ?? .systemFont(ofSize: size) }
    static func details(_ size: CGFloat) -> NSFont { NSFont(name: "PTMono-Regular", size: size) ?? .monospacedSystemFont(ofSize: size, weight: .regular) }
}

final class ViewsBrandSurface: NSView {
    override func draw(_ dirtyRect: NSRect) {
        ViewsBrand.paper.setFill()
        NSRectFill(dirtyRect)
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
    }
}
