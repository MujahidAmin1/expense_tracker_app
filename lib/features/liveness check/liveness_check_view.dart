import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:facial_liveness_verification/facial_liveness_verification.dart';
import 'package:expense_tracker_app/features/navbar/navbar.dart';

class LivenessCheckView extends StatefulWidget {
  const LivenessCheckView({super.key});

  @override
  State<LivenessCheckView> createState() => _LivenessCheckViewState();
}

class _LivenessCheckViewState extends State<LivenessCheckView> {
  late LivenessDetector _detector;
  StreamSubscription<LivenessState>? _subscription;
  String _status = 'Initializing...';
  bool _isInitializing = true;
  LivenessStateType? _currentStateType;

  @override
  void initState() {
    super.initState();
    _initializeDetector();
  }

  Future<void> _initializeDetector() async {
    _detector = LivenessDetector(const LivenessConfig(
      enableAntiSpoofing: true,
      shuffleChallenges: true,
    ));

    _subscription = _detector.stateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _status = _getStatusMessage(state);
        _currentStateType = state.type;
      });

      if (state.type == LivenessStateType.completed) {
        // Verification was successful
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Navbar()),
            );
          }
        });
      } else if (state.type == LivenessStateType.error) {
        // Handle error states like timeout or camera failure
        Future.delayed(const Duration(seconds: 2), () async {
          if (mounted) {
            setState(() {
              _status = 'Retrying...';
              _currentStateType = null;
            });
            await _detector.stop();
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              await _detector.start();
            }
          }
        });
      }
    });

    try {
      await _detector.initialize();
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
      await _detector.start();
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'Error initializing camera';
          _isInitializing = false;
        });
      }
    }
  }

  String _getStatusMessage(LivenessState state) {
    switch (state.type) {
      case LivenessStateType.initialized:
      case LivenessStateType.detecting:
        return 'Position your face in the circle';
      case LivenessStateType.noFace:
        return 'No face detected. Look at the camera';
      case LivenessStateType.faceDetected:
      case LivenessStateType.positioning:
        return 'Move your face to the center';
      case LivenessStateType.positioned:
        return 'Hold still...';
      case LivenessStateType.challengeInProgress:
        return state.currentChallenge?.instruction ?? 'Follow the instruction';
      case LivenessStateType.challengeCompleted:
        return 'Great! Processing next...';
      case LivenessStateType.completed:
        return 'Verification Successful!';
      case LivenessStateType.error:
        return state.error?.message ?? 'An error occurred';
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _detector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = _currentStateType == LivenessStateType.completed;
    final isError = _currentStateType == LivenessStateType.error;
    
    // Determine overlay color based on state
    Color overlayColor = Colors.transparent;
    if (isSuccess) {
      overlayColor = Colors.green.withOpacity(0.3);
    } else if (isError) {
      overlayColor = Colors.red.withOpacity(0.3);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Feed (Guaranteed no distortion)
          if (_isInitializing)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_detector.cameraController != null)
            Center(
              // Center allows CameraPreview to maintain its natural AspectRatio
              child: CameraPreview(_detector.cameraController!),
            )
          else
            const Center(child: Icon(Icons.camera_alt, color: Colors.white54, size: 50)),

          // 2. State Color Overlay
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: overlayColor,
          ),

          // 3. UI Overlay
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Liveness Check',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const Navbar()),
                          );
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Focus Guide (Just a visual box, doesn't clip the camera)
                Container(
                  width: 250,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSuccess ? Colors.green : (isError ? Colors.red : Colors.white54),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Dynamic Instruction Text
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _status,
                      key: ValueKey<String>(_status),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSuccess ? Colors.greenAccent : (isError ? Colors.redAccent : Colors.white),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Helpful tip
                Container(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: const Text(
                    'Ensure your face is clearly visible inside the frame.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
