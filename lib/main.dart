import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verifyemail__view.dart';
//import 'package:path/path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      home: const HomePage(),
      routes: {
        Loginroute: (context) => const LoginView(),
        Registerroute: (context) => const RegisterView(),
        Notesroute: (context) => const NotesView(),
        verifyEmailroute: (context) => const verifyEmailView(),
        CreateOrUpdateNote: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),

//       builder: (context, asyncSnapshot) {
//         switch (asyncSnapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const verifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }

//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Test'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue = (state is CounterStateInvalidValue)
                ? state.invalidValue
                : '';
            return Column(
              children: [
                Text('Current value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalidValue,
                  child: Text('Invalid input: $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Please enter a number',
                  ),
                  keyboardType: TextInputType.number,
                ),

                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                          DecrementEvent(_controller.text),
                        );
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                          IncrementEvent(_controller.text),
                        );
                      },
                      child: const Text('+'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValidValue extends CounterState {
  const CounterStateValidValue(super.value);
}

class CounterStateInvalidValue extends CounterState {
  final String invalidValue;
  const CounterStateInvalidValue({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(super.value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValidValue(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidValue(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValidValue(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidValue(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValidValue(state.value - integer));
      }
    });
  }
}
