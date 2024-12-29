import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine/utils/constants.dart';
import 'package:medicine/utils/global_bloc.dart';
import 'package:medicine/models/errors.dart';
import 'package:medicine/models/medicine.dart';
import 'package:medicine/pages/home_page.dart';
import 'package:medicine/pages/success_screen/success_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';
import '../../models/medicine_type.dart';
import '../../utils/select_time.dart';
import 'new_entry_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NewEntryBloc _newEntryBloc;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _newEntryBloc = NewEntryBloc();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Adicionar Novo Medicamento"),
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PanelTitle(
                  title: "Nome do Medicamento",
                  isRequired: true,
                ),
                TextFormField(
                  maxLength: 50,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: "",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: kOtherColor),
                  cursorColor: kOtherColor,
                ),
                const PanelTitle(
                  title: "Dosagem (em mg)",
                  isRequired: false,
                ),
                TextFormField(
                  maxLength: 12,
                  controller: dosageController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "",
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: kOtherColor),
                  cursorColor: kOtherColor,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 2.h),
                const PanelTitle(
                  title: "Tipo de Medicamento",
                  isRequired: false,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: StreamBuilder<MedicineType>(
                    stream: _newEntryBloc.selectedMedicineType,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MedicineTypeColumn(
                            medicineType: MedicineType.Frasco,
                            name: 'Frasco',
                            iconValue: 'assets/icons/bottle.svg',
                            isSelected: snapshot.data == MedicineType.Frasco,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.Pilula,
                            name: 'Pilula',
                            iconValue: 'assets/icons/pill.svg',
                            isSelected: snapshot.data == MedicineType.Pilula,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.Seringa,
                            name: 'Seringa',
                            iconValue: 'assets/icons/syringe.svg',
                            isSelected: snapshot.data == MedicineType.Seringa,
                          ),
                          MedicineTypeColumn(
                            medicineType: MedicineType.Comprimido,
                            name: 'Comprimido',
                            iconValue: 'assets/icons/tablet.svg',
                            isSelected: snapshot.data == MedicineType.Comprimido,
                          ),
                        ],
                      );
                    },
                  ),
                ),
            const PanelTitle(
              title: "Seleção de Intervalo",
              isRequired: true,
            ),
            const IntervalSelection(),
            const PanelTitle(
              title: "Hora de Início",
              isRequired: true,
            ),
            const SelectTime(),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Confirmar',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kScaffoldColor),

                      ),
                      onPressed: () {
                        String? medicineName;
                        int? dosage;

                        if (nameController.text == "") {
                          _newEntryBloc.submitError(EntryError.nameNull);
                          return;
                        }
                        if (nameController.text != "") {
                          medicineName = nameController.text;
                        }

                        if (dosageController.text == "") {
                          dosage = 0;
                        }
                        if (dosageController.text != "") {
                          dosage = int.parse(dosageController.text);
                        }

                        for (var medicine in globalBloc.medicineList$!.value) {
                          if (medicineName == medicine.medicineName) {
                            _newEntryBloc.submitError(EntryError.nameDuplicate);
                            return;
                          }
                        }

                        if (_newEntryBloc.selectIntervals!.value == 0) {
                          _newEntryBloc.submitError(EntryError.interval);
                          return;
                        }

                        if (_newEntryBloc.selectedTimeOfDay$!.value == 'None') {
                          _newEntryBloc.submitError(EntryError.startTime);
                          return;
                        }

                        String medicineType = _newEntryBloc
                            .selectedMedicineType!.value
                            .toString()
                            .substring(13);

                        int interval = _newEntryBloc.selectIntervals!.value;
                        String startTime =
                            _newEntryBloc.selectedTimeOfDay$!.value;

                        List<int> intIDs =
                        makeIDs(24 / _newEntryBloc.selectIntervals!.value);
                        List<String> notificationIDs =
                        intIDs.map((i) => i.toString()).toList();

                        Medicine newEntryMedicine = Medicine(
                            notificationIDs: notificationIDs,
                            medicineName: medicineName,
                            dosage: dosage,
                            medicineType: medicineType,
                            interval: interval,
                            startTime: startTime);

                        globalBloc.updateMedicineList(newEntryMedicine);

                        scheduleNotification(newEntryMedicine);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SuccessScreen()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError("Por favor, insira o nome do medicamento");
          break;
        case EntryError.nameDuplicate:
          displayError("O nome do medicamento já existe");
          break;
        case EntryError.dosage:
          displayError("Por favor, insira a dosagem necessária");
          break;
        case EntryError.interval:
          displayError("Por favor, selecione o intervalo da notificação");
          break;
        case EntryError.startTime:
          displayError("Por favor, selecione o horário de início da notificação");
          break;
        default:
      }
    });
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kOtherColor,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@drawable/remedio');

    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> scheduleNotification(Medicine medicine) async {

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      importance: Importance.max,
      ledColor: kOtherColor,
      ledOffMs: 2000,
      ledOnMs: 2000,
      enableLights: true,
    );

    // Configurações específicas para iOS
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    // Configurações gerais
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Validação e conversão segura do horário inicial
    if (medicine.startTime == null || medicine.startTime!.length < 4) {
      print("Erro: startTime está vazio ou no formato inválido.");
      return;
    }

    try {
      // Extraindo hora e minuto do formato "HHmm"
      int hour = int.tryParse(medicine.startTime!.substring(0, 2)) ?? 0;
      int minute = int.tryParse(medicine.startTime!.substring(2, 4)) ?? 0;

      // Agendamento para os horários baseados no intervalo
      for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
        if (hour + (medicine.interval! * i) > 23) {
          hour = hour + (medicine.interval! * i) - 24;
        } else {
          hour = hour + (medicine.interval! * i);
        }
        // Cria a data agendada baseada no fuso horário local
        DateTime now = DateTime.now();
        DateTime scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // Verificação se a data agendada está no futuro
        if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          '${medicine.medicineName} está programado para este horário.',
          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'É hora de tomar o seu ${medicine.medicineType!.toLowerCase()}, conforme o cronograma'
              : 'É hora de tomar o seu remédio, conforme o cronograma',
          tz.TZDateTime.from(scheduledDate, tz.local),
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exact, // Garante tempo exato
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
        );
      }
    } catch (e) {
      print("Erro ao agendar notificações: ${e.toString()}");
    }
  }
}


class IntervalSelection extends StatefulWidget {
  const IntervalSelection({Key? key}) : super(key: key);

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [6, 8, 12, 24];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Lembre-me a cada',
              style: Theme.of(context).textTheme.bodyMedium),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text(
              'Selecione intervalo',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: kPrimaryColor,

              ),
            )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
                  (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kSecondaryColor,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                    () {
                  _selected = newVal!;
                  newEntryBloc.updateInterval(newVal);
                },
              );
            },
          ),
          Text(_selected == 1 ? " hora" : " horas",
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn({
    Key? key,
    required this.medicineType,
    required this.name,
    required this.iconValue,
    required this.isSelected,
  }) : super(key: key);

  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final newEntryBloc = Provider.of<NewEntryBloc>(context, listen: false);
    return GestureDetector(
      onTap: () {
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.h),
              color: isSelected ? kOtherColor :kInputFieldColor,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                  color: isSelected ? kInputFieldColor : kOtherColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: isSelected ? Colors.white : kOtherColor,
                    fontSize: 16.3.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: title, style: Theme.of(context).textTheme.labelMedium),
            TextSpan(
              text: isRequired ? " *" : "",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}