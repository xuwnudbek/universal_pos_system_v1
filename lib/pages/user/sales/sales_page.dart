// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:universal_pos_system_v1/data/local/app_database.dart';
// import 'package:universal_pos_system_v1/pages/user/sales/providers/sales_history/sales_history_provider.dart';
// import 'package:universal_pos_system_v1/pages/user/sales/providers/sale_provider.dart';
// import 'package:universal_pos_system_v1/pages/user/sales/providers/saved_carts/saved_carts_provider.dart';
// import 'package:universal_pos_system_v1/pages/user/sales/widgets/item_card.dart';
// import 'package:universal_pos_system_v1/utils/constants/size_consts.dart' show padd12;
// import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
// import 'package:universal_pos_system_v1/utils/router/app_router.dart';
// import 'package:universal_pos_system_v1/widgets/icon_button2.dart';

// class SalesPage extends StatelessWidget {
//   const SalesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//     final mq = MediaQuery.of(context);

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => SaleProvider()),
//         ChangeNotifierProvider(create: (context) => SavedCartsProvider()),
//         ChangeNotifierProvider(create: (context) => SalesHistoryProvider()),
//       ],
//       builder: (context, asyncSnapshot) {
//         return Material(
//           child: Row(
//             children: [
//               // Inner Sidebar
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     right: BorderSide(
//                       color: theme.dividerTheme.color ?? Colors.grey,
//                       width: theme.dividerTheme.thickness ?? 1,
//                     ),
//                   ),
//                 ),
//                 child: SizedBox(
//                   width: mq.size.width * 0.2,
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: theme.dividerTheme.color ?? Colors.grey,
//                               width: theme.dividerTheme.thickness ?? 0.5,
//                             ),
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Chek", style: theme.textTheme.titleMedium),
//                             Spacer(),
//                             Selector<SavedCartsProvider, List<Cart>>(
//                               selector: (context, provider) => provider.savedCarts,
//                               builder: (context, carts, _) {
//                                 int count = carts.length;

//                                 return Badge(
//                                   label: count > 0 ? Text(count.toString()) : null,
//                                   isLabelVisible: count > 0,
//                                   child: IconButton2(
//                                     onPressed: () {},
//                                     type: IconButton2Type.warning,
//                                     icon: LucideIcons.save,
//                                   ),
//                                 );
//                               },
//                             ),
//                             Selector<SaleHistoryProvider, List<SaleHistory>>(
//                               selector: (context, provider) => provider.saleHistories,
//                               builder: (context, saleHistories, _) {
//                                 int count = saleHistories.length;

//                                 return Badge(
//                                   label: count > 0 ? Text(count.toString()) : null,
//                                   isLabelVisible: count > 0,
//                                   child: IconButton2(
//                                     onPressed: () {},
//                                     type: IconButton2Type.info,
//                                     icon: LucideIcons.history,
//                                   ),
//                                 );
//                               },
//                             ),

//                             IconButton2(
//                               onPressed: () {
//                                 context.read<SaleProvider>().clearCart();
//                               },
//                               type: IconButton2Type.danger,
//                               icon: LucideIcons.trash2,
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Add sidebar items here
//                       Expanded(
//                         child: Selector<SaleProvider, Cart>(
//                           selector: (context, provider) => provider.cart,
//                           builder: (context, cart, _) {
//                             if (cart.items.isEmpty) {
//                               return Center(
//                                 child: Text(
//                                   'Savatcha bo\'sh',
//                                   style: textTheme.bodyMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
//                                   ),
//                                 ),
//                               );
//                             }

//                             return ListView.separated(
//                               padding: EdgeInsets.all(8.0),
//                               separatorBuilder: (_, _) => SizedBox(height: 4.0),
//                               itemCount: cart.cartItems.length,
//                               itemBuilder: (_, index) {
//                                 var cartItem = cart.cartItems[index];

//                                 return ListTile(
//                                   tileColor: theme.colorScheme.onSurface.withValues(alpha: .05),
//                                   title: Text(
//                                     cartItem.item.name,
//                                     style: theme.textTheme.titleMedium,
//                                   ),
//                                   subtitle: Text(
//                                     cartItem.totalPrice.toSum,
//                                     style: theme.textTheme.bodyMedium?.copyWith(
//                                       color: theme.colorScheme.onSurface,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     spacing: 8.0,
//                                     children: [
//                                       IconButton2(
//                                         onPressed: () {
//                                           context.read<SaleProvider>().decreaseCartItem(cartItem.item);
//                                         },
//                                         type: IconButton2Type.warning,
//                                         icon: LucideIcons.minus,
//                                       ),
//                                       SizedBox(
//                                         width: 24,
//                                         child: Center(
//                                           child: Text(
//                                             cartItem.quantity.toString(),
//                                             style: theme.textTheme.bodyMedium,
//                                           ),
//                                         ),
//                                       ),
//                                       IconButton2(
//                                         onPressed: () {
//                                           context.read<SaleProvider>().increaseCartItem(cartItem.item);
//                                         },
//                                         type: IconButton2Type.success,
//                                         icon: LucideIcons.plus,
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Divider(),
//                       // Total
//                       Padding(
//                         padding: EdgeInsets.all(padd12),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Jami:",
//                                   style: textTheme.titleMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Selector<SaleProvider, double>(
//                                   selector: (context, provider) => provider.cart.totalPrice,
//                                   builder: (context, totalPrice, _) {
//                                     return Text(
//                                       totalPrice.toSum,
//                                       style: textTheme.titleLarge?.copyWith(
//                                         color: theme.colorScheme.onSurface,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),

//                             Selector<SaleProvider, Cart>(
//                               selector: (context, provider) => provider.cart,
//                               builder: (context, cart, _) {
//                                 bool enabled = !cart.isEmpty;

//                                 return Row(
//                                   children: [
//                                     IconButton2(
//                                       type: IconButton2Type.primary,
//                                       icon: LucideIcons.save,
//                                       onPressed: enabled
//                                           ? () {
//                                               final cart = context.read<SaleProvider>().cart;
//                                               context.read<SavedCartsProvider>().addToSavedCarts(cart);
//                                               context.read<SaleProvider>().clearCart();
//                                             }
//                                           : null,
//                                     ),
//                                     SizedBox(width: 8),
//                                     Expanded(
//                                       child: SizedBox(
//                                         height: 36,
//                                         child: ElevatedButton(
//                                           onPressed: enabled
//                                               ? () {
//                                                   final cart = context.read<SaleProvider>().cart;
//                                                   context.read<SaleHistoryProvider>().addToSaleHistory(
//                                                     cart,
//                                                     0,
//                                                     SalingPaymentType.cash,
//                                                   );
//                                                   context.read<SaleProvider>().clearCart();
//                                                 }
//                                               : null,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Icon(LucideIcons.creditCard),
//                                               SizedBox(width: 8),
//                                               Text("To'lov"),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Main Content Area
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           IconButton2(
//                             onPressed: () {},
//                             type: IconButton2Type.primary,
//                             icon: LucideIcons.keyboard,
//                           ),
//                           SizedBox(width: 16),
//                           // Searchbar
//                           SizedBox(
//                             width: 300,
//                             child: Selector<SaleProvider, TextEditingController>(
//                               selector: (context, provider) => provider.searchController,
//                               builder: (context, controller, _) {
//                                 return TextFormField(
//                                   controller: controller,
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                     hintText: 'Search sales...',
//                                     prefixIcon: Icon(LucideIcons.search),
//                                     isDense: true,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           IconButton2(
//                             onPressed: () {
//                               appRouter.pushNamed(AppRoute.settings.name);
//                             },
//                             icon: LucideIcons.settings,
//                           ),
//                           SizedBox(width: 16),
//                           IconButton2(
//                             onPressed: () {
//                               appRouter.pushNamed(AppRoute.logout.name);
//                             },
//                             type: IconButton2Type.danger,
//                             icon: LucideIcons.logOut,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16.0),
//                       // Item Categories
//                       SizedBox(
//                         height: 40,
//                         child: Selector<SaleProvider, List<ItemCategory>>(
//                           selector: (context, provider) => provider.itemCategories,
//                           builder: (context, categories, _) {
//                             return Row(
//                               children: [
//                                 // "All" category
//                                 ChoiceChip(
//                                   showCheckmark: false,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 16.0,
//                                     vertical: 8.0,
//                                   ),
//                                   label: Text("Barchasi"),
//                                   selected: context.watch<SaleProvider>().selectedCategory == null,
//                                   onSelected: (bool selected) {
//                                     context.read<SaleProvider>().selectedCategory = null;
//                                   },
//                                 ),
//                                 SizedBox(width: 8.0),
//                                 ListView.separated(
//                                   shrinkWrap: true,
//                                   scrollDirection: Axis.horizontal,
//                                   separatorBuilder: (_, _) => SizedBox(width: 8.0),
//                                   itemCount: categories.length,
//                                   itemBuilder: (_, index) {
//                                     var category = categories[index];

//                                     return ChoiceChip(
//                                       showCheckmark: false,
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 16.0,
//                                         vertical: 8.0,
//                                       ),
//                                       label: Text(category.name),
//                                       selected: context.watch<SaleProvider>().selectedCategory?.id == category.id,
//                                       onSelected: (bool selected) {
//                                         context.read<SaleProvider>().selectedCategory = category;
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 8.0),
//                       Expanded(
//                         child: Selector<SaleProvider, List<Item>>(
//                           selector: (context, provider) => provider.items,
//                           builder: (context, items, _) {
//                             if (items.isEmpty) {
//                               return Center(
//                                 child: Text(
//                                   'Maxsulot topilmadi',
//                                   style: textTheme.bodyMedium?.copyWith(
//                                     color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
//                                   ),
//                                 ),
//                               );
//                             }

//                             return GridView.builder(
//                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 7,
//                                 crossAxisSpacing: 8.0,
//                                 mainAxisSpacing: 8.0,
//                                 childAspectRatio: 1 / 1.5,
//                               ),
//                               itemCount: items.length,
//                               itemBuilder: (_, index) {
//                                 var item = items[index];

//                                 return ItemCard(
//                                   item: item,
//                                   onTap: () {
//                                     context.read<SaleProvider>().increaseCartItem(item);
//                                   },
//                                   onSecondaryTap: () {
//                                     context.read<SaleProvider>().decreaseCartItem(item);
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
