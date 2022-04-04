import 'dart:math';

import 'package:flutter/widgets.dart';

///
/// Renders a (user-scrollable) list of [children] with an animated "reel" effect on first load (think a slot machine).
/// The scroll animation will spin the list [iterations] times over the total [duration], decelerating to eventually stop at offset 0.
/// 
class Reel extends StatefulWidget {
  
  /// 
  /// The widgets that will be animated in a vertical ListView.
  /// 
  final List<Widget> children;

  /// 
  /// The number of times that the widget should animate from top to bottom before stopping.
  /// 
  final int iterations;
  
  ///
  /// The duration that will elapse before the spinning animation stops (i.e. velocity reaches zero).
  /// 
  final Duration duration;
  
  /// 
  /// The total height of the container. This is needed to calculate the correct deceleration parameters required for the given [iterations] and [duration].
  /// 
  final int height;

  const Reel({Key? key, required this.children, required this.iterations, required this.duration, required this.height}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _ReelState();

}

class _ReelState extends State<Reel> with SingleTickerProviderStateMixin {

  final _scrollController = ScrollController();
  late AnimationController _animationController;

  ///
  /// basic formulae:
  /// distance travelled at time t: D(t)
  /// velocity at time t: V(t) = v0 + at 
  /// since V(t) = d.D(t)/dt
  /// then D(t) = integral from zero to t of V(t)
  ///           = v0t + 1/2at^2 + C
  ///           = v0t + 1/2at^2 
  /// 
  /// now, we want to calculate the initial velocity v0 and acceleration a
  /// such that at time t_d, v is 0 and D(t) is the height of the widget list * num iterations
  /// For example, let's say t = 3, D(3) = 100, V(3) = 0
  /// then
  /// V(3) = v0 + at = 0
  /// v0 = -3a # -ta
  /// D(3)= 100 = v0t + 1/2at^2 = 3v0 + 9a/2
  /// v0 = (100 - 9a/2) / 3
  /// therefore
  /// -3a = (100 - 9a/2) / 3
  /// a = -(100 - 9a/2) / 9 
  /// 9a = 9a/2 - 100
  /// 18a = 9a - 200
  /// 9a = -200
  /// a = -200/9
  /// v0 = -3 * (-200/9) = 200/3
  late double v0;
  late double a;
  void calculateParams(double distance, double duration) {
    a = - (2 * distance) / duration;
    v0 = - (duration * a);
  }

  ///
  /// D(t) = (v0 * t) + 1/2 * a * t^2
  /// 
  double getOffset(double time) {
    return (v0 * time) + ((a * pow(time, 2)) / 2);
  }

  @override
  void initState() {
    super.initState();
    
    final distance = widget.height * widget.iterations;

    calculateParams(distance.toDouble(), widget.duration.inMilliseconds / 1000);

    _animationController = AnimationController(vsync: this, duration:widget.duration);
    _animationController.addListener(() {
        final offset = getOffset(_animationController.value * widget.duration.inMilliseconds / 1000);
        _scrollController.jumpTo(offset);
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _animationController.forward();  
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder:(ctx, idx) => widget.children[idx % widget.children.length]
      );
  }

}