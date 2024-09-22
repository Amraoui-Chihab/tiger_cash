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
        backgroundColor: Color(0xFFD1E9F6),
        title: const Text('بابل ستور'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(controller.categories.length, (index) {
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    height: MediaQuery.of(context).size.height * 6 / 100,
                    width: (MediaQuery.of(context).size.width /
                            controller.categories.length) -
                        10,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          controller.selectedCategory.value == index
                              ? Ccolors.secndry
                              : Colors.grey.shade300,
                        ),
                      ),
                      onPressed: () {
                        controller.selectCategory(index);
                        controller.srtselcetedTipy(index);
                      },
                      child: FittedBox(
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("لا يوجد منتجات")),
                    SizedBox(width: 10,),
                    Image.asset("assets/trash.png",height: 40,)

                  ],
                );
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
                                index: index,
                              ));
                        },
                        child: GridTile(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Expanded(
                                child: Image.network(
                                   controller.products[index].image!,
                                  
                                ),
                              ),
                              Text("الإسم :" +controller.products[index].name!),
                              Text("الوصف : "+controller.products[index].description!),
                            int.parse(controller.products[index].month)!=0?  Text("أشهر التقسيط : "+controller.products[index].month!):Text("بدون تقسيط "),
                              Text("الكمية : "+controller.products[index].quntity!),
                              Text( "سعر الشراء بالدولار العراقي:"+controller.products[index].price! ,textDirection: TextDirection.rtl,),
                            ])),
                      );
                    });
              }
            }),
          )
        ],
      ),
    );
  }
}
