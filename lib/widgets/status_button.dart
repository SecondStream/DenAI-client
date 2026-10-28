import 'package:den_ai/blocs/app_status/app_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusButton extends StatelessWidget {
  const StatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 55,
      height: 70,
      child: BlocBuilder<AppStatusBloc, AppStatusState>(
        builder: (context, state) {
          if (state is AppStatusSuccessState) {
            final available = state.providerAvailable;
            return Padding(
              padding: EdgeInsets.only(bottom: 17),
              child: IconButton(
                icon: Icon(
                  available ? Icons.check_circle : Icons.error,
                  color: available ? theme.colorScheme.primary : Color(0xFFCC5555),
                  size: 35,
                ),
                onPressed: () {
                  context.read<AppStatusBloc>().add(StatusCheckedEvent());
                },
              ),
            );
          }
          return Center(
            // <-- Вот этот парень заставит SizedBox работать
            child: SizedBox(
              width: 25,
              height: 40,
              child: CircularProgressIndicator(padding: EdgeInsets.only(bottom: 15)),
            ),
          );
        },
      ),
    );
  }
}
