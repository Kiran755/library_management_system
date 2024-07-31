import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/views/SearchBookViewer.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/constants/colors.dart';

class SearchView extends StatefulWidget {
  final String sapId, Name;
  const SearchView({Key? key, required this.sapId, required this.Name})
      : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String name = "";
  String dropdownvalue = "Algorithms And Data Structures";
  Map<String, String> domain = {
    "Algorithms And Data Structures": "AL-DSA",
    "Algorithms And Engineering Applications": "AL-EA",
    "Programming In C": "BES-CP",
    "Foundations of Information Technology": "BES-IT",
    "Programming in JAVA": "BES-JAVA",
    "Theory of Computer Science": "BES-TCS",
    "Image Processing": "HCI-IP",
    "Computer Graphics": "HCI-CGUR",
    "Computer Graphics 2": "HCI-CGVR",
    "Game Programming": "HCI-GAP",
    "Human Machine Interaction": "HCI-HMI",
    "Digital Principles": "HCI-IP",
    "User Interaction Design": "HCI-UID",
    "Computer Organization and Architecture": "HD-COA",
    "Digital Logic and DEsign and Applications": "HD-DLDA",
    "Discrete-Time Signal Processing": "HD-DSP",
    "Electronic Devices and Circuits": "HD-EDC",
    "Embedded Softwares": "HD-ES",
    "Electronic Principles": "HD-EM",
    "Electronic Networks": "HD-EN",
    "Microprocessors": "HD-MPMC",
    "Introduction To Nanatechnology": "HD-NT",
    "Advanced Databases": "IM-ADB",
    "500 Solved Problems": "IM-AI",
    "Database System Concepts": "IM-DBT",
    "Modern Data Warehousing Mining,and Visualization": "IM-DWM",
    "Data Mining": "IM-GUIDB",
    "Information Security Principles and Practices": "IM-ISMDR",
    "Information Storage and Management": "IM-ISMMDR",
    "Object Oriented Analysis and Design": "IR-OOAD",
    "Artificial Intelligence": "IS-AI",
    "Information Technology and E-Governance": "IS-EGOV",
    "Customer Relationship Management": "IS-ERPCRM",
    "Geographical Information Systems": "IS-GIS",
    "Information Security Incident Response and Disaster Recovery": "IS-ISMMDR",
    "E-Business": "IS-MEC",
    "Information Technology for Management": "IS-MIS",
    "Manufacturing Processess,Planning and Systems": "IS-MPPS",
    "Information Systems": "IS-MS",
    "Fuzzy Logic with Engineering Applications": "IS-NNFS",
    "Object Oriented Modelling and Design": "ITR-OOAD",
    "Software Architecture": "ITR-SA",
    "Software Engineering": "ITR-SE",
    "Service Oriented Architecture": "ITR-SOA",
    "Software Project Management": "ITR-SPM",
    "Software Quality Assurance": "ITR-SQA",
    "Software Testing": "ITR-ST",
    "International Journal of Information & Computation Tecnology": "JNL-IRPH",
    "GATE and Mathematics": "M",
    "Applied Mathematics": "MFA-CM",
    "Operating System": "MFA-DSGT",
    "Numerical Methods": "MFA-NM",
    "Discrete Event System Simulation": "MFA-SM",
    "Computer Networks": "NC-CN",
    "Distributed Systems": "NC-DS",
    "Network Security Design": "NC-INS",
    "Cryptography": "NC-IS",
    "Mobile Communication and Computing": "NC-MC",
    "Networking Technology": "NC-NTDD",
    "Communication Systems": "NC-PC",
    "Digital Communications": "NC-PCE",
    "Wireless Technology": "NC-WM",
    "Wireless And Mobile Network Architectures": "NC-WN",
    "Wireless Networks": "NL-WH",
    "Cryptography and Network Security": "NC-IS",
    "Cloud Computing": "OS-CC",
    "Compiler Construction": "OS-COM",
    "Distributed Computing": "OS-DC",
    "Operating Systems": "Operating Systems",
    "Messaging": "OS-OSC",
    "Managing uucp and Usenet": "OS-OSL",
    "Unix Operating System": "OS-UNIX",
    "ORACLE 9i: The Complete Reference": "PC",
    "Programming in ANSI X": "PL",
    "Theory of Computer Science 2": "SE-AT",
    "Internet Technology & Application": "WSP-IP",
    "Web X.0": "WST",
    "Internet Technology and Applications": "WST-IP",
    "J2EE 1.4 Projects": "WST-PMRC",
    "Web Technologies": "WST-IP",
  };

