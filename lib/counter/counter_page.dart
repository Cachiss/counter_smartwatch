import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/counter_cubit.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;
import 'package:toastification/toastification.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}

class CounterView extends StatefulWidget {
  CounterView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late final StreamSubscription<RotaryEvent> rotarySubscription;

  @override
  void initState() {
    super.initState();
    rotarySubscription = widget.rotaryEvents.listen(handleRotaryEvent);
  }

  @override
  void dispose() {
    rotarySubscription.cancel();
    super.dispose();
  }

  void handleRotaryEvent(RotaryEvent event) {
    final cubit = context.read<CounterCubit>();
    if (event.direction == RotaryDirection.clockwise) {
      cubit.increment();
    } else {
      cubit.decrement();
    }
  }

  void incrementCounter() {
    if (context.read<CounterCubit>().state + 1 > 10) {
      toastification.show(
        context: context,
        title: const Text(
          'El límite del contador es 10',
          style: TextStyle(fontSize: 10, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        animationDuration: const Duration(milliseconds: 200),
        style: ToastificationStyle.simple,
        backgroundColor: Colors.black,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    context.read<CounterCubit>().increment();
  }

  void decrementCounter() {
    if (context.read<CounterCubit>().state - 1 < -10) {
      toastification.show(
        context: context,
        title: const Text(
          'El límite del contador es -10',
          style: TextStyle(fontSize: 10, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        animationDuration: const Duration(milliseconds: 200),
        style: ToastificationStyle.simple,
        backgroundColor: Colors.black,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    context.read<CounterCubit>().decrement();
  }

  void resetCounter() {
    context.read<CounterCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Counter"),
                    IconButton(
                      onPressed: resetCounter,
                      icon: const Icon(Icons.restore),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: incrementCounter,
                child: const Icon(Icons.add),
              ),
              const SizedBox(
                height: 2,
              ),
              // Text(l10n.counterAppBarTitle),
              const CounterText(),
              const SizedBox(height: 2),
              ElevatedButton(
                onPressed: decrementCounter,
                child: const Icon(Icons.remove),
              ),
              /* 
              ElevatedButton(
                onPressed: () => context.read<CounterCubit>().reset(),
                child: const Icon(Icons.restore),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayMedium);
  }
}
