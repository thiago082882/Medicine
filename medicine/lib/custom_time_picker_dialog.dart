import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePickerDialog({Key? key, required this.onTimeSelected})
      : super(key: key);

  @override
  _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  int selectedHour = 0;
  int selectedMinute = 0;
  bool isAm = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.deepPurple[700],
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Selecione o Horário',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),

            // Time Selection (Hours and Minutes)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours
                _buildTimeSelector(
                  value: selectedHour,
                  max: 12,
                  onChanged: (value) {
                    setState(() {
                      selectedHour = value;
                    });
                  },
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                  ),
                ),
                // Minutes
                _buildTimeSelector(
                  value: selectedMinute,
                  max: 59,
                  onChanged: (value) {
                    setState(() {
                      selectedMinute = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // AM/PM Selection
            ToggleButtons(
              isSelected: [isAm, !isAm],
              onPressed: (index) {
                setState(() {
                  isAm = index == 0;
                });
              },
              borderRadius: BorderRadius.circular(20),
              color: Colors.white70,
              selectedColor: Colors.white,
              fillColor: Colors.purpleAccent,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
                  child: Text('AM'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
                  child: Text('PM'),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Buttons (Cancel/Confirm)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    final selectedTime = TimeOfDay(
                      hour: isAm
                          ? selectedHour
                          : (selectedHour % 12) + 12, // Converte para 24h
                      minute: selectedMinute,
                    );
                    widget.onTimeSelected(selectedTime);
                    Navigator.pop(context);
                  },
                  child: Text('Confirmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required int value,
    required int max,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      height: 20.h,
      width: 20.w,
      child: ListWheelScrollView.useDelegate(
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 50,
        onSelectedItemChanged: onChanged,
        perspective: 0.005,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            );
          },
          childCount: max + 1,
        ),
      ),
    );
  }
}
