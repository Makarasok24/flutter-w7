import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/ui/provider/rides_pref_provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference using the provider
    final ridePrefProvider = context.read<RidesPrefProvider>();
    ridePrefProvider.setCurrentPreferrence(newPreference);
    // 2 - Navigate to the rides screen (with a bottom-to-top animation)
    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(const RidesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ridePrefProvider = context.watch<RidesPrefProvider>();
    final currentRidePreference = ridePrefProvider.currentPreference;
    final pastPreferences = ridePrefProvider.pastPreferences;
    return Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            const SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 100),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2.1 Display the Form to input the ride preferences
                    RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (newPreference) =>
                          onRidePrefSelected(context, newPreference),
                    ),
                    const SizedBox(height: BlaSpacings.m),

                    // 2.2 Optionally display a list of past preferences
                    if (pastPreferences.state == AsyncValueState.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (pastPreferences.state == AsyncValueState.error)
                      Text('No connection. Please try again later.')
                    else
                      SizedBox(
                        height: 200, // Set a fixed height
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: pastPreferences.data?.length,
                          itemBuilder: (ctx, index) => RidePrefHistoryTile(
                            ridePref: pastPreferences.data![index],
                            onPressed: () => onRidePrefSelected(
                                context, pastPreferences.data![index]),
                          ),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
