import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine/utils/constants.dart';
import 'package:medicine/utils/global_bloc.dart';
import 'package:medicine/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {Key? key}) : super(key: key);
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Remédio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            ExtendedSection(medicine: widget.medicine),
            Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  openAlertBox(context, _globalBloc);
                },
                child: Text(
                  'Excluir',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: kScaffoldColor),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }


  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kScaffoldColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                 // color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20.0)),
                ),
                padding: EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  'assets/icons/remedio.svg',
                  height: 90,
                  width: 90,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Excluir este lembrete?',
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Você tem certeza de que deseja excluir este lembrete? Esta ação não pode ser desfeita.',
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    _globalBloc.removeMedicine(widget.medicine);
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text(
                    'Excluir',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'Frasco') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/bottle.svg',
          colorFilter: ColorFilter.mode(kOtherColor, BlendMode.srcIn),
          height: 10.h, // Increased size
        ),
      );
    } else if (medicine!.medicineType == 'Pilula') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          colorFilter: ColorFilter.mode(kOtherColor, BlendMode.srcIn),
          height: 10.h, // Increased size
        ),
      );
    } else if (medicine!.medicineType == 'Seringa') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/syringe.svg',
          colorFilter: ColorFilter.mode(kOtherColor, BlendMode.srcIn),
          height: 10.h, // Increased size
        ),
      );
    } else if (medicine!.medicineType == 'Comprimido') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/tablet.svg',
          colorFilter: ColorFilter.mode(kOtherColor, BlendMode.srcIn),
          height: 10.h, // Increased size
        ),
      );
    }
    return Hero(
      tag: medicine!.medicineName! + medicine!.medicineType!,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        makeIcon(10.h), // Increased size
        SizedBox(
          width: 6.w, // Increased spacing
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: medicine!.medicineName!,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: 'Nome do Remédio',
                    fieldInfo: medicine!.medicineName!,
                  ),
                ),
              ),
              MainInfoTab(
                  fieldTitle: 'Dosagem',
                  fieldInfo: medicine!.dosage == 0
                      ? 'Não especificado'
                      : "${medicine!.dosage} mg"),
            ],
          ),
        ),
      ],
    );
  }
}


class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 10.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 0.3.h,
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Tipo de Remédio',
          fieldInfo: medicine!.medicineType! == 'None'
              ? 'Não especificado'
              : medicine!.medicineType!,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Intervalo de Dose',
          fieldInfo:
          'A cada ${medicine!.interval} horas   | ${medicine!.interval == 24 ? "Uma vez por dia" : "${(24 / medicine!.interval!).floor()} vezes por dia"}',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Hora de Início',
          fieldInfo:
          '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: kTextColor,
              ),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: kSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
