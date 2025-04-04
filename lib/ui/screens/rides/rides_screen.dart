import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/model/ride/ride.dart';
import 'package:week_3_blabla_project/ui/provider/rides_pref_provider.dart';
import 'package:week_3_blabla_project/service/rides_service.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  Future<void> onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // 1 - Update the ride preferences
  }

  Future<void> onPreferencePressed(BuildContext context) async {
    // Open a modal to edit the ride preferences
    final ridePreferenceProvider = context.read<RidesPrefProvider>();
    final currentPreference = ridePreferenceProvider.currentPreference;
    final RidePreference? newPreference =
        await Navigator.of(context).push(AnimationUtils.createBottomToTopRoute(
      RidePrefModal(
        initialPreference: currentPreference,
      ),
    ));

    if (newPreference != null) {
      // 1 - Update the current preference
      ridePreferenceProvider.setCurrentPreferrence(newPreference);
    }
  }

  void onFilterPressed() {}

  List<Ride> getAvailableRides(RidePreference preference) {
    return RidesService.instance.getRidesFor(preference, RideFilter());
  }

  @override
  Widget build(BuildContext context) {
    final ridePrefProvider = context.watch<RidesPrefProvider>();
    final currentPreference = ridePrefProvider.currentPreference;
    final matchingRides = getAvailableRides(currentPreference!);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
