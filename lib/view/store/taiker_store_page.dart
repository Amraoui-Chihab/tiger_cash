import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/controler/store_getx.dart';
import 'package:tigercashiraq/utl/colors.dart';
import 'package:tigercashiraq/view/store/add_product_page.dart';
import 'package:tigercashiraq/view/store/product_details_page.dart';
import 'package:tigercashiraq/view/store/my_itim.dart';

class TaikerStorePage extends StatelessWidget {
  const TaikerStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreController controller = Get.put(StoreController());
    final HomeController homeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تايكر ستور'),
        centerTitle: true,
        actions: [
          homeController.user.value.islimited == 0
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => const AddProductPage());
                      },
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => const MyItimPage());
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Row(
                  children:
                      List.generate(controller.categories.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              controller.selectedCategory.value == index
                                  ? Ccolors.secndry
                                  : Colors.grey.shade300,
                            ),
                          ),
                          onPressed: () {
                            controller.selectCategory(index);
                            controller.srtselcetedTipy(index);
                          },
                          child: Text(
                            controller.categories[index],
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    );
                  }),
                )),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.products.isEmpty) {
                  return const Center(child: Text("لا يوجد منتجات"));
                } else {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                          onPressed: () {
                            Get.to(() => ProductDetailsPage(
                                  product: controller.products[index],
                                ));
                          },
                          child: GridTile(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: controller.products[index].image!,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: SizedBox(
                                        // width: 70,
                                        // height: 70,
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Text(controller.products[index].name!),
                                Text(controller.products[index].price!),
                              ])),
                        );
                      });
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
