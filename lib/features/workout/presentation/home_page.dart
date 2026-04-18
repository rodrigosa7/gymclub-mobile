import 'package:flutter/material.dart';

import '../../../core/api/gymclub_api_client.dart';
import 'app_controller.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/routines_tab.dart';
import 'tabs/active_workout_tab.dart';
import 'tabs/exercises_tab.dart';
import 'tabs/history_tab.dart';
import 'widgets/empty_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.apiBaseUrl,
    this.onLogout,
  });

  final AppController controller;
  final String apiBaseUrl;
  final void Function()? onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ActiveWorkoutTabState> _activeWorkoutKey = GlobalKey<ActiveWorkoutTabState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (widget.controller.isBootstrapping && widget.controller.currentUser == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (widget.controller.errorMessage != null && widget.controller.currentUser == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gym Club Test App')),
            body: EmptyState(
              title: 'Backend connection failed',
              description: widget.controller.errorMessage!,
              actionLabel: 'Retry',
              onPressed: () {
                widget.controller.initialize();
              },
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_titleForIndex(_selectedIndex)),
            actions: <Widget>[
              if (widget.onLogout != null)
                IconButton(
                  tooltip: 'Logout',
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout),
                ),
              if (_selectedIndex == 2)
                IconButton(
                  tooltip: 'Finish workout',
                  onPressed: () {
                    _activeWorkoutKey.currentState?.showFinishWorkoutSheet();
                  },
                  icon: const Icon(Icons.check_rounded),
                ),
            ],
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildBody(),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.repeat_outlined),
                selectedIcon: Icon(Icons.repeat_rounded),
                label: 'Routines',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Workout',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: 'Exercises',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'History',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardTab(
          key: const ValueKey<String>('dashboard'),
          controller: widget.controller,
          apiBaseUrl: widget.apiBaseUrl,
          onOpenWorkout: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          onOpenRoutines: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
      case 1:
        return RoutinesTab(
          key: const ValueKey<String>('routines'),
          controller: widget.controller,
          onStartWorkout: _handleStartWorkout,
        );
      case 2:
        return ActiveWorkoutTab(
          key: _activeWorkoutKey,
          controller: widget.controller,
          onCompleteWorkout: _handleCompleteWorkout,
          onOpenRoutines: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
      case 3:
        return ExercisesTab(
          key: const ValueKey<String>('exercises'),
          controller: widget.controller,
        );
      case 4:
        return HistoryTab(
          key: const ValueKey<String>('history'),
          controller: widget.controller,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleStartWorkout(String routineId) async {
    try {
      await widget.controller.startWorkoutFromRoutine(routineId);
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedIndex = 2;
      });
      _showSnack('Workout started.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      if (error is ApiException && error.statusCode == 409) {
        setState(() {
          _selectedIndex = 2;
        });
      }

      _showSnack(_messageForError(error));
    }
  }

  Future<void> _handleCompleteWorkout(DateTime? completedAt) async {
    try {
      await widget.controller.completeActiveWorkout(completedAt: completedAt);
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedIndex = 4;
      });
      _showSnack('Workout completed and moved into history.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(_messageForError(error));
    }
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Gym Club Dashboard';
      case 1:
        return 'Routines';
      case 2:
        return 'Active Workout';
      case 3:
        return 'Exercise Library';
      case 4:
        return 'Workout History';
      default:
        return 'Gym Club';
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _messageForError(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    if (error is StateError) {
      return error.message.toString();
    }

    return 'Something went wrong while talking to the backend.';
  }
}
