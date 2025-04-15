import 'package:flutter/material.dart';
import 'package:nomad/screens/route_view/widgets/tabs/route_calender_view.dart';
import 'package:nomad/screens/route_view/widgets/tabs/route_itinerary_view.dart';
import 'package:nomad/screens/route_view/widgets/tabs/route_totals_view.dart';
import 'package:nomad/screens/route_view/widgets/route_view_app_bar.dart';
import 'package:nomad/widgets/generic/screen_scaffold.dart';


class RouteViewScreen extends StatefulWidget {
  const RouteViewScreen({super.key});

  @override
  State<RouteViewScreen> createState() => _RouteViewScreenState();
}

class _RouteViewScreenState extends State<RouteViewScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> tabNames = ['Itinerary', 'Totals', 'Calender'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     _tabController = TabController(
        length: tabNames.length,
        vsync: this
    );

    return ScreenScaffold(
      padding: EdgeInsets.zero,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          RouteViewAppBar()
        ],
        body: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: buildTabBar()
            ),
            Expanded(child: buildTabView())
          ],
        ),
      )
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      padding: EdgeInsets.zero,
      controller: _tabController,
      tabs: tabNames.map((name) =>
          Container(
            height: 30,
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Tab(
              text: name,
            ),
          ),
      ).toList(),
    );
  }

  TabBarView buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        RouteItineraryView(),
        RouteTotalsView(),
        RouteCalenderView()
      ]
    );
  }
}