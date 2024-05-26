import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:first_project/model/player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:first_project/model/track.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConcatenatingAudioSource _playlist;
  

  MyAudioHandler() {
    _init();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  void _init() {
    // Listen to audio player state and update audio service state accordingly.
    _audioPlayer.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: _audioPlayer.playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: _audioPlayer.currentIndex,
      ));
    });

    // Listen for changes in the current track.
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && _playlist.children.isNotEmpty) {
        mediaItem.add(
            (_playlist.children[index] as UriAudioSource).tag as MediaItem);
      }
    });

    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && _playlist.children.isNotEmpty) {
        final track =
            (_playlist.children[index] as UriAudioSource).tag as Track;
        mediaItem.add(track.toMediaItem());
        _currentTrackController.add(track);
      }
    });
    // Handle when the player completes playback.
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
      }
    });
  }

  final _currentTrackController = StreamController<Track?>.broadcast();
  Stream<Track?> get currentTrackStream => _currentTrackController.stream;

  // Update the current track whenever the currentIndex changes
  void _updateCurrentTrack() {
    if (_audioPlayer.currentIndex != null && _playlist.children.isNotEmpty) {
      final currentTrack = _playlist.children[_audioPlayer.currentIndex!] as UriAudioSource;
      _currentTrackController.add(currentTrack.tag as Track?);
    } else {
      _currentTrackController.add(null);
    }
  }

  @override
  void dispose() {
    _currentTrackController.close();
  }

  Future<void> updatePlaylist(List<Track> tracks) async {
    currentPlaylist = tracks;
    List<AudioSource> audioSources = tracks.map((track) {
      return AudioSource.uri(
        Uri.parse(track.audioPath),
        tag: MediaItem(
          id: track.audioPath,
          title: track.trackName,
          artist: track.userId ?? '', // Replace with actual artist name
          artUri: Uri.parse(track.coverImagePath),
        ),
      );
    }).toList();
    _playlist = ConcatenatingAudioSource(children: audioSources);
    await _audioPlayer.setAudioSource(_playlist);
    queue.add(tracks.map((track) => track.toMediaItem()).toList());
  }

  Future<void> loadSingleTrack(Track track) async {
    final mediaItem = MediaItem(
      id: track.audioPath,
      title: track.trackName,
      artist: track.userId ?? '',
      artUri: Uri.parse(track.coverImagePath),
    );

    final audioSource = AudioSource.uri(
      Uri.parse(track.audioPath),
      tag: mediaItem,
    );

    await _audioPlayer.setAudioSource(audioSource);
    this.mediaItem.add(mediaItem);
    this.queue.add([mediaItem]);
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await super.stop();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    await _audioPlayer.seek(Duration.zero, index: index);
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) {
    _audioPlayer.setLoopMode(
      repeatMode == AudioServiceRepeatMode.one ? LoopMode.one : LoopMode.all,
    );
    return super.setRepeatMode(repeatMode);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) {
    _audioPlayer
        .setShuffleModeEnabled(shuffleMode == AudioServiceShuffleMode.all);
    return super.setShuffleMode(shuffleMode);
  }

  @override
  Future<void> setSpeed(double speed) => _audioPlayer.setSpeed(speed);

  bool get isLoaded => _audioPlayer.processingState == ProcessingState.ready;
  Future<void> playTrackWithPlaylist(
      Track selectedTrack, List<Track> playlist) async {
    // Find index of selected track in the playlist
    final index = playlist.indexWhere((track) => track.id == selectedTrack.id);
    if (index == -1) {
      // Selected track not found in playlist
      return;
    }

    // Add tracks to playlist audio source
    List<AudioSource> audioSources = playlist.map((track) {
      return AudioSource.uri(
        Uri.parse(track.audioPath),
        tag: MediaItem(
          id: track.audioPath,
          title: track.trackName,
          artist: track.userId ?? '',
          artUri: Uri.parse(track.coverImagePath),
        ),
      );
    }).toList();
    _playlist = ConcatenatingAudioSource(children: audioSources);

    // Set playlist audio source for the audio player
    await _audioPlayer.setAudioSource(_playlist);

    // Set the initial queue with all tracks
    queue.add(playlist.map((track) => track.toMediaItem()).toList());

    // Play the selected track
    await _audioPlayer.seek(Duration.zero, index: index);
    await _audioPlayer.play();
  }

  Track? getPreviousTrack(List<Track> tracks) {
    final currentIndex = audioPlayer.currentIndex;
    if (currentIndex != null && currentIndex > 0) {
      return tracks[currentIndex - 1];
    }
    return null;
  }

  Track? getNextTrack(List<Track> tracks) {
    final currentIndex = audioPlayer.currentIndex;
    if (currentIndex != null && currentIndex < tracks.length - 1) {
      return tracks[currentIndex + 1];
    }
    return null;
  }

}
