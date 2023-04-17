---
layout: post
title: "Don't use AVPlayerLooper to loop videos in iOS"
---

If you want to load a video that loops in iOS, you might be tempted to use
[`AVPlayerLooper`](https://developer.apple.com/documentation/avfoundation/avplayerlooper).
From the documentation, you would get the idea that this is the ideal class
for this:
> You can manually implement looping playback in your app using AVQueuePlayer, 
> but AVPlayerLooper provides a much simpler interface to loop a single AVPlayerItem. 
> You create a player looper by passing it a reference to your AVQueuePlayer 
> and a template AVPlayerItem and the looper automatically manages the looping 
> playback of this content


