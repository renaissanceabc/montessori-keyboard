import AVFoundation
import MontessoriCore

/// Says a letter's sound ("a" as in apple), a phonogram, or a whole word. Nothing leaves the device:
/// AVSpeechSynthesizer runs on the phone's own voices.
@MainActor
final class LetterSpeech {
    private let synthesizer = AVSpeechSynthesizer()

    func say(_ text: String, useIPA: Bool) {
        let utterance: AVSpeechUtterance
        if useIPA, let ipa = LetterSounds.ipa(for: text) {
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(
                NSAttributedString.Key(AVSpeechSynthesisIPANotationAttribute),
                value: ipa,
                range: NSRange(location: 0, length: attributed.length)
            )
            utterance = AVSpeechUtterance(attributedString: attributed)
        } else {
            utterance = AVSpeechUtterance(string: text)
        }
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.42
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}
