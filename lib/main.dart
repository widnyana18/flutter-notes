import 'package:flutter/material.dart';
import 'package:flutter_begineer/constants/routes.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/views/views.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        verifyEmailRoute: (context) => const VerifyEmailPage(),
        notesRoute: (context) => const NotesPage(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           final user = AuthService.firebase().currentUser;

//           if (user != null) {
//             if (user.isEmailVerified) {
//               return const NotesPage();
//             } else {
//               return const VerifyEmailPage();
//             }
//           } else {
//             return const LoginPage();
//           }
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing counter bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidVal =
                (state is CounterInvalidValue) ? state.invalidVal : '';
            return Column(
              children: [
                Text('Currrent Value => ${state.value}'),
                Visibility(
                  visible: state is CounterInvalidValue,
                  child: Text('Invalid value : $invalidVal'),
                ),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Input number'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(Decrement(_controller.text));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(Increment(_controller.text));
                      },
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

class CounterValidValue extends CounterState {
  const CounterValidValue(super.value);
}

class CounterInvalidValue extends CounterState {
  final String invalidVal;
  final int prevVal;

  const CounterInvalidValue({required this.invalidVal, required this.prevVal})
      : super(prevVal);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class Increment extends CounterEvent {
  const Increment(super.value);
}

class Decrement extends CounterEvent {
  const Decrement(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterValidValue(0)) {
    on<Increment>(
      (event, emit) {
        final value = int.tryParse(event.value);
        if (value == null) {
          emit(
            CounterInvalidValue(
              invalidVal: event.value,
              prevVal: state.value,
            ),
          );
        } else {
          emit(CounterValidValue(value + state.value));
        }
      },
    );

    on<Decrement>(
      (event, emit) {
        final value = int.tryParse(event.value);
        if (value == null) {
          emit(
            CounterInvalidValue(
              invalidVal: event.value,
              prevVal: state.value,
            ),
          );
        } else {
          emit(CounterValidValue(value - state.value));
        }
      },
    );
  }
}
