import 'package:flutter_bloc/flutter_bloc.dart';

enum TabState { home, likes, search, profile }

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(TabState.home);

  void updateTab(TabState tabState) => emit(tabState);
}
