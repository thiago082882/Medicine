import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine/utils/constants.dart';
import 'package:medicine/main.dart';
import 'package:medicine/models/medicine.dart';
import 'package:medicine/pages/medicine_details/medicine_details.dart';
import 'package:medicine/pages/new_entry/new_entry_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utils/global_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kInputFieldColor,
        title: const Text('Minha Dose Diária'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            const TopContainer(),
            SizedBox(height: 2.h),
            const Expanded(child: BottomContainer()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewEntryPage(),
            ),
          );
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.add_outlined,
          size: 30.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'Cuide-se. \nViva mais saudável.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'Bem-vindo(a) ao Minha Dose Diária.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        StreamBuilder<List<Medicine>>(
          stream: globalBloc.medicineList$,
          builder: (context, snapshot) {
            final int medicineCount = snapshot.data?.length ?? 0;
            return Text(
              '$medicineCount medicamento(s) salvo(s)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder<List<Medicine>>(
      stream: globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Nenhum medicamento salvo.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.only(top: 1.h),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return MedicineCard(medicine: snapshot.data![index]);
          },
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  final Medicine medicine;

  Hero makeIcon() {
    final iconPath = {
      'Frasco': 'assets/icons/bottle.svg',
      'Pilula': 'assets/icons/pill.svg',
      'Seringa': 'assets/icons/syringe.svg',
      'Comprimido': 'assets/icons/tablet.svg',
    }[medicine.medicineType];

    if (iconPath != null) {
      return Hero(
        tag: '${medicine.medicineName}-${medicine.medicineType}',
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(kOtherColor, BlendMode.srcIn),
          height: 7.h,
        ),
      );
    }

    return Hero(
      tag: '${medicine.medicineName}-default',
      child: Icon(
        Icons.error,
        size: 7.h,
        color: kOtherColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicineDetails(medicine),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: kInputFieldColor,
          borderRadius: BorderRadius.circular(2.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeIcon(),
            SizedBox(height: 1.h),
            Text(
              medicine.medicineName!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              medicine.interval == 1
                  ? 'A cada ${medicine.interval} hora'
                  : 'A cada ${medicine.interval} horas',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
