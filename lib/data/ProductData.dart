import 'dart:core';

import 'package:agriplant/generated/l10n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ProductData {
  static final Map<String, List<String>> agriCategories = {
    "منتوجات فلاحية": [
      "الفواكه",
      "الخضروات",
      "الحبوب",
      "المحاصيل الزيتية",
      "البقوليات",
      "النباتات العطرية و الطبية",
      "الأعلاف",
    ],
  };
  static Map<String, List<String>> agriCategoriesT(BuildContext context) => {
        S.of(context).agriculturalProducts: [
          S.of(context).fruits,
          S.of(context).vegetables,
          S.of(context).grains,
          S.of(context).oilCrops,
          S.of(context).legumes,
          S.of(context).medicinalPlants,
          S.of(context).fodder,
        ],
      };
  static final Map<String, List<String>> agriSubCategories = {
    "الفواكه": [
      "تفاح ",
      "برتقال ",
      "موز ",
      "عنب ",
      "فراولة ",
      "مانجو ",
      "كمثرى ",
      "كرز ",
      "بطيخ ",
      "شمام ",
      "كيوي ",
      "أناناس ",
      "رمان ",
      "تين ",
      "تمر ",
    ],
    "الخضروات": [
      "طماطم ",
      "جزر ",
      "بطاطا ",
      "فلفل ",
      "بصل ",
      "ثوم ",
      "خس ",
      "خيار ",
      "باذنجان ",
      "سبانخ",
      "ملفوف ",
      "فجل ",
      "شمندر ",
      "فاصوليا خضراء ",
      "كرفس ",
    ],
    "الحبوب": [
      "قمح ",
      "شعير ",
      "ذرة ",
      "أرز ",
      "سورغم ",
      "شوفان ",
      "جاودار ",
      "دخن ",
      "كينوا ",
    ],
    "المحاصيل الزيتية": [
      "زيتون ",
      "لوز ",
      "بندق ",
      "جوز ",
      "بذور عباد الشمس ",
      "بذور السمسم ",
      "بذور الكتان ",
      "بذور اللفت ",
      "فول سوداني ",
    ],
    "البقوليات": [
      "عدس ",
      "حمص ",
      "فاصوليا بيضاء ",
      "فول ",
      "بازلاء مجففة ",
      "فاصوليا حمراء ",
      "فول الصويا ",
    ],
    "النباتات العطرية و الطبية": [
      "نعناع ",
      "ريحان ",
      "زعتر ",
      "إكليل الجبل ",
      "بابونج ",
      "لافندر ",
      "مريمية ",
      "بقدونس ",
      "كزبرة ",
    ],
    "الأعلاف": [
      "برسيم ",
      "تبن ",
      "نفل ",
      "سيلاج الذرة ",
      "سورغم العلفي ",
    ],
  };
  static Map<String, List<String>> agriSubCategoriesT(BuildContext context) => {
        S.of(context).fruits: [
          S.of(context).apple,
          S.of(context).orange,
          S.of(context).banana,
          S.of(context).grape,
          S.of(context).strawberry,
          S.of(context).mango,
          S.of(context).pear,
          S.of(context).cherry,
          S.of(context).watermelon,
          S.of(context).cantaloupe,
          S.of(context).kiwi,
          S.of(context).pineapple,
          S.of(context).pomegranate,
          S.of(context).fig,
          S.of(context).date,
        ],
        S.of(context).vegetables: [
          S.of(context).tomato,
          S.of(context).carrot,
          S.of(context).potato,
          S.of(context).pepper,
          S.of(context).onion,
          S.of(context).garlic,
          S.of(context).lettuce,
          S.of(context).cucumber,
          S.of(context).eggplant,
          S.of(context).spinach,
          S.of(context).cabbage,
          S.of(context).radish,
          S.of(context).beet,
          S.of(context).greenBeans,
          S.of(context).celery,
        ],
        S.of(context).grains: [
          S.of(context).wheat,
          S.of(context).barley,
          S.of(context).corn,
          S.of(context).rice,
          S.of(context).sorghum,
          S.of(context).oats,
          S.of(context).rye,
          S.of(context).millet,
          S.of(context).quinoa,
        ],
        S.of(context).oilCrops: [
          S.of(context).olive,
          S.of(context).almond,
          S.of(context).hazelnut,
          S.of(context).walnut,
          S.of(context).sunflowerSeeds,
          S.of(context).sesameSeeds,
          S.of(context).flaxSeeds,
          S.of(context).rapeseeds,
          S.of(context).peanut,
        ],
        S.of(context).legumes: [
          S.of(context).lentil,
          S.of(context).chickpea,
          S.of(context).whiteBeans,
          S.of(context).broadBeans,
          S.of(context).driedPeas,
          S.of(context).redBeans,
          S.of(context).soybean,
        ],
        S.of(context).medicinalPlants: [
          S.of(context).mint,
          S.of(context).basil,
          S.of(context).thyme,
          S.of(context).rosemary,
          S.of(context).chamomile,
          S.of(context).lavender,
          S.of(context).sage,
          S.of(context).parsley,
          S.of(context).coriander,
        ],
        S.of(context).fodder: [
          S.of(context).alfalfa,
          S.of(context).straw,
          S.of(context).clover,
          S.of(context).cornSilage,
          S.of(context).fodderSorghum,
        ],
      };
  static final Map<String, List<String>> commercantCategories = {
    "معدات": [
      "المعدات الزراعية ",
      "معدات الري ",
      "معدات التخزين والتبريد",
      "معدات التعبئة والتغليف",
      "معدات وأدوات تربية المواشي"
    ],
    "أراضي": ["أرض صالحة للزراعة"],
  };

  static Map<String, List<String>> commercantCategoriesT(
          BuildContext context) =>
      {
        S.of(context).equipment: [
          S.of(context).agriculturalEquipment,
          S.of(context).irrigationEquipment,
          S.of(context).storageAndCooling,
          S.of(context).packagingEquipment,
          S.of(context).livestockTools
        ],
        S.of(context).lands: [S.of(context).landSuitableForAgriculture],
      };
  static final Map<String, List<String>> equipmentCategories = {
    "المعدات الزراعية": [
      "جرار زراعي",
      "آلة الحرث",
      "آلة الحصاد",
      "آلة البذر",
      "رشاش مبيدات",
      "محراث",
      "آلة جمع الأعلاف",
      "خزان ماء متنقل",
      "مضخة مياه",
      "آلة التسميد",
      "غربال حبوب",
      "مقطورة زراعية",
      "آلة قص الأعلاف",
      "آلة طحن الحبوب",
      "ناقلة الأعلاف",
      "آلة تسوية الأرض"
    ],
    "معدات الري": [
      "أنابيب الري",
      "رشاشات مياه",
      "مضخات غاطسة",
      "أنظمة الري بالتنقيط",
      "فلاتر مياه",
      "أجهزة تحكم في الري",
      "صمامات تحكم",
      "خزان مياه بلاستيكي"
    ],
    "معدات التخزين والتبريد": [
      "غرف تبريد",
      "ثلاجات صناعية",
      "وحدات تبريد متنقلة",
      "مبردات محمولة",
      "رفوف تخزين معدنية",
      "صناديق حفظ المحاصيل",
      "مستودعات معدنية جاهزة"
    ],
    "معدات التعبئة والتغليف": [
      "آلة تغليف بلاستيكي",
      "آلة تلصيق الملصقات",
      "موازين رقمية",
      "أكياس تعبئة محاصيل",
      "صناديق كرتونية",
      "آلة تعقيم التعبئة",
      "ميزان إلكتروني"
    ],
    "معدات وأدوات تربية المواشي": [
      "أقفاص وحظائر متنقلة",
      "معالف ومشارب أوتوماتيكية",
      "أجهزة الحلب اليدوية والكهربائية",
      "أدوات القص والتقليم (للحوافر والصوف)",
      "مستلزمات تدفئة الحظائر",
      "أنظمة تهوية وتحكم في الحرارة",
    ],
  };
  static Map<String, List<String>> equipmentCategoriesT(BuildContext context) =>
      {
        S.of(context).agriculturalEquipment: [
          S.of(context).tractor,
          S.of(context).plowMachine,
          S.of(context).harvester,
          S.of(context).seeder,
          S.of(context).pesticideSprayer,
          S.of(context).plow,
          S.of(context).forageHarvester,
          S.of(context).mobileWaterTank,
          S.of(context).waterPump,
          S.of(context).fertilizerSpreader,
          S.of(context).grainSieve,
          S.of(context).agriculturalTrailer,
          S.of(context).forageCutter,
          S.of(context).grainGrinder,
          S.of(context).forageConveyor,
          S.of(context).landLeveler,
        ],
        S.of(context).irrigationEquipment: [
          S.of(context).irrigationPipes,
          S.of(context).waterSprinklers,
          S.of(context).submersiblePumps,
          S.of(context).dripIrrigationSystems,
          S.of(context).waterFilters,
          S.of(context).irrigationControllers,
          S.of(context).controlValves,
          S.of(context).plasticWaterTank,
        ],
        S.of(context).storageAndCooling: [
          S.of(context).coldRoom,
          S.of(context).industrialFridge,
          S.of(context).mobileCoolingUnit,
          S.of(context).portableCooler,
          S.of(context).metalShelves,
          S.of(context).cropStorageBoxes,
          S.of(context).prefabWarehouse,
        ],
        S.of(context).packagingEquipment: [
          S.of(context).plasticWrappingMachine,
          S.of(context).labelingMachine,
          S.of(context).digitalScales,
          S.of(context).cropBags,
          S.of(context).cardboardBoxes,
          S.of(context).packingSterilizer,
          S.of(context).electronicScale,
        ],
        S.of(context).livestockTools: [
          S.of(context).portableCages,
          S.of(context).automaticFeeders,
          S.of(context).manualElectricMilking,
          S.of(context).hoofWoolTools,
          S.of(context).barnHeating,
          S.of(context).ventilationSystems,
        ],
      };
  static final Map<String, List<String>> produitsElevages = {
    "الحيوانات الحية": [
      "أبقار حلوب",
      "أبقار للتسمين",
      "عجول",
      "أغنام (خراف، نعاج)",
      "ماعز (جديان، إناث ماعز)",
      "جمال",
      "خيول",
      "دواجن (دجاج، بط، ديك رومي)",
      "أرانب",
    ],
    "منتجات الألبان ومشتقاتها": [
      "الحليب الطازج (بقري، ماعز، غنم)",
      "الجبن (بلدي، موزاريلا، شيدر)",
      "الزبدة الطبيعية",
      "الياغورت الطبيعي",
      "القشطة",
      "اللبن الرائب",
    ],
    "المنتجات المشتقة من الحيوانات": [
      "الصوف الخام",
      "الجلود الطبيعية (بقر، غنم، ماعز)",
      "العسل الطبيعي",
      "شمع النحل",
      "البيض (بلدي، مزارع)",
      "السماد الطبيعي العضوي",
    ],
  };
  static Map<String, List<String>> produitsElevagesT(BuildContext context) => {
        S.of(context).liveAnimals: [
          S.of(context).dairyCows,
          S.of(context).beefCattle,
          S.of(context).calves,
          S.of(context).sheepGoats,
          S.of(context).goats,
          S.of(context).camels,
          S.of(context).horses,
          S.of(context).poultry,
          S.of(context).rabbits,
        ],
        S.of(context).dairyProducts: [
          S.of(context).freshMilk,
          S.of(context).cheese,
          S.of(context).butter,
          S.of(context).yogurt,
          S.of(context).cream,
          S.of(context).labanRaiib,
        ],
        S.of(context).animalByproducts: [
          S.of(context).rawWool,
          S.of(context).naturalLeather,
          S.of(context).honey,
          S.of(context).beeswax,
          S.of(context).eggs,
          S.of(context).organicFertilizer,
        ],
      };

  static final Map<String, List<String>> ExpertProducts = {
    "استشارات الزراعة": [
      "استشارات في الزراعة العضوية",
      "استشارات في الزراعة المستدامة",
      "تحليل التربة",
      "تحليل المياه",
    ],
    "خدمات التوعية والتدريب": [
      " حول تقنيات الزراعة الحديثة",
      "ورش العمل الزراعية",
    ],
    "التكنولوجيا الزراعية": [
      "استشارات في استخدام التكنولوجيا الزراعية",
      "تطبيقات الزراعة الذكية "
    ],
    "خدمات توجيهية للمزارعين": [
      "خطط الزراعة الخاصة بالمزارع",
      "إدارة المحاصيل بشكل فعال",
    ],
    "مراقبة صحة النباتات والحيوانات": [
      "مراقبة الأمراض والآفات الزراعية",
      "الوقاية والتغذية المناسبة للمحاصيل ",
    ],
    "الاستشارات المالية والإدارية": [
      "استشارات في التمويل الزراعي",
      "استشارات في إدارة المزارع",
    ],
  };
  static Map<String, List<String>> ExpertProductsT(BuildContext context) => {
        S.of(context).agricultureConsulting: [
          S.of(context).organicFarmingConsulting,
          S.of(context).sustainableFarmingConsulting,
          S.of(context).soilAnalysis,
          S.of(context).waterAnalysis,
        ],
        S.of(context).trainingServices: [
          S.of(context).modernFarmingTechniques,
          S.of(context).agricultureWorkshops,
        ],
        S.of(context).agriTech: [
          S.of(context).agriTechConsulting,
          S.of(context).smartFarmingApps,
        ],
        S.of(context).farmerGuidance: [
          S.of(context).personalFarmingPlans,
          S.of(context).cropManagement,
        ],
        S.of(context).plantAnimalHealth: [
          S.of(context).diseasePestMonitoring,
          S.of(context).cropProtection,
        ],
        S.of(context).financeAdminConsulting: [
          S.of(context).agriFinanceConsulting,
          S.of(context).farmManagementConsulting,
        ],
      };

  static final List<String> ReparationType = [
    "إصلاح المعدات الزراعية",
    "إصلاح الآلات الثقيلة",
    "إصلاح أنظمة الري",
    "صيانة المنشآت",
    "إصلاح المعدات الكهربائية"
  ];
  static List<String> reparationTypeT(BuildContext context) => [
        S.of(context).agriEquipmentRepair,
        S.of(context).heavyMachineryRepair,
        S.of(context).irrigationSystemRepair,
        S.of(context).facilityMaintenance,
        S.of(context).electricalEquipmentRepair,
      ];

  static final List<String> moyensDeTransport = [
    "شاحنة صغيرة",
    "شاحنة كبيرة",
    "شاحنة مبردة",
  ];
  static List<String> moyensDeTransportT(BuildContext context) => [
        S.of(context).smallTruck,
        S.of(context).largeTruck,
        S.of(context).refrigeratedTruck,
      ];
  static Map<String, List<String>> WorkerTasks = {
    "العمليات الزراعية اليومية": [
      "زراعة وريّ النباتات ",
      "تنقية الأعشاب وتقليم النباتات",
      "تنظيف وتجميع بقايا المحاصيل"
    ],
    "أعمال الحصاد الموسمي": [
      "جمع المحاصيل والثمار الموسمية",
      "قطف الخضروات والفواكه الناضجة",
      "فرز وتغليف المنتجات بعد الحصاد"
    ],
    "تهيئة الأرض للزراعة": [
      "حرث وتسوية التربة",
      "إزالة العوائق الطبيعية",
      "نشر السماد وتحضير خطوط الزراعة"
    ],
    "البناء الزراعي التقليدي": [
      "بناء الآبار اليدوية",
      "حفر قنوات الري",
      "إقامة الحواجز والأسوار البسيطة"
    ],
    "الدعم والمساعدة": [
      "حراسة ومراقبة المزرعة على مدار الساعة",
      "مساعدة الفلاح في مختلف الأعمال اليومية",
      "تنظيف وترتيب محيط العمل الزراعي"
    ]
  };
  static Map<String, List<String>> WorkerTasksT(BuildContext context) => {
        S.of(context).dailyFarmOperations: [
          S.of(context).plantingAndWatering,
          S.of(context).weedingAndPruning,
          S.of(context).cleaningAndCollecting
        ],
        S.of(context).seasonalHarvesting: [
          S.of(context).harvestingCrops,
          S.of(context).pickingVegetablesAndFruits,
          S.of(context).sortingAndPackaging
        ],
        S.of(context).landPreparation: [
          S.of(context).plowingAndLeveling,
          S.of(context).removingObstacles,
          S.of(context).fertilizingAndLining
        ],
        S.of(context).traditionalFarmConstruction: [
          S.of(context).buildingWells,
          S.of(context).diggingIrrigation,
          S.of(context).buildingBarriers
        ],
        S.of(context).supportAndAssistance: [
          S.of(context).guardingAndMonitoring,
          S.of(context).helpingFarmer,
          S.of(context).cleaningFarmArea
        ]
      };

  static Map<String, Map<String, List<String>>> productTypeCategories(
      BuildContext context) {
    return {
      "منتج زراعي": agriCategoriesT(context),
      "منتج حيواني": produitsElevagesT(context),
      "منتج تجاري": commercantCategoriesT(context),
    };
  }

  static Map<String, Map<String, List<String>>> productTypeCategoriesT(
      BuildContext context) {
    return {
      S.of(context).agriculturalProduct: agriCategoriesT(context),
      S.of(context).animalProduct: produitsElevagesT(context),
      S.of(context).commercialProduct: commercantCategoriesT(context),
    };
  }

  static Map<String, Map<String, List<String>>> subCategoryDetails(
          BuildContext context) =>
      {
        "منتج زراعي": {
          ...agriSubCategoriesT(context),
        },
        "منتج تجاري": {
          ...equipmentCategoriesT(context),
        },
        "منتج حيواني": {...produitsElevagesT(context)},
        "الخبرة": {...ExpertProductsT(context)},
      };
  static Map<String, Map<String, List<String>>> subCategoryDetailsT(
          BuildContext context) =>
      {
        S.of(context).agriculturalProduct: {
          ...agriSubCategoriesT(context),
        },
        S.of(context).commercialProduct: {
          ...equipmentCategoriesT(context),
        },
        S.of(context).animalProduct: {
          ...produitsElevagesT(context),
        },
        S.of(context).expertise: {
          ...ExpertProductsT(context),
        },
      };
  static final Map<String, List<String>> wilayas = {
    "01 - أدرار": [
      "أدرار",
      "أولف",
      "أوقروت",
      "برج باجي مختار",
      "شروين",
      "فنوغيل",
      "رقان",
      "تيميمون",
      "تينركوك",
      "تسابيت",
      "زاوية كنتة"
    ],
    "02 - الشلف": [
      "أبو الحسن",
      "عين مران",
      "بني حواء",
      "بوقادير",
      "الشلف",
      "الكريمية",
      "المرسى",
      "وادي الفضة",
      "أولاد بن عبد القادر",
      "أولاد فارس",
      "تاوقريت",
      "تنس",
      "الزبوجة",
    ],
    "03 - الأغواط": [
      "آفلو",
      "عين ماضي",
      "بريدة",
      "الغيشة",
      "قلتة سيدي سعد",
      "حاسي الرمل",
      "قصر الحيران",
      "الأغواط",
      "وادي مرة",
      "سيدي مخلوف"
    ],
    "04 - أم البواقي": [
      "أم البواقي",
      "عين بابوش",
      "قصر الصباحي",
      "عين البيضاء",
      "فكيرينة",
      "عين مليلة",
      "سوق نعمان",
      "عين فكرون",
      "سيقوس",
      "عين كرشة",
      "مسكيانة",
      "الضلعة",
    ],
    "05 - باتنة": [
      "عين جاسر",
      "عين التوتة",
      "أريس",
      "بريكة",
      "باتنة",
      "بوزينة",
      "الشمرة",
      "الجزار",
      "المعذر",
      "إشمول",
      "منعة",
      "مروانة",
      "نقاوس",
      "أولاد سي سليمان",
      "رأس العيون",
      "سقانة",
      "سريانة",
      "تازولت",
      "ثنية العابد",
      "تيمقاد",
      "تكوت"
    ],
    "06 - بجاية": [
      "أدكار",
      "أقبو",
      "أميزور",
      "أوقاس",
      "برباشة",
      "بجاية",
      "بني معوش",
      "شميني",
      "درقينة",
      "القصر",
      "إغيل علي",
      "خراطة",
      "أوزلاقن",
      "صدوق",
      "سيدي عيش",
      "سوق الإثنين",
      "تازمالت",
      "تيشي",
      "تيمزريت"
    ],
    "07 - بسكرة": [
      "بسكرة",
      "جمورة",
      "القنطرة",
      "مشونش",
      "سيدي عقبة",
      "زريبة الوادي",
      "أورلال",
      "طولقة",
      "أولاد جلال",
      "سيدي خالد",
      "فوغالة",
      "الوطاية"
    ],
    "08 - بشار": [
      "بشار",
      "بني ونيف",
      "لحمر",
      "القنادسة",
      "تاغيت",
      "العبادلة",
      "تبلبالة",
      "إقلي",
      "بني عباس",
      "الواتة",
      "كرزاز",
      "أولاد خضير"
    ],
    "09 - البليدة": [
      "البليدة",
      "بوفاريك",
      "بوقرة",
      "بوعينان",
      "العفرون",
      "الأربعاء",
      "مفتاح",
      "موزاية",
      "وادي العلايق",
      "أولاد يعيش"
    ],
    "10 - البويرة": [
      "البويرة",
      "حيزر",
      "بشلول",
      "الأسنام",
      "القادرية",
      "الأخضرية",
      "بئر غبالو",
      "عين بسام",
      "سوق الخميس",
      "الهاشمية",
      "سور الغزلان",
      "برج أوخريص"
    ],
    "11 - تمنراست": [
      "أبلسة",
      "إن غار",
      "إن قزام",
      "عين صالح",
      "تمنراست",
      "تازروك",
      "تين زواتين"
    ],
    "12 - تبسة": [
      "تبسة",
      "الكويف",
      "مرسط",
      "الماء الأبيض",
      "العوينات",
      "الونزة",
      "بئر مقدم",
      "بئر العاتر",
      "العقلة",
      "أم علي",
      "نقرين",
      "الشريعة"
    ],
    "13 - تلمسان": [
      "عين تالوت",
      "باب العسة",
      "بني بوسعيد",
      "بني سنوس",
      "بن سكران",
      "شتوان",
      "العريشة",
      "فلاوسن",
      "الغزوات",
      "الحناية",
      "هنين",
      "مغنية",
      "منصورة",
      "مرسى بن مهيدي",
      "ندرومة",
      "أولاد ميمون",
      "الرمشي",
      "صبرة",
      "سبدو",
      "سيدي الجيلالي",
      "تلمسان"
    ],
    "14 - تيارت": [
      "تيارت",
      "السوقر",
      "عين الذهب",
      "عين كرمس",
      "فرندة",
      "دحموني",
      "مهدية",
      "حمادية",
      "قصر الشلالة",
      "مدروسة",
      "مشرع الصفاء",
      "الرحوية",
      "واد ليلي",
      "مغيلة"
    ],
    "15 - تيزي وزو": [
      "عين الحمام",
      "عزازقة",
      "أزفون",
      "بني دوالة",
      "بني يني",
      "بوغني",
      "بوزقن",
      "ذراع بن خدة",
      "ذراع الميزان",
      "إفرحونن",
      "الأربعاء ناث إيراثن",
      "ماكودة",
      "معاتقة",
      "مقلع",
      "واسيف",
      "واضية",
      "واقنون",
      "تيقزيرت",
      "تيزي غنيف",
      "تيزي وزو",
      "تيزي راشد"
    ],
    "16 - الجزائر": [
      "زرالدة",
      "الشراقة",
      "الدرارية",
      "بئر مراد رايس",
      "بئر توتة",
      "بوزريعة",
      "باب الوادي",
      "سيدي امحمد",
      "حسين داي",
      "الحراش",
      "براقي",
      "الدار البيضاء",
      "الرويبة"
    ],
    "17 - الجلفة": [
      "عين الإبل",
      "عين وسارة",
      "بيرين",
      "الشارف",
      "دار الشيوخ",
      "الجلفة",
      "الإدريسية",
      "فيض البطمة",
      "حد الصحاري",
      "حاسي بحبح",
      "سيدي لعجال",
      "مسعد"
    ],
    "18 - جيجل": [
      "الشقفة",
      "جيملة",
      "العنصر",
      "العوانة",
      "الميلية",
      "جيجل",
      "السطارة",
      "سيدي معروف",
      "الطاهير",
      "تكسنة",
      "زيامة منصورية"
    ],
    "19 - سطيف": [
      "عين أرنات",
      "عين آزال",
      "عين الكبيرة",
      "عين ولمان",
      "عموشة",
      "بابور",
      "بني عزيز",
      "بني ورتيلان",
      "بئر العرش",
      "بوعنداس",
      "بوقاعة",
      "جميلة",
      "العلمة",
      "قجال",
      "قنزات",
      "حمام قرقور",
      "حمام السخنة",
      "ماوكلان",
      "صالح باي",
      "سطيف"
    ],
    "20 - سعيدة": [
      "سعيدة",
      "عين الحجر",
      "سيدي بوبكر",
      "الحساسنة",
      "أولاد إبراهيم",
      "يوب",
    ],
    "21 - سكيكدة": [
      "عزابة",
      "عين قشرة",
      "بن عزوز",
      "القل",
      "الحدائق",
      "الحروش",
      "أولاد عطية",
      "أم الطوب",
      "رمضان جمال",
      "سيدي مزغيش",
      "سكيكدة",
      "تمالوس",
      "الزيتونة"
    ],
    "22 - سيدي بلعباس": [
      "سيدي بلعباس",
      "عين البرد",
      "بن باديس",
      "مرحوم",
      "مرين",
      "مصطفى بن إبراهيم",
      "مولاي سليسن",
      "رأس الماء",
      "سفيزف",
      "سيدي علي بن يوب",
      "سيدي علي بوسيدي",
      "سيدي لحسن",
      "تلاغ",
      "تنيرة",
      "تسالة"
    ],
    "23 - عنابة": [
      "عنابة",
      "عين الباردة",
      "الحجار",
      "برحال",
      "شطايبي",
      "البوني",
    ],
    "24 - قالمة": [
      "عين مخلوف",
      "بوشقوف",
      "قلعة بوصبع",
      "قالمة",
      "حمام دباغ",
      "حمام النبايل",
      "هيليوبوليس",
      "هواري بومدين",
      "خزارة",
      "وادي الزناتي"
    ],
    "25 - قسنطينة": [
      "قسنطينة",
      "الخروب",
      "عين عبيد",
      "زيغود يوسف",
      "حامة بوزيان",
      "ابن زياد"
    ],
    "26 - المدية": [
      "عين بوسيف",
      "عزيز",
      "بني سليمان",
      "البرواقية",
      "شهبونية",
      "شلالة العذاورة",
      "العزيزية",
      "القلب الكبير",
      "العمارية",
      "قصر البخاري",
      "المدية",
      "وامري",
      "أولاد عنتر",
      "وزرة",
      "سغوان",
      "سيدي نعمان",
      "سي المحجوب",
      "السواقي",
      "تابلاط"
    ],
    "27 - مستغانم": [
      "عشعاشة",
      "عين النويصي",
      "عين تادلس",
      "بوقيراط",
      "حاسي ماماش",
      "خير الدين",
      "ماسرة",
      "مستغانم",
      "سيدي علي",
      "سيدي لخضر"
    ],
    "28 - المسيلة": [
      "المسيلة",
      "حمام الضلعة",
      "أولاد دراج",
      "سيدي عيسى",
      "عين الملح",
      "بن سرور",
      "بوسعادة",
      "أولاد سيدي إبراهيم",
      "سيدي عامر",
      "مقرة",
      "شلال",
      "خبانة",
      "مجدل",
      "عين الحجل",
      "جبل مساعد"
    ],
    "29 - معسكر": [
      "عين فارس",
      "عين فكان",
      "عوف",
      "بوحنيفية",
      "البرج",
      "غريس",
      "الهاشم",
      "معسكر",
      "المحمدية",
      "عقاز",
      "وادي الأبطال",
      "وادي التاغية",
      "سيق",
      "تيغنيف",
      "تيزي",
      "زهانة",
    ],
    "30 - ورقلة": [
      "البرمة",
      "الحجيرة",
      "حاسي مسعود",
      "المقارين",
      "نقوسة",
      "ورقلة",
      "سيدي خويلد",
      "الطيبات",
      "تماسين",
      "تقرت",
    ],
    "31 - وهران": [
      "وهران",
      "عين الترك",
      "أرزيو",
      "بطيوة",
      "السانية",
      "بئر الجير",
      "بوتليليس",
      "وادي تليلات",
      "قديل"
    ],
    "32 - البيض": [
      "البيض",
      "رقاصة",
      "بريزينة",
      "الأبيض سيدي الشيخ",
      "بوقطب",
      "شلالة",
      "بوسمغون",
      "بوعلام"
    ],
    "33 - إليزي": ["إليزي", "جانت", "إن أميناس"],
    "34 - برج بوعريريج": [
      "برج بوعريريج",
      "عين تاغروت",
      "رأس الوادي",
      "برج الغدير",
      "بئر قاصد علي",
      "الحمادية",
      "منصورة",
      "مجانة",
      "برج زمورة",
      "جعافرة"
    ],
    "35 - بومرداس": [
      "بغلية",
      "بودواو",
      "برج منايل",
      "بومرداس",
      "دلس",
      "خميس الخشنة",
      "يسر",
      "الناصرية",
      "الثنية"
    ],
    "36 - الطارف": [
      "الطارف",
      "القالة",
      "بن مهيدي",
      "بسباس",
      "الذرعان",
      "بوحجار",
      "بوثلجة",
    ],
    "37 - تندوف": ["تندوف"],
    "38 - تيسمسيلت": [
      "عماري",
      "برج بونعامة",
      "برج الأمير عبد القادر",
      "خميستي",
      "لرجام",
      "الأزهرية",
      "ثنية الحد",
      "تيسمسيلت",
    ],
    "39 - الوادي": [
      "البياضة",
      "الدبيلة",
      "الوادي",
      "قمار",
      "حاسي خليفة",
      "المقرن",
      "اميه ونسة",
      "الرقيبة",
      "الرباح",
      "الطالب العربي"
    ],
    "40 - خنشلة": [
      "خنشلة",
      "بابار",
      "بوحمامة",
      "ششار",
      "الحامة",
      "قايس",
      "أولاد رشاش",
      "عين الطويلة",
    ],
    "41 - سوق أهراس": [
      "بئر بوحوش",
      "الحدادة",
      "مداوروش",
      "مشروحة",
      "المراهنة",
      "أولاد إدريس",
      "أم العظايم",
      "سدراتة",
      "سوق أهراس",
      "تاورة"
    ],
    "42 - تيبازة": [
      "أحمر العين",
      "بواسماعيل",
      "شرشال",
      "الداموس",
      "فوكة",
      "قوراية",
      "حجوط",
      "القليعة",
      "سيدي عمر",
      "تيبازة",
    ],
    "43 - ميلة": [
      "ميلة",
      "شلغوم العيد",
      "فرجيوة",
      "قرارم قوقة",
      "وادي النجاء",
      "الرواشد",
      "ترعي باينان",
      "تسدان حدادة",
      "عين البيضاء أحريش",
      "سيدي مروان",
      "تلاغمة",
      "بوحاتم",
      "تاجنانت"
    ],
    "44 - عين الدفلى": [
      "عين الدفلى",
      "عين الشيخ",
      "بطحية",
      "برج الأمير خالد",
      "بومدفع",
      "جليدة",
      "جندل",
      "العبادية",
      "العامرة",
      "العطاف",
      "حمام ريغة",
      "خميس مليانة",
      "مليانة",
      "روينة"
    ],
    "45 - النعامة": [
      "النعامة",
      "عين الصفراء",
      "عسلة",
      "مكمن بن عمار",
      "المشرية",
      "مغرار",
      "صفيصيفة",
    ],
    "46 - عين تموشنت": [
      "عين الأربعاء",
      "عين الكيحل",
      "عين تموشنت",
      "بني صاف",
      "العامرية",
      "المالح",
      "حمام بوحجر",
      "ولهاصة الغرابة"
    ],
    "47 - غرداية": [
      "غرداية",
      "المنيعة",
      "متليلي",
      "بريان",
      "ضاية بن ضحوة",
      "منصورة",
      "زلفانة",
      "القرارة",
      "بونورة"
    ],
    "48 - غليزان": [
      "عين طارق",
      "عمي موسى",
      "جديوية",
      "الحمادنة",
      "المطمر",
      "مازونة",
      "منداس",
      "وادي رهيو",
      "رمكة",
      "غليزان",
      "سيدي محمد بن علي",
      "يلل",
      "زمورة"
    ],
    "49 - تيميمون": [
      "تيميمون",
      "أوقروت",
      "تينركوك",
      "شروين",
    ],
    "50 - برج باجي مختار": ["برج باجي مختار"],
    "51 - أولاد جلال": [
      "أولاد جلال",
      "سيدي خالد",
    ],
    "52 - بني عباس": [
      "بني عباس",
      "كرزاز",
      "الواتة",
      "تبلبالة",
      "إقلي",
      "أولاد خضير",
      "تيمودي",
    ],
    "53 - عين صالح": ["عين صالح", "إن غار"],
    "54 - إن قزام": ["إن قزام", "تين زواتين"],
    "55 - تقرت": ["الحجيرة", "المقارين", "الطيبات", "تماسين", "تقرت"],
    "56 - جانت": ["جانت"],
    "57 - المغير": ["المغير", "جامعة"],
    "58 - المنيعة": ["المنيعة"]
  };
  static Map<String, List<String>> wilayasT(BuildContext context) => {
        S.of(context).wilaya01: [
          S.of(context).adrar,
          S.of(context).aoulef,
          S.of(context).aougrout,
          S.of(context).bordjBadjiMokhtar,
          S.of(context).charouine,
          S.of(context).fenoughil,
          S.of(context).reggane,
          S.of(context).timimoun,
          S.of(context).tinerkouk,
          S.of(context).tsabit,
          S.of(context).zaouietKounta,
        ],
        S.of(context).wilaya02: [
          S.of(context).abouElHassan,
          S.of(context).ainMerane,
          S.of(context).beniHaoua,
          S.of(context).boukadir,
          S.of(context).chlef,
          S.of(context).elKarimia,
          S.of(context).elMarsa,
          S.of(context).ouedFodda,
          S.of(context).ouledBenAbdelkader,
          S.of(context).ouledFares,
          S.of(context).taougrit,
          S.of(context).tenes,
          S.of(context).zeboudja,
        ],
        S.of(context).wilaya03: [
          S.of(context).aflou,
          S.of(context).ainMadhi,
          S.of(context).brida,
          S.of(context).elGhicha,
          S.of(context).gueltetSidiSaad,
          S.of(context).hassiRMel,
          S.of(context).ksarElHirane,
          S.of(context).laghouat,
          S.of(context).ouedMorra,
          S.of(context).sidiMakhlouf,
        ],
        S.of(context).wilaya04: [
          S.of(context).oumElBouaghi,
          S.of(context).ainBabouche,
          S.of(context).ksarSbahi,
          S.of(context).ainBeida,
          S.of(context).fkirina,
          S.of(context).ainMlila,
          S.of(context).soukNaamane,
          S.of(context).ainFakroun,
          S.of(context).sigus,
          S.of(context).ainKercha,
          S.of(context).meskiana,
          S.of(context).dhalaa,
        ],
        S.of(context).wilaya05: [
          S.of(context).ainDjasser,
          S.of(context).ainTouta,
          S.of(context).arris,
          S.of(context).barika,
          S.of(context).batna,
          S.of(context).bouzina,
          S.of(context).chemora,
          S.of(context).djezzar,
          S.of(context).elMadher,
          S.of(context).ichmoul,
          S.of(context).menaa,
          S.of(context).merouana,
          S.of(context).ngaous,
          S.of(context).ouledSiSlimane,
          S.of(context).rasElAioun,
          S.of(context).seggana,
          S.of(context).seriana,
          S.of(context).tazoult,
          S.of(context).tenietElAbed,
          S.of(context).timgad,
          S.of(context).tkout,
        ],
        S.of(context).wilaya06: [
          S.of(context).adekar,
          S.of(context).akbou,
          S.of(context).amizour,
          S.of(context).aokas,
          S.of(context).barbacha,
          S.of(context).bejaia,
          S.of(context).beniMaouche,
          S.of(context).chemini,
          S.of(context).darguina,
          S.of(context).elKseur,
          S.of(context).ighilAli,
          S.of(context).kherrata,
          S.of(context).ouzellaguen,
          S.of(context).seddouk,
          S.of(context).sidiAich,
          S.of(context).soukElTenine,
          S.of(context).tazmalt,
          S.of(context).tichy,
          S.of(context).timezrit,
        ],
        S.of(context).wilaya07: [
          S.of(context).biskra,
          S.of(context).djemorah,
          S.of(context).elKantara,
          S.of(context).mChouneche,
          S.of(context).sidiOkba,
          S.of(context).zeribetElOued,
          S.of(context).ourlal,
          S.of(context).tolga,
          S.of(context).ouledDjellal,
          S.of(context).sidiKhaled,
          S.of(context).foughala,
          S.of(context).elOutaya,
        ],
        S.of(context).wilaya08: [
          S.of(context).bechar,
          S.of(context).beniOunif,
          S.of(context).lahmar,
          S.of(context).kenadsa,
          S.of(context).taghit,
          S.of(context).abadla,
          S.of(context).tabelbala,
          S.of(context).igli,
          S.of(context).beniAbbes,
          S.of(context).elOuata,
          S.of(context).kerzaz,
          S.of(context).ouledKhoudir,
        ],
        S.of(context).wilaya09: [
          S.of(context).blida,
          S.of(context).boufarik,
          S.of(context).bougara,
          S.of(context).bouinan,
          S.of(context).elAffroun,
          S.of(context).larbaa,
          S.of(context).meftah,
          S.of(context).mouzaia,
          S.of(context).ouedAlleug,
          S.of(context).ouledYaich,
        ],
        S.of(context).wilaya10: [
          S.of(context).bouira,
          S.of(context).haizer,
          S.of(context).bechloul,
          S.of(context).mChedallah,
          S.of(context).kadiria,
          S.of(context).lakhdaria,
          S.of(context).birGhbalou,
          S.of(context).ainBessam,
          S.of(context).soukElKhemis,
          S.of(context).elHachimia,
          S.of(context).sourElGhozlane,
          S.of(context).bordjOkhriss,
        ],
        S.of(context).wilaya11: [
          S.of(context).abalessa,
          S.of(context).inGhar,
          S.of(context).inGuezzam,
          S.of(context).inSalah,
          S.of(context).tamanrasset,
          S.of(context).tazrouk,
          S.of(context).tinzaouten,
        ],
        S.of(context).wilaya12: [
          S.of(context).tebessa,
          S.of(context).elKouif,
          S.of(context).morsott,
          S.of(context).elMaLabiodh,
          S.of(context).elAouinet,
          S.of(context).ouenza,
          S.of(context).birMokkadem,
          S.of(context).birElAter,
          S.of(context).elOgla,
          S.of(context).oumAli,
          S.of(context).negrine,
          S.of(context).cheria,
        ],
        S.of(context).wilaya13: [
          S.of(context).ainTallout,
          S.of(context).babElAssa,
          S.of(context).beniBoussaid,
          S.of(context).beniSnous,
          S.of(context).bensekrane,
          S.of(context).chetouane,
          S.of(context).elAricha,
          S.of(context).fellaoucene,
          S.of(context).ghazaouet,
          S.of(context).hennaya,
          S.of(context).honaine,
          S.of(context).maghnia,
          S.of(context).mansourah,
          S.of(context).marsaBenMHidi,
          S.of(context).nedroma,
          S.of(context).ouledMimoun,
          S.of(context).remchi,
          S.of(context).sabra,
          S.of(context).sebdou,
          S.of(context).sidiDjillali,
          S.of(context).tlemcen,
        ],
        S.of(context).wilaya14: [
          S.of(context).tiaret,
          S.of(context).sougueur,
          S.of(context).ainDeheb,
          S.of(context).ainKermes,
          S.of(context).frenda,
          S.of(context).dahmouni,
          S.of(context).mahdia,
          S.of(context).hamadia,
          S.of(context).ksarChellala,
          S.of(context).medroussa,
          S.of(context).mechraSafa,
          S.of(context).rahouia,
          S.of(context).ouedLilli,
          S.of(context).meghila,
        ],
        S.of(context).wilaya15: [
          S.of(context).ainElHammam,
          S.of(context).azazga,
          S.of(context).azeffoun,
          S.of(context).beniDouala,
          S.of(context).beniYenni,
          S.of(context).boghni,
          S.of(context).bouzguen,
          S.of(context).draaBenKhedda,
          S.of(context).draaElMizan,
          S.of(context).iferhounen,
          S.of(context).larbaaNathIrathen,
          S.of(context).maatkas,
          S.of(context).makouda,
          S.of(context).mekla,
          S.of(context).ouacif,
          S.of(context).ouadhia,
          S.of(context).ouaguenoun,
          S.of(context).tigzirt,
          S.of(context).tiziGheniff,
          S.of(context).tiziOuzou,
          S.of(context).tiziRached,
        ],
        S.of(context).wilaya16: [
          S.of(context).zeralda,
          S.of(context).cheraga,
          S.of(context).draria,
          S.of(context).birMouradRais,
          S.of(context).birtouta,
          S.of(context).bouzareah,
          S.of(context).babElOued,
          S.of(context).sidiMHamed,
          S.of(context).husseinDey,
          S.of(context).elHarrach,
          S.of(context).baraki,
          S.of(context).darElBeida,
          S.of(context).rouiba,
        ],
        S.of(context).wilaya17: [
          S.of(context).ainElIbel,
          S.of(context).ainOussara,
          S.of(context).birine,
          S.of(context).charef,
          S.of(context).darChioukh,
          S.of(context).djelfa,
          S.of(context).elIdrissia,
          S.of(context).faidhElBotma,
          S.of(context).hadSahary,
          S.of(context).hassiBahbah,
          S.of(context).sidiLadjel,
          S.of(context).messaad,
        ],
        S.of(context).wilaya18: [
          S.of(context).chekfa,
          S.of(context).djimla,
          S.of(context).elAncer,
          S.of(context).elAouana,
          S.of(context).elMilia,
          S.of(context).jijel,
          S.of(context).settara,
          S.of(context).sidiMaarouf,
          S.of(context).taher,
          S.of(context).texenna,
          S.of(context).ziamaMansouriah,
        ],
        S.of(context).wilaya19: [
          S.of(context).ainArnat,
          S.of(context).ainAzel,
          S.of(context).ainElKebira,
          S.of(context).ainOulmene,
          S.of(context).amoucha,
          S.of(context).babor,
          S.of(context).beniAziz,
          S.of(context).beniOurtilane,
          S.of(context).birElArch,
          S.of(context).bouandas,
          S.of(context).bougaa,
          S.of(context).djemila,
          S.of(context).elEulma,
          S.of(context).guidjel,
          S.of(context).guenzet,
          S.of(context).hammamGuergour,
          S.of(context).hammamSoukhna,
          S.of(context).maoklane,
          S.of(context).salahBey,
          S.of(context).setif,
        ],
        S.of(context).wilaya20: [
          S.of(context).saida,
          S.of(context).ainElHadjar,
          S.of(context).sidiBoubekeur,
          S.of(context).elHassasna,
          S.of(context).ouledBrahim,
          S.of(context).youb,
        ],
        S.of(context).wilaya21: [
          S.of(context).azzaba,
          S.of(context).ainKechra,
          S.of(context).benAzzouz,
          S.of(context).collo,
          S.of(context).elHadaiek,
          S.of(context).elHarrouch,
          S.of(context).ouledAttia,
          S.of(context).oumToub,
          S.of(context).ramdaneDjamel,
          S.of(context).sidiMezghiche,
          S.of(context).skikda,
          S.of(context).tamalous,
          S.of(context).zitouna,
        ],
        S.of(context).wilaya22: [
          S.of(context).sidiBelAbbes,
          S.of(context).ainElBerd,
          S.of(context).benBadis,
          S.of(context).marhoum,
          S.of(context).merine,
          S.of(context).mostefaBenBrahim,
          S.of(context).moulaySlissen,
          S.of(context).rasElMa,
          S.of(context).sfisef,
          S.of(context).sidiAliBenyoub,
          S.of(context).sidiAliBoussidi,
          S.of(context).sidiLahcene,
          S.of(context).telagh,
          S.of(context).tenira,
          S.of(context).tessala,
        ],
        S.of(context).wilaya23: [
          S.of(context).annaba,
          S.of(context).ainBerda,
          S.of(context).elHadjar,
          S.of(context).berrahal,
          S.of(context).chetaibi,
          S.of(context).elBouni,
        ],
        S.of(context).wilaya24: [
          S.of(context).ainMakhlouf,
          S.of(context).bouchegouf,
          S.of(context).guelaatBouSbaa,
          S.of(context).guelma,
          S.of(context).hammamDebagh,
          S.of(context).hammamNBails,
          S.of(context).heliopolis,
          S.of(context).houariBoumediene,
          S.of(context).khezarra,
          S.of(context).ouedZenati,
        ],
        S.of(context).wilaya25: [
          S.of(context).constantine,
          S.of(context).elKhroub,
          S.of(context).ainAbid,
          S.of(context).zighoudYoucef,
          S.of(context).hammaBouziane,
          S.of(context).ibnZiad,
        ],
        S.of(context).wilaya26: [
          S.of(context).ainBoucif,
          S.of(context).aziz,
          S.of(context).beniSlimane,
          S.of(context).berrouaghia,
          S.of(context).chahbounia,
          S.of(context).chellalettElAdhaoura,
          S.of(context).elAzizia,
          S.of(context).elGuelbElKebir,
          S.of(context).elOmaria,
          S.of(context).ksarBoukhari,
          S.of(context).medea,
          S.of(context).ouamri,
          S.of(context).ouledAntar,
          S.of(context).ouzera,
          S.of(context).seghouane,
          S.of(context).sidiNaamane,
          S.of(context).siMahdjoub,
          S.of(context).souagui,
          S.of(context).tablat,
        ],
        S.of(context).wilaya27: [
          S.of(context).achaacha,
          S.of(context).ainNouissi,
          S.of(context).ainTadles,
          S.of(context).bouguirat,
          S.of(context).hassiMameche,
          S.of(context).kheireddine,
          S.of(context).mesra,
          S.of(context).mostaganem,
          S.of(context).sidiAli,
          S.of(context).sidiLakhdar,
        ],
        S.of(context).wilaya28: [
          S.of(context).mSila,
          S.of(context).hammamDalaa,
          S.of(context).ouledDerradj,
          S.of(context).sidiAissa,
          S.of(context).ainElMelh,
          S.of(context).benSrour,
          S.of(context).bouSaada,
          S.of(context).ouledSidiBrahim,
          S.of(context).sidiAmeur,
          S.of(context).magra,
          S.of(context).chellal,
          S.of(context).khoubana,
          S.of(context).medjedel,
          S.of(context).ainElHadjel,
          S.of(context).djebelMessaad,
        ],
        S.of(context).wilaya29: [
          S.of(context).ainFares,
          S.of(context).ainFekan,
          S.of(context).aouf,
          S.of(context).bouHanifia,
          S.of(context).elBordj,
          S.of(context).ghriss,
          S.of(context).hachem,
          S.of(context).mascara,
          S.of(context).mohammadia,
          S.of(context).oggaz,
          S.of(context).ouedElAbtal,
          S.of(context).ouedTaria,
          S.of(context).sig,
          S.of(context).tighennif,
          S.of(context).tizi,
          S.of(context).zahana,
        ],
        S.of(context).wilaya30: [
          S.of(context).elBorma,
          S.of(context).elHadjira,
          S.of(context).hassiMessaoud,
          S.of(context).megarine,
          S.of(context).nGoussa,
          S.of(context).ouargla,
          S.of(context).sidiKhouiled,
          S.of(context).taibet,
          S.of(context).tamacine,
          S.of(context).touggourt,
        ],
        S.of(context).wilaya31: [
          S.of(context).oran,
          S.of(context).ainElTurk,
          S.of(context).arzew,
          S.of(context).bethioua,
          S.of(context).esSenia,
          S.of(context).birElDjir,
          S.of(context).boutlelis,
          S.of(context).ouedTlelat,
          S.of(context).gdyel,
        ],
        S.of(context).wilaya32: [
          S.of(context).elBayadh,
          S.of(context).rogassa,
          S.of(context).brezina,
          S.of(context).elAbiodhSidiCheikh,
          S.of(context).bougtoub,
          S.of(context).chellala,
          S.of(context).boussemghoun,
          S.of(context).boualem,
        ],
        S.of(context).wilaya33: [
          S.of(context).illizi,
          S.of(context).djanet,
          S.of(context).inAmenas,
        ],
        S.of(context).wilaya34: [
          S.of(context).bordjBouArreridj,
          S.of(context).ainTaghrout,
          S.of(context).rasElOued,
          S.of(context).bordjGhedir,
          S.of(context).birKasdali,
          S.of(context).elHamadia,
          S.of(context).mansoura,
          S.of(context).medjana,
          S.of(context).bordjZemoura,
          S.of(context).djaafra,
        ],
        S.of(context).wilaya35: [
          S.of(context).baghlia,
          S.of(context).boudouaou,
          S.of(context).bordjMenaiel,
          S.of(context).boumerdes,
          S.of(context).dellys,
          S.of(context).khemisElKechna,
          S.of(context).isser,
          S.of(context).naciria,
          S.of(context).thenia,
        ],
        S.of(context).wilaya36: [
          S.of(context).elTarf,
          S.of(context).elKala,
          S.of(context).benMhidi,
          S.of(context).besbes,
          S.of(context).drean,
          S.of(context).bouhadjar,
          S.of(context).bouteldja,
        ],
        S.of(context).wilaya37: [
          S.of(context).tindouf,
        ],
        S.of(context).wilaya38: [
          S.of(context).ammari,
          S.of(context).bordjBouNaama,
          S.of(context).bordjElEmirAbdelkader,
          S.of(context).khemisti,
          S.of(context).lardjem,
          S.of(context).lazharia,
          S.of(context).thenietElHad,
          S.of(context).tissemsilt,
        ],
        S.of(context).wilaya39: [
          S.of(context).bayadha,
          S.of(context).debila,
          S.of(context).elOued,
          S.of(context).guemar,
          S.of(context).hassiKhalifa,
          S.of(context).magrane,
          S.of(context).mihOuensa,
          S.of(context).reguiba,
          S.of(context).robbah,
          S.of(context).talebLarbi,
        ],
        S.of(context).wilaya40: [
          S.of(context).khenchela,
          S.of(context).babar,
          S.of(context).bouhmama,
          S.of(context).chechar,
          S.of(context).elHamma,
          S.of(context).kais,
          S.of(context).ouledRechache,
          S.of(context).ainTouila,
        ],
        S.of(context).wilaya41: [
          S.of(context).birBouHaouch,
          S.of(context).heddada,
          S.of(context).mdaourouch,
          S.of(context).mechroha,
          S.of(context).merahna,
          S.of(context).ouledDriss,
          S.of(context).oumElAdhaim,
          S.of(context).sedrata,
          S.of(context).soukAhras,
          S.of(context).taoura,
        ],
        S.of(context).wilaya42: [
          S.of(context).ahmarElAin,
          S.of(context).bouIsmail,
          S.of(context).cherchell,
          S.of(context).damous,
          S.of(context).fouka,
          S.of(context).gouraya,
          S.of(context).hadjout,
          S.of(context).kolea,
          S.of(context).sidiAmar,
          S.of(context).tipaza,
        ],
        S.of(context).wilaya43: [
          S.of(context).mila,
          S.of(context).chelghoumLaid,
          S.of(context).ferdjioua,
          S.of(context).graremGouga,
          S.of(context).ouedEndja,
          S.of(context).rouached,
          S.of(context).terraiBainen,
          S.of(context).tassadaneHaddada,
          S.of(context).ainBeidaHarriche,
          S.of(context).sidiMerouane,
          S.of(context).teleghma,
          S.of(context).bouhatem,
          S.of(context).tadjenanet,
        ],
        S.of(context).wilaya44: [
          S.of(context).ainDefla,
          S.of(context).ainLechiekh,
          S.of(context).bathia,
          S.of(context).bordjEmirKhaled,
          S.of(context).boumedfaa,
          S.of(context).djelida,
          S.of(context).djendel,
          S.of(context).elAbadia,
          S.of(context).elAmra,
          S.of(context).elAttaf,
          S.of(context).hammamRigha,
          S.of(context).khemisMiliana,
          S.of(context).miliana,
          S.of(context).rouina,
        ],
        S.of(context).wilaya45: [
          S.of(context).naama,
          S.of(context).ainSefra,
          S.of(context).assela,
          S.of(context).makmanBenAmer,
          S.of(context).mecheria,
          S.of(context).moghrar,
          S.of(context).sfissifa,
        ],
        S.of(context).wilaya46: [
          S.of(context).ainElArbaa,
          S.of(context).ainKihal,
          S.of(context).ainTemouchent,
          S.of(context).beniSaf,
          S.of(context).elAmria,
          S.of(context).elMalah,
          S.of(context).hammamBouHadjar,
          S.of(context).oulhacaElGheraba,
        ],
        S.of(context).wilaya47: [
          S.of(context).ghardaia,
          S.of(context).elMeniaa,
          S.of(context).metlili,
          S.of(context).berriane,
          S.of(context).daiaBenDahoua,
          S.of(context).mansoura,
          S.of(context).zelfana,
          S.of(context).guerrara,
          S.of(context).bounoura,
        ],
        S.of(context).wilaya48: [
          S.of(context).ainTarek,
          S.of(context).ammiMoussa,
          S.of(context).djidioua,
          S.of(context).elHamadna,
          S.of(context).elMatmar,
          S.of(context).mazouna,
          S.of(context).mendes,
          S.of(context).ouedRhiou,
          S.of(context).ramka,
          S.of(context).relizane,
          S.of(context).sidiMHamedBenAli,
          S.of(context).yellel,
          S.of(context).zemmora,
        ],
        S.of(context).wilaya49: [
          S.of(context).timimoun,
          S.of(context).aougrout,
          S.of(context).tinerkouk,
          S.of(context).charouine,
        ],
        S.of(context).wilaya50: [
          S.of(context).bordjBadjiMokhtar,
        ],
        S.of(context).wilaya51: [
          S.of(context).ouledDjellal,
          S.of(context).sidiKhaled,
        ],
        S.of(context).wilaya52: [
          S.of(context).beniAbbes,
          S.of(context).kerzaz,
          S.of(context).elOuata,
          S.of(context).tabelbala,
          S.of(context).igli,
          S.of(context).ouledKhoudir,
          S.of(context).timoudi,
        ],
        S.of(context).wilaya53: [
          S.of(context).inSalah,
          S.of(context).inGhar,
        ],
        S.of(context).wilaya54: [
          S.of(context).inGuezzam,
          S.of(context).tinZaouatine,
        ],
        S.of(context).wilaya55: [
          S.of(context).elHadjira,
          S.of(context).megarine,
          S.of(context).taibet,
          S.of(context).tamacine,
          S.of(context).touggourt,
        ],
        S.of(context).wilaya56: [
          S.of(context).djanet,
        ],
        S.of(context).wilaya57: [
          S.of(context).elMGhair,
          S.of(context).djamaa,
        ],
        S.of(context).wilaya58: [
          S.of(context).elMeniaa,
        ],
      };
  static Map<String, String> buildDairaTranslationMap(BuildContext context) {
    final arabicMap = wilayas; // Arabic names
    final localizedMap = wilayasT(context); // Translated names

    final Map<String, String> translations = {};

    final arabicWilayasList = arabicMap.keys.toList();
    final localizedWilayasList = localizedMap.keys.toList();

    for (int i = 0; i < arabicWilayasList.length; i++) {
      final arabicWilaya = arabicWilayasList[i];
      if (i >= localizedWilayasList.length) continue; // safeguard
      final localizedWilaya = localizedWilayasList[i];

      translations[arabicWilaya] = localizedWilaya;

      final arabicDairas = arabicMap[arabicWilaya]!;
      final localizedDairas = localizedMap[localizedWilaya]!;

      for (int j = 0; j < arabicDairas.length; j++) {
        if (j >= localizedDairas.length) continue;
        translations[arabicDairas[j]] = localizedDairas[j];
      }
    }

    return translations;
  }

  static List<String> getMainCategories(
      String? productType, BuildContext context) {
    return productType != null
        ? ProductData.productTypeCategories(context)[productType]
                ?.keys
                .toList() ??
            []
        : [];
  }

  static List<String> getSubCategories(
      String? productType, String? category, BuildContext context) {
    if (productType != null && category != null) {
      return ProductData.productTypeCategories(context)[productType]
              ?[category] ??
          [];
    }
    return [];
  }

  static List<String> getProduct(
      String? productType, String? subCategory, BuildContext context) {
    if (productType != null && subCategory != null) {
      return ProductData.subCategoryDetails(context)[productType]
              ?[subCategory] ??
          [];
    }
    return [];
  }

  static List<String> getWilaya(BuildContext context) {
    return ProductData.wilayasT(context).keys.toList();
  }

  //widgets :

  static Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.secondaryContainer,
            prefixIcon: Icon(
              icon,
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
            ),
            labelText: hintText,
            labelStyle: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  static Widget buildDropdown2({
    required BuildContext context,
    required String? selectedValue,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: DropdownButtonFormField2<String>(
                isExpanded: true, // ✅ prevent horizontal overflow
                value: selectedValue,
                decoration: dropdownDecoration2(context, label),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  fontSize: 16,
                ),
                iconStyleData: IconStyleData(
                  iconEnabledColor: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                  iconDisabledColor: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                ),
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 180,
                  offset: const Offset(0, 0),
                  width: constraints.maxWidth, // ✅ fit safely within screen
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            overflow: TextOverflow
                                .ellipsis, // ✅ avoid long text overflow
                          ),
                        ))
                    .toList(),
                onChanged: onChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${S.of(context).pleaseSelectLabel} $label';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  static InputDecoration dropdownDecoration2(
      BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      filled: true,
      fillColor: colorScheme.secondaryContainer,
      labelText: label,
      labelStyle: TextStyle(
        color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static Widget actionButton({
    required BuildContext context,
    required String label,
    bool? isLoading,
    required VoidCallback? onPressed,
    Color? backgroundColor,
  }) {
    final bool loading = isLoading ?? false;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
