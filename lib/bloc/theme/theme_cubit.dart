import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/app_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static bool _isChanged = false;
  ThemeCubit() : super(const ThemeState()) {
    initTheme();
  }

  void initTheme() async {
    if (await StorageTheme().get() == 'light') {
      emit(state.copyWith(theme: AppTheme.light));
      _isChanged = !_isChanged;
    } else {
      emit(state.copyWith(theme: AppTheme.dark));
    }
  }

  void switchTheme() async {
    emit(state.copyWith(theme: _isChanged ? AppTheme.dark : AppTheme.light));
    StorageTheme().set(_isChanged ? 'dark' : 'light');
    _isChanged = !_isChanged;
  }
}
