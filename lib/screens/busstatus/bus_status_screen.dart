import 'package:flutter/material.dart';

class BusStatusScreen extends StatefulWidget {
  const BusStatusScreen({super.key});

  @override
  State<BusStatusScreen> createState() => _BusStatusScreenState();
}

class _BusStatusScreenState extends State<BusStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4E4F7),
        title: Text("Bus Status"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Bus No',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Dept Time',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Arrival Time',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('12')),
                DataCell(Text('07:00 AM')),
                DataCell(Text('08:00 AM')),
                DataCell(Text('On time')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('13')),
                DataCell(Text('06:00 AM')),
                DataCell(Text('08:00 AM')),
                DataCell(Text('On time')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('14')),
                DataCell(Text('07:00 AM')),
                DataCell(Text('08:30 AM')),
                DataCell(Text('Late')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
