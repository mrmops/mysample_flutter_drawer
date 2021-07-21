/// Flutter code sample for AppBar

// This sample shows an [AppBar] with two simple actions. The first action
// opens a [SnackBar], while the second action navigates to a new page.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
          child: NavigationDrawer(
              ColoredBox(color: Colors.purpleAccent),
              onGenerateRoute,
              'Page 1',
              ['Page 1', 'Page 2', 'Page 3', 'Page 4', 'Page 5']),
        ));
  }

  Route? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => Text(settings.name!));
  }
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationLoadState());

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is ChangeNavigationTargetEvent) {
      yield NavigationTargetChangedState(event.targetRoute);
    }
  }
}

abstract class NavigationEvent {}

class ChangeNavigationTargetEvent extends NavigationEvent {
  final String targetRoute;

  ChangeNavigationTargetEvent(this.targetRoute);
}

abstract class NavigationState {}

class NavigationTargetChangedState extends NavigationState {
  final String targetRoute;

  NavigationTargetChangedState(this.targetRoute);
}

class NavigationLoadState extends NavigationState {}

class NeedNavigateState extends NavigationState {
  final String route;

  NeedNavigateState(this.route);

}

class NavigationDrawer extends StatefulWidget {
  final Widget child;

  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  final String initialRoute;

  final List<String> routeItems;

  NavigationDrawer(
      this.child, this.onGenerateRoute, this.initialRoute, this.routeItems);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: double.maxFinite,
          width: 305,
          child: ColoredBox(
            color: Colors.amber,
            child: NavigationItemsDrawer(widget.routeItems),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 70,
                child: ColoredBox(color: Colors.redAccent),
              ),
              Expanded(
                child: BlocListener<NavigationBloc, NavigationState>(
                  listener: (context, state){
                    if(state is NavigationTargetChangedState)
                      Navigator.pushNamed(context, state.targetRoute);
                  },
                  child: Navigator(
                    onGenerateRoute: (setting) {
                      return MyRoute(widget.onGenerateRoute!(setting));
                    },
                    initialRoute: widget.initialRoute,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MyRoute extends Route<dynamic> {

  
}

class NavigationItemsDrawer extends StatelessWidget {
  final List<String> routes;

  NavigationItemsDrawer(this.routes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: buildItem,
      itemCount: routes.length,
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return NavItem(routes[index]);
  }
}

class NavItem extends StatefulWidget {
  String route;

  NavItem(this.route);

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        Color color = Colors.indigoAccent;
        if (state is NavigationTargetChangedState) {
          if (state.targetRoute == widget.route) {
            color = Colors.greenAccent;
            selected = true;
          }
        }

        return GestureDetector(
          onTap: () {
            if (!selected)
              context.read<NavigationBloc>().add(ChangeNavigationTargetEvent(widget.route));
          },
          child: Card(
            child: ColoredBox(
              color: color,
              child: Text(getNameFromRoute(widget.route)),
            ),
          ),
        );
      },
    );
  }

  String getNameFromRoute(String route) {
    return 'eee';
  }
}
