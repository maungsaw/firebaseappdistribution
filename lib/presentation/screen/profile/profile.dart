import 'package:firebaseappdistribution/data/dto/weather.dart';
import 'package:firebaseappdistribution/presentation/bloc/weather/weather.dart';
import 'package:firebaseappdistribution/presentation/screen/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        debugPrint('Current state -> $state');
        if (state is FailureWeatherState) {
          GlobalWidget.errorView(state.message);
        }
      },
      builder: (context, state) {
        // Handle UI based on current state
        if (state is LoadedWeatherState) {
          return GlobalWidget.loadingView();
        } else if (state is SuccessWeatherState) {
          return Center(
            child: state.data != null
                ? state.data!.current != null
                      ? Text(
                          "Temperature: ${state.data!.current!.temperature2m}°C",
                        )
                      : SizedBox.shrink()
                : SizedBox.shrink(),
          );
        } else if (state is FailureWeatherState) {
          return GlobalWidget.errorView(state.message);
        }

        return Center(
          child: OutlinedButton(
            onPressed: () {
              final params = WeatherParam(latitude: 52.52, longitude: 13.41);
              debugPrint("this is clicked");
              final bloc = context.read<WeatherBloc>();
              bloc.add(FetchWeatherEvent(param: params));
            },
            child: Text('Fetch'),
          ),
        );
      },
    );
  }
}
