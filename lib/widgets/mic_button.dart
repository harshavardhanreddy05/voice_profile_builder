
import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final bool listening;
  final VoidCallback onTap;

  const MicButton({
    Key? key,
    required this.listening,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listening) {
      _controller.repeat(reverse: true); 
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.listening ? _scaleAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: widget.listening
                    ? [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor:
                    widget.listening ? Colors.red : Colors.blue,
                child: Icon(
                  widget.listening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}