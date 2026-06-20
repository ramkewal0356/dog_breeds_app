// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../bloc/breeds_bloc.dart';
// import '../bloc/breeds_event.dart';

// class BreedFilterTabBar extends StatelessWidget {
//   const BreedFilterTabBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Builder(
//         builder: (context) {
//           return Container(
//             height: 52,
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               // color: Theme.of(context).colorScheme.surfaceContainerHighest,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: TabBar(
//               onTap: (index) {
//                 context.read<BreedsBloc>().add(FilterBreedsByTabEvent(index));
//               },
//               isScrollable: true,
//               tabAlignment: TabAlignment.start,
//               dividerColor: Colors.transparent,
//               indicatorSize: TabBarIndicatorSize.tab,

//               // splashBorderRadius: BorderRadius.circular(25),
//               labelPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 6,
//               ),

//               labelStyle: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),

//               unselectedLabelStyle: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),

//               labelColor: Theme.of(context).colorScheme.onPrimary,
//               unselectedLabelColor: Theme.of(
//                 context,
//               ).colorScheme.onSurfaceVariant,

//               indicator: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               tabs: const [
//                 Tab(text: 'All'),
//                 Tab(text: 'Hypoallergenic'),
//                 Tab(text: "Small"),
//                 Tab(text: "Medium"),
//                 Tab(text: "Large"),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:dog_breed_app/core/constants/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';

class BreedFilterTabBar extends StatelessWidget {
  const BreedFilterTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Builder(
        builder: (context) {
          return Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TabBar(
              onTap: (index) {
                context.read<BreedsBloc>().add(FilterBreedsByTabEvent(index));
              },
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 6),
              labelPadding: const EdgeInsets.symmetric(horizontal: 6),

              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,

              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),

              tabs: const [
                CustomTab(title: 'All'),
                CustomTab(title: 'Hypoallergenic'),
                CustomTab(title: 'Small'),
                CustomTab(title: 'Medium'),
                CustomTab(title: 'Large'),
              ],
            ),
          );
        },
      ),
    );
  }
}
