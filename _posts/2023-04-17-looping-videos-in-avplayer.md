---
layout: post
title: "Don't use AVPlayerLooper to loop HLS video streams in iOS"
---

If you want to load an HLS video stream that loops in iOS, you might be tempted to use
[`AVPlayerLooper`](https://developer.apple.com/documentation/avfoundation/avplayerlooper).
From the documentation, you would get the idea that this is the ideal class
for this:

> You can manually implement looping playback in your app using AVQueuePlayer, 
> but AVPlayerLooper provides a much simpler interface to loop a single AVPlayerItem. 
> You create a player looper by passing it a reference to your AVQueuePlayer 
> and a template AVPlayerItem and the looper automatically manages the looping 
> playback of this content

However, using `AVPlayerLooper`, at least for HLS streams, is problematic and
I'd recommend you avoid it and instead rely in a traditional [solution](#the-solution).

I won't be providing examples for you to play with and see with your own eyes
given that this bug was found in the app I develop for work and can't share
the private details. Hopefully you can take my word for it 🙂

## Looping videos with `AVPlayerLooper`

> _NOTE: SwiftUI still doesn't offer a very powerful video player. This solution will be
based on UIKit_

So, you look at the docs and a few Stack Overflow solutions and write an initial
implementation like this one:
{% highlight swift %}
class LoopingVideoPlayerView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private let queuePlayer = AVQueuePlayer()

    override func layoutSubviews() {
        super.layoutSubviews()

        self.playerLayer.frame = bounds
    }

    func configure(url: URL) {
        // Set the player on the UI layer
        playerLayer.player = queuePlayer
        layer.addSublayer(playerLayer)

        // Create the player item, start loading stream from the URL
        let playerItem = AVPlayerItem(url: url)

        // WARNING! The following lines won't have any effect!
        playerItem.preferredForwardBufferDuration = 3 // only keep a 3s buffer
        playerItem.preferredMaximumResolution = .init(width: 1080, height: 720)

        // Loop the video once its finished
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
    }

    func startPlayback() {
        queuePlayer.play()
    }
}
{% endhighlight %}

Looks pretty good, right?

## The problem

When following the above approach, I noticed a couple of problems:
- **Data usage off the charts:**
Using HLS video streams, with multiple resolutions available,
would cause the app to continuously and excesively download tons of data.
You can get a lot of negative App Store reviews because of this 😅.

- **Battery drain, higher CPU usage:**
This also causes higher CPU usage which incidentally makes your app feel less
responsive. Using the proposed solution made the app I work on feel snappier.

- **No configuration of AVPlayerItem:**
`AVPlayerItem` has [a bunch of different properties](https://developer.apple.com/documentation/avfoundation/avplayeritem#2528249)
that can be used to configure playback of a video, such as:
	* `var preferredPeakBitRate: Double`
	* `var preferredForwardBufferDuration: TimeInterval`
	* `var preferredMaximumResolution: CGSize`

All of these properties, and more, can be used to limit the amount of data
that the video playback is going to require.
However, setting these properties seems to have no effect when using `AVPlayerLooper`.

My guess is that this a bug from Apple, an oversight. Reading the documentation
of `AVPlayerLooper` you can learn that it works by making multiple copies
of the `AVPlayerItem` and adding them to the `AVQueuePlayer` for them to play
one after the other. My guess is that these configuration properties are not
being copied or respected.

I would also assume that once an `AVPlayerItem` gets created, it starts loading
the asset immediately, even though it's not actually visible and playing. Given
that multiple items get created, you are essentially downloading the same stream
multiple times.

## The solution

Don't use `AVPlayerLooper`! As much as I would love to use the simpler API, this
bug is a blocker. However, the alternative is not too bad:

{% highlight swift %}
class LoopingVideoPlayerView: UIView {
    private let playerLayer = AVPlayerLayer()
    private let player = AVPlayer()

    override func layoutSubviews() {
        super.layoutSubviews()

        self.playerLayer.frame = bounds
    }

    func configure(url: URL) {
        // Set the player on the UI layer
        playerLayer.player = player
        layer.addSublayer(playerLayer)

        // Create the player item, start loading stream from the URL
        let playerItem = AVPlayerItem(url: url)

        // Limit data usage
        playerItem.preferredForwardBufferDuration = 3 // only keep a 3s buffer
        playerItem.preferredMaximumResolution = .init(width: 1080, height: 720)

        // Loop the video once its finished
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rewindVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
       )
    }

    func startPlayback() {
        queuePlayer.play()
    }

    @objc private func rewindVideo() {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
}
{% endhighlight %}

* Video playback feels just as good, if not better
* Configuring the `AVPlayerItem` actually works: limiting the bitrate, the
resolution, the forward buffer, etc.
* The code is still lightweight and simple. In fact, its a bit more customizable.
Maybe you want the next time the video plays to start at a different position. 
You are in control.

## Conclusion

Hopefully Apple fixes this bug. In the meantime, the simpler approach of seeking
the single video stream to the beginning works just as well.

This is my first blog post, I hope you found it useful 😁
