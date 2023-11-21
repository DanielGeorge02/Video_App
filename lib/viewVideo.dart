// ignore_for_file: deprecated_member_use, must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ViewVedio extends StatefulWidget {
  ViewVedio({super.key, required this.vedio, required this.name});
  var vedio;
  var name;
  @override
  State<ViewVedio> createState() => _ViewVedioState();
}

class _ViewVedioState extends State<ViewVedio> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.vedio);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 0.5,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