  List<String> domain_names = [];
  var items = [
    "Algorithms And Data Structures",
    "Algorithms And Engineering Applications",
    "Programming In C",
    "Foundations of Information Technology",
    "Programming in JAVA",
    "Theory of Computer Science",
    "Image Processing",
    "Computer Graphics",
    "Computer Graphics 2",
    "Game Programming",
    "Human Machine Interaction",
    "Digital Principles",
    "User Interaction Design",
    "Computer Organization and Architecture",
    "Digital Logic and Design and Applications",
    "Discrete-Time Signal Processing",
    "Electronic Devices and Circuits",
    "Embedded Softwares",
    "Electronic Principles",
    "Electronic Networks",
    "Microprocessors",
    "Introduction To Nanatechnology",
    "Advanced Databases",
    "500 Solved Problems",
    "Database System Concepts",
    "Modern Data Warehousing Mining,and Visualization",
    "Data Mining",
    "Information Security Principles and Practices",
    "Information Storage and Management",
    "Object Oriented Analysis and Design",
    "Artificial Intelligence",
    "Information Technology and E-Governance",
    "Customer Relationship Management",
    "Geographical Information Systems",
    "Information Security Incident Response and Disaster Recovery",
    "E-Business",
    "Information Technology for Management",
    "Manufacturing Processess,Planning and Systems",
    "Information Systems",
    "Fuzzy Logic with Engineering Applications",
    "Object Oriented Modelling and Design",
    "Software Architecture",
    "Software Engineering",
    "Service Oriented Architecture",
    "Software Project Management",
    "Software Quality Assurance",
    "Software Testing",
    "International Journal of Information & Computation Tecnology",
    "GATE and Mathematics",
    "Applied Mathematics",
    "Operating System",
    "Numerical Methods",
    "Discrete Event System Simulation",
    "Computer Networks",
    "Distributed Systems",
    "Network Security Design",
    "Cryptography",
    "Mobile Communication and Computing",
    "Networking Technology",
    "Communication Systems",
    "Digital Communications",
    "Wireless Technology",
    "Wireless And Mobile Network Architectures",
    "Wireless Networks",
    "Cryptography and Network Security",
    "Cloud Computing",
    "Compiler Construction",
    "Distributed Computing",
    "Operating Systems",
    "Messaging",
    "Managing uucp and Usenet",
    "Unix Operating System",
    "ORACLE 9i: The Complete Reference",
    "Programming in ANSI X",
    "Theory of Computer Science 2",
    "Internet Technology & Application",
    "Web X.0",
    "Internet Technology and Applications",
    "J2EE 1.4 Projects",
    "Web Technologies",
  ];
  var search = "awd";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColour,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: bgColour,
                  title: Card(
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 181, 113, 123),
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: const <BoxShadow>[
                          //   BoxShadow(
                          //     color: Color.fromRGBO(
                          //         0, 0, 0, 0.3), //shadow for button
                          //     blurRadius: 0,
                          //     spreadRadius: 0,
                          //     offset: Offset(0, 1)
                          //   ), //blur radius of shadow
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.72,
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor:
                                      const Color.fromARGB(255, 181, 113, 123),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  value: dropdownvalue,
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(domain[dropdownvalue] ?? dropdownvalue)
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    color: bgColour,
                    child: ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                              as Map<String, dynamic>;

                          if (name.isEmpty) {
                            return listItem(
                                context,
                                index,
                                data["AuthorName"],
                                data["BookCode"],
                                data["BookName"],
                                data["BookURL"],
                                data["Availability"],
                                data["Requested"],
                                widget.sapId,
                                widget.Name,
                                data["DomainName"],
                                (data['queue'] ?? []) as List<dynamic>);
                          }
                          if (data['AuthorName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name.toLowerCase()) ||
                              data['BookName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name.toLowerCase())) {
                            return listItem(
                                context,
                                index,
                                data["AuthorName"],
                                data["BookCode"],
                                data["BookName"],
                                data["BookURL"],
                                data["Availability"],
                                data["Requested"],
                                widget.sapId,
                                widget.Name,
                                data["DomainName"],
                                (data['queue'] ?? []) as List<dynamic>);
                          }
                          return Container();
                        }),
                  );
          },
        ));
  }
}

Widget listItem(
    BuildContext context,
    int index,
    String bookAuthor,
    String bookCode,
    String bookName,
    String value,
    String Availability,
    int requested,
    String sapId,
    String Name,
    String DomainName,
    List<dynamic> queue) {
  return SearchBookViewer(
      bookAuthor: bookAuthor,
      bookCode: bookCode,
      bookName: bookName,
      color: Colors.white,
      value: value,
      Availability: Availability,
      requested: requested,
      sapId: sapId,
      Name: Name,
      DomainName: DomainName,
      queue: queue);
}
