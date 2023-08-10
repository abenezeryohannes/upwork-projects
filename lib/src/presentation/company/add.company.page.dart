import 'package:dismissible_page/dismissible_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linko/injectable/getit.dart';
import 'package:linko/src/appcore/widgets/editable.tag.dart';
import 'package:linko/src/application/company/company.controller.dart';
import 'package:linko/src/infrastructure/company/dto/tag.dto.dart';
import '../../appcore/network/api.dart';
import '../../appcore/widgets/big.text.button.dart';
import '../../appcore/widgets/image.form.dart';
import '../../appcore/widgets/loading.bar.dart';
import '../../appcore/widgets/text.input.form.dart';
import '../privacy.bottom.sheet.dart';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({super.key});

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  late bool check = false;
  late CompanyController controller;

  @override
  void initState() {
    controller = getIt<CompanyController>();
    controller.findTags();
    controller.findUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
        onDismissed: () {
          Navigator.of(context).maybePop();
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        direction: DismissiblePageDismissDirection.down,
        isFullScreen: true,
        child: Scaffold(
            // appBar: ,
            body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Obx(() => LoadingBar(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 0),
                              show: controller.loading.value,
                            )),
                        _appBar(),
                        const SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 30),
                          child: ImageForm(
                            image: controller.dto.value.banner != null
                                ? Api.getMedia(controller.dto.value.banner!)
                                : null,
                            height: 130,
                            radius: 20,
                            placeholder: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/image_placeholder.png',
                                  width: 42,
                                  height: 42,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    tr('business_banner'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(),
                                  ),
                                )
                              ],
                            ),
                            width:
                                MediaQuery.of(context).size.width * (12 / 12),
                            isLoading: (bool val) {
                              setState(() {
                                controller.loading.value = val;
                              });
                            },
                            localImage: controller.dto.value.localImage,
                            onUpload: (String localImage) {
                              setState(() {
                                controller.dto.value.localImage = localImage;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 30, right: 30, bottom: 10),
                        //   child: EditableTag(
                        //     suggestions: controller.tags,
                        //     placeholder: 'Add Tags',
                        //     onSelected: (val) {
                        //       if (!controller.tagsDto
                        //           .contains(TagDto(name: val))) {
                        //         setState(() {
                        //           controller.tagsDto.add(TagDto(name: val));
                        //         });
                        //       }
                        //     },
                        //     searchOption: (val) {
                        //       controller.findTags(search: val);
                        //     },
                        //     tags:
                        //         controller.tagsDto.map((e) => e.name).toList(),
                        //     validator: (x) => (x == null || ((x.length) < 4))
                        //         ? 'Tag must be at least more th)atn 3 character'
                        //         : null,
                        //     onTagDelete: (tag) {
                        //       setState(() {
                        //         controller.tagsDto.removeWhere((element) =>
                        //             element.name
                        //                 .toLowerCase()
                        //                 .startsWith(tag.toLowerCase()));
                        //       });
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextInputForm(
                              placeholder: 'Business Link',
                              fillColor: Theme.of(context).cardColor,
                              radius: 100,
                              initialValue: controller.dto.value.name,
                              contentPadding: const EdgeInsets.only(
                                  left: 20, top: 14, bottom: 14, right: 10),
                              onChanged: (val) {
                                setState(() {
                                  controller.dto.value.url = val;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextInputForm(
                              placeholder: 'Business Name',
                              fillColor: Theme.of(context).cardColor,
                              radius: 100,
                              initialValue: controller.dto.value.name,
                              contentPadding: const EdgeInsets.only(
                                  left: 20, top: 14, bottom: 14, right: 10),
                              onChanged: (val) {
                                setState(() {
                                  controller.dto.value.name = val;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextInputForm(
                              placeholder: 'Business number',
                              fillColor: Theme.of(context).cardColor,
                              radius: 100,
                              contentPadding: const EdgeInsets.only(
                                  left: 20, top: 14, bottom: 14, right: 10),
                              onChanged: (val) {
                                setState(() {
                                  controller.dto.value.phoneNumber = val;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextInputForm(
                              placeholder: 'Owner Number',
                              fillColor: Theme.of(context).cardColor,
                              radius: 100,
                              initialValue: controller.dto.value.name,
                              contentPadding: const EdgeInsets.only(
                                  left: 20, top: 14, bottom: 14, right: 10),
                              onChanged: (val) {
                                setState(() {
                                  controller.dto.value.ownerPhoneNumber = val;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextInputForm(
                              placeholder: 'Delivery time',
                              fillColor: Theme.of(context).cardColor,
                              radius: 100,
                              contentPadding: const EdgeInsets.only(
                                  left: 20, top: 14, bottom: 14, right: 10),
                              onChanged: (val) {
                                setState(() {
                                  controller.dto.value.deliveryTime = val;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextInputForm(
                              placeholder: 'Delivery fees',
                              fillColor: Theme.of(context).cardColor,
                              radius: 100,
                              contentPadding: const EdgeInsets.only(
                                  left: 20, top: 14, bottom: 14, right: 10),
                              onChanged: (val) {
                                setState(() {
                                  controller.dto.value.deliveryFee = val;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 28.0,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                  value: check,
                                  fillColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.secondary),
                                  checkColor:
                                      Theme.of(context).colorScheme.secondary,
                                  side: BorderSide(
                                      width: 1.2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  onChanged: (val) {
                                    setState(() {
                                      check = !check;
                                    });
                                  }),
                              Text.rich(
                                TextSpan(
                                    text: 'I agree to the ',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      WidgetSpan(
                                          child: InkWell(
                                        onTap: () {
                                          context.pushTransparentRoute(
                                              const PrivacyBottomSheet());
                                        },
                                        child: Text('Terms & Privacy',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                )),
                                      ))
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30, bottom: 20, top: 30),
                  child: BigTextButton(
                    borderColor: Theme.of(context).colorScheme.secondary,
                    backgroudColor: Theme.of(context).colorScheme.secondary,
                    enabled: check,
                    onClick: () {
                      controller.save(
                          companyDto: controller.dto.value, context: context);
                    },
                    text: 'Save',
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    cornerRadius: 30,
                  ),
                )
              ],
            ),
          ),
        )));
  }

  AppBar _appBar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: RotatedBox(
          quarterTurns: 3,
          child: Icon(
            Icons.chevron_left,
            size: 42,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
      title: Text(
        'Add your business',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}